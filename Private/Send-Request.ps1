<#
.SYNOPSIS
Sends an XML request to Intacct's API endpoint.

.PARAMETER Credential
PsCredential object that contains the sender_id and sender_password

.PARAMETER Session
PsCustomObject that contains the session_id and endpoint.

.PARAMETER Login
PsCustomObject that contains the user_id, company_id, and user_password.

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
        [pscustomobject]$Login,

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

    $Authentication = 
        if ($Login)
        {
            "<login>
                <userid>$( $Login.userid )</userid>
                <companyid>$( $Login.companyid )</companyid>
                <password>$( $Login.password )</password>
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

    Write-Debug "Body: $Body"

    try {

        $Response = Invoke-WebRequest -Method POST -Uri $Uri -Body $Body -ContentType 'application/xml'
        [xml]$Response.Content
    }
    # catch [Microsoft.PowerShell.Commands.HttpResponseException]
    # {
    #   Write-Error "$($_.Exception.Response.ReasonPhrase) [$($_.Exception.Response.StatusCode.value__)]"
    #     # Write-Error "HttpResponseException: $($_.Exception.Response.ReasonPhrase)" # Internal Server Error
    #     # Write-Error $_.Exception.Message # Response status code does not indicate success: 500 (Internal Server Error).
    # }
    catch {
        Write-Error $_
    }

}
