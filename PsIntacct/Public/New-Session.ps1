<#

.LINK
https://groups.google.com/forum/#!msg/pester/ZgNpVc36Z0k/MzRXw2jpAAAJ

#>
function New-Session {

    [CmdletBinding()]
    param
    (
        [pscredential]$SenderCredential,
        [pscredential]$UserCredential,
        [string]$CompanyId
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"
    
    Write-Debug "Sender: $($SenderCredential.UserName)"
    Write-Debug "User: $($UserCredential.UserName)"
    Write-Debug "CompanyId: $($CompanyId)"

    $Function ="<function controlid='$( New-Guid )'><getAPISession /></function>"

    try
    {

      $Content = Send-Request -Credential $SenderCredential -Login $UserCredential -CompanyId $CompanyId -Function $Function
  
      Write-Debug "control status: $($Content.response.control.status)"
      Write-Debug "authentication status: $($Content.response.operation.authentication.status)"
      Write-Debug "result status: $($Content.response.operation.result.status)"

      if ( $Content.response.operation.authentication.status -eq 'failure' )
      {
            # create ErrorRecord
            $Exception = New-Object ApplicationException $Content.response.operation.errormessage.error.description2
            $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $($Content.response.operation.errormessage.error.errorno)"
            $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
            $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content

            # write ErrorRecord
            Write-Error -ErrorRecord $ErrorRecord -RecommendedAction $Content.response.operation.result.errormessage.error.correction
      }

      elseif ( $Content.response.operation.result.status -eq 'success' )
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

      elseif ( $Content.response.operation.result.status -eq 'failure' )
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
      } # /if

    } # /try

    catch [Microsoft.PowerShell.Commands.HttpResponseException]
    {
      # HTTP exceptions
      Write-Error $_ # "$($_.Exception.Response.ReasonPhrase) [$($_.Exception.Response.StatusCode.value__)]"
    }

}
