function Get-Contact {

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

    Write-Debug "Sender: $($Session.Credential.UserName)"
    Write-Debug "sessionid: $($Session.sessionid)"
    Write-Debug "endpoint: $($Session.endpoint)"

    $Password = $Session.Credential | ConvertTo-PlainText
    $Timestamp = Get-Date -UFormat %s
    $Guid = New-Guid

    $Function = `
    if ($Id)
    {
@"
<read>
    <object>CONTACT</object>
    <keys>$Id</keys>
    <fields>*</fields>
</read>
"@        
    }
    elseif ($Name)
    {
@"
<readByName>
    <object>CONTACT</object>
    <keys>$Name</keys>
    <fields>*</fields>
</readByName>
"@      
    }

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

    # Write-Debug $Body

    try
    {
      $Response = Invoke-WebRequest -Method POST -Uri $Session.endpoint -Body $Body -ContentType 'application/xml'

      $Content = [xml]$Response.Content
  
      Write-Debug "status: $($Content.response.control.status)"

      switch ( $Content.response.control.status )
      {
        'success'
        {  
            $Content.response.operation.result.data.contact
        }
        'failure'
        { 
          Write-Debug "Error: $($Content.response.errormessage.error.description2)"
          # raise an exception
          Write-Error -Message $Content.response.errormessage.error.description2
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
      Write-Error $_.Exception.Message
    }

}
