<#
.SYNOPSIS
Create an A/R adjustment.

.PARAMETER Session
The Session object returned by New-IntacctSession.

.PARAMETER ARAdjustmentXml
The Xml representation of an ARAdjustment, from ConvertTo-ARAdjustment

.LINK
https://developer.intacct.com/api/accounts-receivable/ar-payments/

#>
function New-ARAdjustment {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,
        
        [Parameter(ValueFromPipeline,Mandatory)]
        [xml]$ARAdjustmentXml
    )

    begin 
    {
        Write-Debug $MyInvocation.MyCommand.Name
    }

    process 
    {

        $Function =
            "<function controlid='$( New-Guid )'>
                $( $ARAdjustmentXml.OuterXml )
            </function>"
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
                $ErrorMessage = "{0} [{1}]: {2}" -f $ARAdjustmentXml.create_aradjustment.adjustmentno, $ARAdjustmentXml.create_aradjustment.customerid, $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        } # /switch

    } # /process

    end {}

}
