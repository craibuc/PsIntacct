<#
.SYNOPSIS

.PARAMETER CustomerId
Customer ID

.PARAMETER DateCreated
Transaction date

#>
function Set-Invoice {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory,ValueFromPipeline)]
        [string]$InvoiceXml
    )
        
    begin
    {
        throw [System.NotImplementedException] "Set-Invoice function has not be implemented."
        
        Write-Debug "$($MyInvocation.MyCommand.Name)::Begin"
    }
    
    process 
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)::Process"

        $Function = 
            "
            <function controlid='$( New-Guid )'>
                <update_invoice key=''>
                    $( [xml]$InvoiceXml.invoice.InnerXml )
                </update_invoice>
            </function>
            "

        Write-Debug $Function

        try
        {
            # $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
            # Write-Debug "status: $($Content.response.operation.result.status)"
        }
        catch
        {
            $_
        }

    }
    
    end {}

}
