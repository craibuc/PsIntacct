<#
.SYNOPSIS
Update an invoice.

.PARAMETER Session
The Session object returned by New-Session.

.PARAMETER InvoiceXml
The Xml representation of an InvoiceXml, from ConvertTo-InvoiceXml

.LINK
https://developer.intacct.com/api/accounts-receivable/invoices/#update-invoice-legacy

#>
function Set-Invoice {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$InvoiceXml
    )
        
    begin
    {
        # Write-Debug "$($MyInvocation.MyCommand.Name)::Begin"
    }
    
    process 
    {
        throw [System.NotImplementedException] "Set-Invoice function has not be implemented."

        $Function = 
            "<function controlid='$( New-Guid )'>
                $( $InvoiceXml.OuterXml )
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
                $ErrorMessage = "{0} [{1}]: {2}" -f $InvoiceXml.update_invoice.invoiceno, $InvoiceXml.update_invoice.customerid, $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        } # /switch
    }
    
    end {}

}
