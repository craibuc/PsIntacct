<#
.SYNOPSIS
Convert ARPayment model to Xml.

.PARAMETER PAYMENTMETHOD
Payment method. Use Printed Check, Cash, EFT, Credit Card, Online Charge Card, or Online ACH Debit.

.PARAMETER CUSTOMERID
The customer's ID.

.PARAMETER RECEIPTDATE
Receipt date in the mm/dd/yyyy format. This is the date on which to post to the GL.

.PARAMETER CURRENCY
Transaction currency code.  For example, 'USD'.

.PARAMETER ARPYMTDETAILS
ARPYMTDETAIL[1...n]	Details for the payment, including line items, discounts, adjustments, and so forth.

.PARAMETER FINANCIALENTITY
string	Financial entity from which the payment will be paid. Can be a checking account ID or a savings account ID. Required if not using a summary (PRBATCH) or undeposited funds account (UNDEPOSITEDACCOUNTNO).

.PARAMETER DOCNUMBER
string	Reference number, which can be a check number, an authorization code received from a charge card company, or a transaction number, depending on the payment method used

.PARAMETER DESCRIPTION
string	Description for the payment

.PARAMETER EXCH_RATE_TYPE_ID
string	Exchange rate type. Do not use if EXCHANGE_RATE is set. (Leave blank to use Intacct Daily Rate)

.PARAMETER EXCHANGE_RATE
string	Exchange rate value. Do not use if EXCH_RATE_TYPE_ID is set.

.PARAMETER PAYMENTDATE
string	Payment date in the mm/dd/yyyy format when paying with a charge card. This is the date on which the transaction occurred, according to your statement. (Default: today’s date)

.PARAMETER AMOUNTOPAY
currency	For payment involving multi-currency, this is the translated payment base amount

.PARAMETER TRX_AMOUNTTOPAY
currency	For payment involving multi-currency, this is the total transaction payment amount

.PARAMETER PRBATCH
string	Summary name to post into if AR is configured for user-specified summary posting Required if not using a financial entity (FINANCIALENTITY) or undeposited funds account (UNDEPOSITEDACCOUNTNO).

.PARAMETER WHENPAID
string	Date when the invoice is fully paid in the mm/dd/yyyy format

.PARAMETER BASECURR
string	Base currency code

.PARAMETER UNDEPOSITEDACCOUNTNO
string	Undeposited funds account. Required if not using a financial entity (FINANCIALENTITY) or summary (PRBATCH).

.PARAMETER OVERPAYMENTAMOUNT
currency	Overpayment amount recorded by the payment

.PARAMETER OVERPAYMENTLOCATIONID
string	Location ID in which to receive an overpayment

.PARAMETER OVERPAYMENTDEPARTMENTID
string	Department ID in which to receive an overpayment

.PARAMETER BILLTOPAYNAME
string	Customer contact name for adjustments

.PARAMETER ONLINECARDPAYMENT
object	Online card payment fields. Use only if payment method is Online Charge Card.

