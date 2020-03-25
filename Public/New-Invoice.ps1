<#
.SYNOPSIS

.PARAMETER Session

.PARAMETER InvoiceXml

#>
function New-Invoice {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$InvoiceXml
    )
        
    begin 
    {
        # Write-Debug "$($MyInvocation.MyCommand.Name)"
    }
    
    process 
    {

        [xml]$Function = 
            "<function controlid='$( New-Guid )'>
                $( $InvoiceXml.OuterXml )
            </function>"

        Write-Debug $Function.OuterXml

        $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function.OuterXml

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
                $ErrorMessage = "{0} [{1}]: {2}" -f $InvoiceXml.create_invoice.invoiceno, $InvoiceXml.create_invoice.customerid, $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        } # /switch

    }
    
    end {}

}
