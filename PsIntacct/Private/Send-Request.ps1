<#
.SYNOPSIS
Sends an XML request to Intacct's API endpoint.

.PARAMETER Credential
PsCredential object that contains the sender_id and sender_password

.PARAMETER Session
PsCustomObject that contains the session_id and endpoint.

.PARAMETER Login
PsCredential that contains the user's credentials.

.PARAMETER CompanyId
The company_id associated with the user.

.PARAMETER Function
One or more function nodes that contain the verbs and nouns to be processed.

.PARAMETER Unique
Sets the control's uniqueid element to $true.

.PARAMETER Transaction
Sets the operation's transaction attribute to $true.

#>
function Send-Request {

    [CmdletBinding()]
    param
    (
        [Parameter(ParameterSetName='ForLogin', Mandatory)]
        [Parameter(ParameterSetName='ForSession', Mandatory)]
        [pscredential]$Credential,

        [Parameter(ParameterSetName='ForSession', Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ParameterSetName='ForLogin', Mandatory)]
        [pscredential]$Login,

        [Parameter(ParameterSetName='ForLogin', Mandatory)]
        [string]$CompanyId,

        [Parameter(ParameterSetName='ForLogin', Mandatory)]
        [Parameter(ParameterSetName='ForSession', Mandatory)]
        [Parameter( Mandatory)]
        [string]$Function,

        [Parameter(ParameterSetName='ForSession')]
        [switch]$Unique,

        [Parameter(ParameterSetName='ForSession')]
        [switch]$Transaction
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"
    
    $Uri = 
        if ($Session.endpoint) {$Session.endpoint} 
        else {'https://api.intacct.com/ia/xml/xmlgw.phtml'}
    Write-Debug "Uri: $Uri"

    #
    # <companyid/> must preceed <password/> or login will fail
    #

    $Authentication = 
        if ($Login)
        {
            "<login>
                <userid>$( $Login.UserName )</userid>
                <companyid>$( $CompanyId )</companyid>
                <password>$( $Login | ConvertTo-PlainText )</password>
            </login>"
        }
        elseif ($Session)
        {
            "<sessionid>$($Session.sessionid)</sessionid>"
        }
    
    $Body=
@"
<?xml version="1.0" encoding="UTF-8"?>
<request>
    <control>
        <senderid>$( $Credential.UserName )</senderid>
        <password>$( $Credential | ConvertTo-PlainText )</password>
        <controlid>$( Get-Date -UFormat %s )</controlid>
        <uniqueid>$( $Unique.ToString().ToLower() )</uniqueid>
        <dtdversion>3.0</dtdversion>
        <includewhitespace>false</includewhitespace>
    </control>
    <operation $( if ($Transaction) {"transaction='true'"} )>
        <authentication>
            $Authentication
        </authentication>
        <content>
            $Function
        </content>
    </operation>
</request>
"@

    Write-Debug $Body

    try {

        $Response = Invoke-WebRequest -Method POST -Uri $Uri -Body $Body -ContentType 'application/xml' -Verbose:$false
        $Content = [xml]$Response.Content

        Write-Debug "status: $($Content.response.control.status)"
        switch ( $Content.response.control.status )
        {
            'success'
            {
                $Content
            }
            'failure'
            {
                $errorno = $Content.response.errormessage.ChildNodes[0].errorno
                $description2 = $Content.response.errormessage.ChildNodes[0].description2

                switch ($errorno) {
                    'XL03000006' # Incorrect Intacct XML Partner ID or password.
                    {
                        # create ErrorRecord
                        $Exception = New-Object -TypeName System.Security.Authentication.InvalidCredentialException($description2)
                        $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $description2 [$errorno]"
                        $ErrorCategory = [System.Management.Automation.ErrorCategory]::AuthenticationError
                        $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content
                    }
                    Default {
                        # create ErrorRecord
                        $Exception = New-Object ApplicationException $description2
                        $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $($errorno)"
                        $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
                        $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content
                    }
                }

                $PSCmdlet.ThrowTerminatingError($ErrorRecord)

            }
        }

    }
    catch [Microsoft.PowerShell.Commands.HttpResponseException]
    {
      Write-Error "$($_.Exception.Response.ReasonPhrase) [$($_.Exception.Response.StatusCode.value__)]"
        # Write-Error "HttpResponseException: $($_.Exception.Response.ReasonPhrase)" # Internal Server Error
        # Write-Error $_.Exception.Message # Response status code does not indicate success: 500 (Internal Server Error).
    }
    catch {
        throw $_
    }

}
