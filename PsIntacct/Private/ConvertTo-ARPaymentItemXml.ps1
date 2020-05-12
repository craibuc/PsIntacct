<#
.SYNOPSIS

.PARAMETER invoicekey
Transaction record number to apply payment to

.PARAMETER amount
Amount to apply. This must be less than or equal to paymentamount element of payment.

.OUTPUTS System.Xml.XmlDocument

#>
function ConvertTo-ARPaymentItemXml {

    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [int]$invoicekey,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [decimal]$amount
    )

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<arpaymentitems>")
    }
    process
    {
        [void]$SB.Append("<arpaymentitem>")
        [void]$SB.Append("<invoicekey>$invoicekey</invoicekey>")
        [void]$SB.Append("<amount>$amount</amount>")
        [void]$SB.Append("</arpaymentitem>")
    }
    end 
    {
        [void]$SB.Append("</arpaymentitems>")
        [xml]$SB.ToString()
    }

}
