<#

.LINK
https://groups.google.com/forum/#!msg/pester/ZgNpVc36Z0k/MzRXw2jpAAAJ

#>
function New-Session {

    [CmdletBinding()]
    param
    (
        [pscredential]$SenderCredential,
        [pscredential]$UserCredential
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"
    
    Write-Debug "Sender: $($SenderCredential.UserName)"
    Write-Debug "User: $($UserCredential.UserName)"

    $Uri = 'https://api.intacct.com/ia/xml/xmlgw.phtml'
    $Body = `
@"
<?xml version="1.0" encoding="UTF-8"?>
<request>
  <control>
    <senderid>$( $SenderCredential.UserName )</senderid>
    <password>$( $SenderCredential | ConvertTo-PlainText  )</password>
    <controlid>$( Get-Date -UFormat %s )</controlid>
    <uniqueid>false</uniqueid>
    <dtdversion>3.0</dtdversion>
    <includewhitespace>false</includewhitespace>
  </control>
  <operation>
    <authentication>
      <login>
        <userid>$( $UserCredential.UserName )</userid>
        <companyid>$( $UserCredential.Company )</companyid>
        <password>$( $UserCredential | ConvertTo-PlainText )</password>
      </login>
    </authentication>
    <content>
      <function controlid='$( New-Guid )'>
        <getAPISession />
      </function>
    </content>
  </operation>
</request>
"@

    Write-Debug $Body

    try
    {
      $Response = Invoke-WebRequest -Method POST -Uri $Uri -Body $Body -ContentType 'application/xml'

      $Content = [xml]$Response.Content
  
      Write-Debug "status: $($Content.response.control.status)"

      switch ( $Content.response.control.status )
      {
        'success'
        {
          Write-Debug "sessionid: $( $Content.response.operation.result.data.api.sessionid )"
          Write-Debug "endpoint: $( $Content.response.operation.result.data.api.endpoint )"
  
          # returns PsCustomObject representation of object
          [PsCustomObject]@{
            Credential = $SenderCredential
            sessionid = $Content.response.operation.result.data.api.sessionid
            endpoint = $Content.response.operation.result.data.api.endpoint
          }
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
