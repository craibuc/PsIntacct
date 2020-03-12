<#
.SYNOPSIS
Convert ARPaymentDetail model to Xml.

.PARAMETER RECORDKEY
Required	integer	Record number of the invoice being paid. You can pay either an invoice or a debit memo (via POSADJKEY), but not both in one payment detail.
.PARAMETER ENTRYKEY
Optional	integer	Record number of the line of the invoice being paid. If not supplied, lines of the invoice are paid using the waterfall method.
.PARAMETER POSADJKEY
Optional	integer	Record number of a debit memo being paid. Use readByQuery on ARADJUSTMENT to get the key. You can pay either a debit memo or an invoice (via RECORDKEY), but not both in one payment detail.
.PARAMETER POSADJENTRYKEY
Optional	integer	Record number of debit memo line
.PARAMETER TRX_PAYMENTAMOUNT
Optional	currency	Amount of the cash payment. Must be the full amount of the invoice or debit memo (with the discount amount calculated in) in order to apply a discount.
.PARAMETER ADJUSTMENTKEY
Optional	integer	Record number of a credit memo. Use readByQuery on ARADJUSTMENT to get the key.
.PARAMETER ADJUSTMENTENTRYKEY
Optional	integer	Record number of a credit memo line to apply to the payment
.PARAMETER TRX_ADJUSTMENTAMOUNT
Optional	currency	Adjustment transaction amount to apply to the payment
.PARAMETER INLINEKEY
Optional	integer	Record number of the invoice with inline credits to apply to the payment (typically from the same invoice that is being paid). Inline credits must be enabled in the AR configuration.
.PARAMETER INLINEENTRYKEY
Optional	integer	Record number of the invoice line with the inline credit apply to the payment
.PARAMETER TRX_INLINEAMOUNT
Optional	currency	Inline credit amount to apply to the payment
.PARAMETER ADVANCEKEY
Optional	integer	Record number of an advance to apply to the payment
.PARAMETER ADVANCEENTRYKEY
Optional	integer	Record number of an advance line to apply to the payment
.PARAMETER TRX_POSTEDADVANCEAMOUNT
Optional	currency	Advance credit amount to apply to the payment
.PARAMETER OVERPAYMENTKEY
Optional	integer	Record number of an overpayment to apply to the payment. To find available overpayments, use readByQuery on ARPYMT.
.PARAMETER OVERPAYMENTENTRYKEY
Optional	integer	Record number of an overpayment line to apply to the payment
.PARAMETER TRX_POSTEDOVERPAYMENTAMOUNT
Optional	currency	Overpayment credit amount to apply to the payment
.PARAMETER NEGATIVEINVOICEKEY
Optional	integer	Record number of a negative invoice to apply to the payment
.PARAMETER NEGATIVEINVOICEENTRYKEY
Optional	integer	Record number of a negative invoice line to apply to the payment
.PARAMETER TRX_NEGATIVEINVOICEAMOUNT
Optional	currency	Negative invoice amount to apply to the payment
.PARAMETER DISCOUNTDATE
Optional	string	Discount date in the mm/dd/yyyy format. All discounts available at this date are applied. You can supply a date in the past to access a discount whose deadline has already passed. You must provide the correct TRX_PAYMENTAMOUNT for the entire amount due (with the discount amount calculated in) for the discount to apply.
#>
function ConvertTo-ARPaymentDetail 
{
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [int]$RECORDKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$ENTRYKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$POSADJKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$POSADJENTRYKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_PAYMENTAMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$ADJUSTMENTKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$ADJUSTMENTENTRYKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_ADJUSTMENTAMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$INLINEKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$INLINEENTRYKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_INLINEAMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$ADVANCEKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$ADVANCEENTRYKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_POSTEDADVANCEAMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$OVERPAYMENTKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$OVERPAYMENTENTRYKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_POSTEDOVERPAYMENTAMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$NEGATIVEINVOICEKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$NEGATIVEINVOICEENTRYKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_NEGATIVEINVOICEAMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$DISCOUNTDATE
    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<ARPYMTDETAIL>")
    }

    Process
    {
        # mandatory
        if ($RECORDKEY) { [void]$SB.Append("<RECORDKEY>$RECORDKEY</RECORDKEY>") }
        # /mandatory

        if ($ENTRYKEY)  { [void]$SB.Append("<ENTRYKEY>$ENTRYKEY</ENTRYKEY>") }
        if ($POSADJKEY)  { [void]$SB.Append("<POSADJKEY>$POSADJKEY</POSADJKEY>") }
        if ($POSADJENTRYKEY)  { [void]$SB.Append("<POSADJENTRYKEY>$POSADJENTRYKEY</POSADJENTRYKEY>") }
        if ($TRX_PAYMENTAMOUNT)  { [void]$SB.Append("<TRX_PAYMENTAMOUNT>$TRX_PAYMENTAMOUNT</TRX_PAYMENTAMOUNT>") }
        if ($ADJUSTMENTKEY)  { [void]$SB.Append("<ADJUSTMENTKEY>$ADJUSTMENTKEY</ADJUSTMENTKEY>") }
        if ($ADJUSTMENTENTRYKEY)  { [void]$SB.Append("<ADJUSTMENTENTRYKEY>$ADJUSTMENTENTRYKEY</ADJUSTMENTENTRYKEY>") }
        if ($TRX_ADJUSTMENTAMOUNT)  { [void]$SB.Append("<TRX_ADJUSTMENTAMOUNT>$TRX_ADJUSTMENTAMOUNT</TRX_ADJUSTMENTAMOUNT>") }
        if ($INLINEKEY)  { [void]$SB.Append("<INLINEKEY>$INLINEKEY</INLINEKEY>") }
        if ($INLINEENTRYKEY)  { [void]$SB.Append("<INLINEENTRYKEY>$INLINEENTRYKEY</INLINEENTRYKEY>") }
        if ($TRX_INLINEAMOUNT)  { [void]$SB.Append("<TRX_INLINEAMOUNT>$TRX_INLINEAMOUNT</TRX_INLINEAMOUNT>") }
        if ($ADVANCEKEY)  { [void]$SB.Append("<ADVANCEKEY>$ADVANCEKEY</ADVANCEKEY>") }
        if ($ADVANCEENTRYKEY)  { [void]$SB.Append("<ADVANCEENTRYKEY>$ADVANCEENTRYKEY</ADVANCEENTRYKEY>") }
        if ($TRX_POSTEDADVANCEAMOUNT)  { [void]$SB.Append("<TRX_POSTEDADVANCEAMOUNT>$TRX_POSTEDADVANCEAMOUNT</TRX_POSTEDADVANCEAMOUNT>") }
        if ($OVERPAYMENTKEY)  { [void]$SB.Append("<OVERPAYMENTKEY>$OVERPAYMENTKEY</OVERPAYMENTKEY>") }
        if ($OVERPAYMENTENTRYKEY)  { [void]$SB.Append("<OVERPAYMENTENTRYKEY>$OVERPAYMENTENTRYKEY</OVERPAYMENTENTRYKEY>") }
        if ($TRX_POSTEDOVERPAYMENTAMOUNT)  { [void]$SB.Append("<TRX_POSTEDOVERPAYMENTAMOUNT>$TRX_POSTEDOVERPAYMENTAMOUNT</TRX_POSTEDOVERPAYMENTAMOUNT>") }
        if ($NEGATIVEINVOICEKEY)  { [void]$SB.Append("<NEGATIVEINVOICEKEY>$NEGATIVEINVOICEKEY</NEGATIVEINVOICEKEY>") }
        if ($NEGATIVEINVOICEENTRYKEY)  { [void]$SB.Append("<NEGATIVEINVOICEENTRYKEY>$NEGATIVEINVOICEENTRYKEY</NEGATIVEINVOICEENTRYKEY>") }
        if ($TRX_NEGATIVEINVOICEAMOUNT)  { [void]$SB.Append("<TRX_NEGATIVEINVOICEAMOUNT>$TRX_NEGATIVEINVOICEAMOUNT</TRX_NEGATIVEINVOICEAMOUNT>") }
        if ($DISCOUNTDATE)  { [void]$SB.Append("<DISCOUNTDATE>$( $DISCOUNTDATE.ToString('MM/dd/yyyy') )</DISCOUNTDATE>") }

    }

    End
    {
        [void]$SB.Append("</ARPYMTDETAIL>")
        $SB.ToString()
    }

}