#>
function ConvertTo-ARPaymentXml
{

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$CUSTOMERID,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [ValidateSet('Printed Check', 'Cash', 'EFT', 'Credit Card', 'Online Charge Card', 'Online ACH Debit')]
        [string]$PAYMENTMETHOD,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [datetime]$RECEIPTDATE,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory,ParameterSetName='FINANCIALENTITY')]
        [string]$FINANCIALENTITY,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory,ParameterSetName='UNDEPOSITEDACCOUNTNO')]
        [string]$UNDEPOSITEDACCOUNTNO,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory,ParameterSetName='PRBATCH')]
        [string]$PRBATCH,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [pscustomobject[]]$ARPYMTDETAILS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DOCNUMBER,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DESCRIPTION,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$EXCH_RATE_TYPE_ID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$EXCHANGE_RATE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$PAYMENTDATE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$AMOUNTOPAY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_AMOUNTTOPAY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$WHENPAID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BASECURR,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CURRENCY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$OVERPAYMENTAMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OVERPAYMENTLOCATIONID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OVERPAYMENTDEPARTMENTID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BILLTOPAYNAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$ONLINECARDPAYMENT
    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<ARPYMT>")
    }

    Process
    {
        # mandatory
        if ($PAYMENTMETHOD) { [void]$SB.Append("<PAYMENTMETHOD>$PAYMENTMETHOD</PAYMENTMETHOD>") }
        if ($CUSTOMERID) { [void]$SB.Append("<CUSTOMERID>$CUSTOMERID</CUSTOMERID>") }
        if ($RECEIPTDATE) { [void]$SB.Append("<RECEIPTDATE>$( $RECEIPTDATE.ToString('MM/dd/yyyy') )</RECEIPTDATE>") }
        if ($CURRENCY) { [void]$SB.Append("<CURRENCY>$CURRENCY</CURRENCY>") }
        if ($ARPYMTDETAILS)
        { 
            [void]$SB.Append("<ARPYMTDETAILS>")

            $pd = $ARPYMTDETAILS | ConvertTo-ARPaymentDetailXml
            [void]$SB.Append( $pd )

            [void]$SB.Append("</ARPYMTDETAILS>")
        }
        else { [void]$SB.Append("<ARPYMTDETAILS/>") }
        # /mandatory
        if ($FINANCIALENTITY) { [void]$SB.Append("<FINANCIALENTITY>$FINANCIALENTITY</FINANCIALENTITY>") }
        if ($DOCNUMBER) { [void]$SB.Append("<DOCNUMBER>$DOCNUMBER</DOCNUMBER>") }
        if ($DESCRIPTION) { [void]$SB.Append("<DESCRIPTION>$DESCRIPTION</DESCRIPTION>") }
        if ($EXCH_RATE_TYPE_ID) { [void]$SB.Append("<EXCH_RATE_TYPE_ID>$EXCH_RATE_TYPE_ID</EXCH_RATE_TYPE_ID>") }
        if ($EXCHANGE_RATE) { [void]$SB.Append("<EXCHANGE_RATE>$EXCHANGE_RATE</EXCHANGE_RATE>") }
        if ($PAYMENTDATE) { [void]$SB.Append("<PAYMENTDATE>$( $PAYMENTDATE.ToString("MM/dd/yyyy") )</PAYMENTDATE>") }
        if ($AMOUNTOPAY) { [void]$SB.Append("<AMOUNTOPAY>$AMOUNTOPAY</AMOUNTOPAY>") }
        if ($TRX_AMOUNTTOPAY) { [void]$SB.Append("<TRX_AMOUNTTOPAY>$TRX_AMOUNTTOPAY</TRX_AMOUNTTOPAY>") }
        if ($PRBATCH) { [void]$SB.Append("<PRBATCH>$PRBATCH</PRBATCH>") }
        if ($WHENPAID) { [void]$SB.Append("<WHENPAID>$( $WHENPAID.ToString("MM/dd/yyyy") )</WHENPAID>") }
        if ($BASECURR) { [void]$SB.Append("<BASECURR>$BASECURR</BASECURR>") }
        if ($UNDEPOSITEDACCOUNTNO) { [void]$SB.Append("<UNDEPOSITEDACCOUNTNO>$UNDEPOSITEDACCOUNTNO</UNDEPOSITEDACCOUNTNO>") }
        if ($OVERPAYMENTAMOUNT) { [void]$SB.Append("<OVERPAYMENTAMOUNT>$OVERPAYMENTAMOUNT</OVERPAYMENTAMOUNT>") }
        if ($OVERPAYMENTLOCATIONID) { [void]$SB.Append("<OVERPAYMENTLOCATIONID>$OVERPAYMENTLOCATIONID</OVERPAYMENTLOCATIONID>") }
        if ($OVERPAYMENTDEPARTMENTID) { [void]$SB.Append("<OVERPAYMENTDEPARTMENTID>$OVERPAYMENTDEPARTMENTID</OVERPAYMENTDEPARTMENTID>") }
        if ($BILLTOPAYNAME) { [void]$SB.Append("<BILLTOPAYNAME>$BILLTOPAYNAME</BILLTOPAYNAME>") }
        if ($ONLINECARDPAYMENT)
        { 
            $xml = $ONLINECARDPAYMENT | ConvertTo-OnlineCardPaymentXml
            [void]$SB.Append( $xml.ONLINECARDPAYMENT.OuterXml )
        }
    }

    End
    {
        [void]$SB.Append("</ARPYMT>")
        [xml]$SB.ToString()
    }

}
