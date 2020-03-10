<#
.SYNOPSIS
Create an A/R payment.

.DESCRIPTION
An ARPYMT is composed of header information and one or more payment detail (ARPYMTDETAIL) objects. A payment detail can specify either the invoice/debit memo as a whole (header level), or it can specify a line item. A payment detail also provides a transaction amount to pay, and can include an inline credit or discount. Note that the ARPYMT object does not currently support advances—continue to use the legacy create_arpayment function for that purpose.

With ARPYMT, you can apply multiple credits to the same line by providing multiple payment details for that line. You can also apply credits or discounts from a different invoice (for the same customer) on the current invoice.

When a payment does not cover the total balance, each line is paid in full, starting with the first line and continuing down the list. This is known as the waterfall method, and it means that you should list any high priority payments first in invoices/debit memos.

.PARAMETER Session
The Session object returned by New-Session.

.PARAMETER PaymentMethod
Payment method. Use Printed Check, Cash, EFT, Credit Card, Online Charge Card, or Online ACH Debit.

.PARAMETER CustomerId
The customer's ID.

.PARAMETER ReceiptDate
Receipt date in the mm/dd/yyyy format. This is the date on which to post to the GL.

.PARAMETER Currency
Transaction currency code.  For example, 'USD'.

.LINK
https://developer.intacct.com/api/accounts-receivable/ar-payments/

#>
function New-ARPayment {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,
        
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet('Printed Check', 'Cash', 'EFT', 'Credit Card', 'Online Charge Card', 'Online ACH Debit')]
        [string]$PaymentMethod,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$CustomerId,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [datetime]$ReceiptDate,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$Currency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DocNumber,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FinancialEntity,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ExchangeRateTypeId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ExchangeRate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$PaymentDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$PaymentAmount,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TxPaymentAmount,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PrBatch,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$InvoicePaidDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BaseCurrency

    )

    Write-Debug "EXCH_RATE_TYPE_ID: $EXCH_RATE_TYPE_ID"
    Write-Debug "EXCHANGE_RATE: $EXCHANGE_RATE"

    $Function =
@"
<function controlid="$( New-Guid )">
    <create>
        <ARPYMT>
            <PAYMENTMETHOD>$PaymentMethod</PAYMENTMETHOD>
            <CUSTOMERID>$CustomerId</CUSTOMERID>
            <RECEIPTDATE>$($ReceiptDate.ToString("MM/dd/yyyy"))</RECEIPTDATE>
            <CURRENCY>$Currency</CURRENCY>
            <!-- OPTIONAL -->
            <DESCRIPTION>$Description</DESCRIPTION>
            <DOCNUMBER>$DocNumber</DOCNUMBER>
            <FINANCIALENTITY>$FinancialEntity</FINANCIALENTITY>
            <EXCH_RATE_TYPE_ID>$ExchangeRateTypeId</EXCH_RATE_TYPE_ID>
            <EXCHANGE_RATE>$ExchangeRate</EXCHANGE_RATE>
            <PAYMENTDATE>$( if ( $null -ne $PaymentDate ) { $PaymentDate.ToString("MM/dd/yyyy") } )</PAYMENTDATE>
            <AMOUNTOPAY>$PaymentAmount</AMOUNTOPAY>
            <TRX_AMOUNTTOPAY>$TxPaymentAmount</TRX_AMOUNTTOPAY>
            <PRBATCH>$PrBatch</PRBATCH>
            <WHENPAID>$( if ( $null -ne $InvoicePaidDate ) { $InvoicePaidDate.ToString("MM/dd/yyyy") } )</WHENPAID>
            <BASECURR>$BaseCurrency</BASECURR>
        </ARPYMT>
    </create>
</function>
"@
    Write-Debug $Function

<#
<ARPYMTDETAILS>
    <ARPYMTDETAIL>
        <RECORDKEY>101</RECORDKEY>
        <TRX_PAYMENTAMOUNT>125</TRX_PAYMENTAMOUNT>
    </ARPYMTDETAIL>
</ARPYMTDETAILS>
#>
    try
    {
        $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function

        Write-Debug "status: $($Content.response.operation.result.status)"
    }
    catch
    {
        $_
    }

}
