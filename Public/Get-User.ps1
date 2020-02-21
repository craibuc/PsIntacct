function Get-User {

    [CmdletBinding()]
    param
    (
		[Parameter(ParameterSetName='ByID', Mandatory = $true)]
		[Parameter(ParameterSetName='ByName', Mandatory = $true)]
        [pscustomobject]$Session,

        [Parameter(ParameterSetName='ByID', Mandatory = $true)]
        [int]$Id,

		[Parameter(ParameterSetName='ByName', Mandatory = $true)]
        [string]$Name
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"

    # Write-Debug "Sender: $($Session.Credential.UserName)"
    # Write-Debug "sessionid: $($Session.sessionid)"
    # Write-Debug "endpoint: $($Session.endpoint)"

    # $Password = $Session.Credential | ConvertTo-PlainText
    # $Timestamp = Get-Date -UFormat %s
    $Guid = New-Guid

    $Function = `
        if ($Id)
        {
@"
<function controlid='$Guid'>
    <read>
        <object>USERINFO</object>
        <keys>$Id</keys>
        <fields>*</fields>
    </read>
</function>
"@        
        }
        elseif ($Name)
        {
@"
<function controlid='$Guid'>
    <readByName>
        <object>USERINFO</object>
        <keys>$Name</keys>
        <fields>*</fields>
    </readByName>
</function>
"@      
        }
<#
        else
        {
@"
<readByQuery>
    <object>USERINFO</object>
    <fields>*</fields>
    <query></query>
    <pagesize>100</pagesize>
</readByQuery>
"@        
        }
#>
<#
    $Body = `
@"
<?xml version="1.0" encoding="UTF-8"?>
<request>
    <control>
        <senderid>$($Session.Credential.UserName)</senderid>
        <password>$Password</password>
        <controlid>$Timestamp</controlid>
        <uniqueid>false</uniqueid>
        <dtdversion>3.0</dtdversion>
        <includewhitespace>false</includewhitespace>
    </control>
    <operation>
        <authentication>
        	<sessionid>$($Session.sessionid)</sessionid>
        </authentication>
        <content>
            <function controlid='$Guid'>
                $Function
            </function>
        </content>
    </operation>
</request>
"@

    Write-Debug $Body
#>

    try
    {
        $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
        # $Response = Invoke-WebRequest -Method POST -Uri $Session.endpoint -Body $Body -ContentType 'application/xml'
        # $Content = [xml]$Response.Content

        Write-Debug "status: $($Content.response.operation.result.status)"

        switch ( $Content.response.operation.result.status )
        {
            'success'
            {  
                Write-Debug "count: $($Content.response.operation.result.data.count)"

                if ( $Content.response.operation.result.data.count -gt 0 )
                {
                    $Content.response.operation.result.data.USERINFO
                }
                else
                {
                    Write-Error "User $( if ($Id) { "$Id" } elseif ($Name) { "'$Name'" } ) not found"
                }

            }
            'failure'
            { 
                Write-Debug "Module: $($MyInvocation.MyCommand.Module.Name)"
                Write-Debug "Command: $($MyInvocation.MyCommand.Name)"
                Write-Debug "description2: $($Content.response.operation.result.errormessage.error.description2)"
                Write-Debug "correction: $($Content.response.operation.result.errormessage.error.correction)"

                # create ErrorRecord
                $Exception = New-Object ApplicationException $Content.response.operation.result.errormessage.error.description2
                $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $($Content.response.operation.result.errormessage.error.errorno)"
                $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
                $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content

                # write ErrorRecord
                Write-Error -ErrorRecord $ErrorRecord -RecommendedAction $Content.response.operation.result.errormessage.error.correction
                # Write-Error -Message $Content.response.operation.result.errormessage.error.description2 -RecommendedAction $Content.response.operation.result.errormessage.error.correction

            }    
        } # /switch

    }
    catch [Microsoft.PowerShell.Commands.HttpResponseException]
    {
      # HTTP exceptions
      Write-Error "$($_.Exception.Response.ReasonPhrase) [$($_.Exception.Response.StatusCode.value__)]"
    }
    catch
    {
      # all other exceptions
      Write-Error $_ #.Exception.Message
    }

}
