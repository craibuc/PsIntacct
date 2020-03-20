<#
.SYNOPSIS
Create an A/R payment.

.PARAMETER Session
The Session object returned by New-Session.

.PARAMETER ARPaymentXml
The Xml representation of an ARPayment, from ConvertTo-ARPayment

.LINK
https://developer.intacct.com/api/accounts-receivable/ar-payments/

#>
function New-ARPayment {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,
        
        [Parameter(ValueFromPipeline,Mandatory)]
        [xml]$ARPaymentXml
    )

    $Function =
        "<function controlid='$( New-Guid )'>
            <create>
                $( $ARPaymentXml.OuterXml )
            </create>
        </function>"

    Write-Debug $Function

    try
    {
        $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function

        Write-Debug "status: $($Content.response.operation.result.status)"
        switch ( $Content.response.operation.result.status )
        {
            'success'
            {  
                $Content.response.operation.result
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
            }
        } # /switch

    }
    catch
    {
        $_
    }

}
