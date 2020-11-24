<#
.SYNOPSIS
Create an A/R payment.

.PARAMETER Session
The Session object returned by New-IntacctSession.

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
        [xml]$ARPaymentXml,

        [switch]$Legacy
    )

    begin 
    {
        Write-Debug $MyInvocation.MyCommand.Name
    }

    process 
    {

        $Function = 
        if ( $Legacy )
        {
            "<function controlid='$( New-Guid )'>
                    $( $ARPaymentXml.OuterXml )
            </function>"
        }
        else
        {
            "<function controlid='$( New-Guid )'>
                <create>
                    $( $ARPaymentXml.OuterXml )
                </create>
            </function>"
        }

        Write-Debug $Function

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
                # return the first error
                $Err = $Content.response.operation.result.errormessage.FirstChild
                $ErrorId = "{0}::{1} - {2}" -f $MyInvocation.MyCommand.Module.Name, $MyInvocation.MyCommand.Name, $Err.errorno
                $ErrorMessage = "{0} [{1}]: {2}" -f $ARPaymentXml.ARPYMT.DOCNUMBER, $ARPaymentXml.ARPYMT.CUSTOMERID, $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        } # /switch

    } # /process

    end {}

}
