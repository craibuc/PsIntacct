<#
.SYNOPSIS

.PARAMETER customerid
string	Customer ID

.PARAMETER paymentamount
currency	Transaction amount

.PARAMETER translatedamount
currency	Base amount

.PARAMETER batchkey
integer	AR payment summary record number to add this payment to. Required if not using bankaccountid or undepfundsacct.

.PARAMETER bankaccountid
string	Bank account ID. Required if not using undepfundsacct or batchkey.

.PARAMETER undepfundsacct
string	Undeposited funds GL account. Required if not using bankaccountid or batchkey.

.PARAMETER refid
string	Reference number

.PARAMETER overpaylocid
string	Overpayment location ID

.PARAMETER overpaydeptid
string	Overpayment department ID

.PARAMETER datereceived
object	Received payment date

.PARAMETER paymentmethod
string	Payment method. Use Printed Check, Cash, EFT, Credit Card, Online Charge Card, or Online ACH Debit.

.PARAMETER basecurr
string	Base currency code

.PARAMETER currency
string	Payment currency code

.PARAMETER exchratedate
object	Exchange rate date

.PARAMETER exchratetype
string	Exchange rate type. Do not use if exchrate is set. (Leave blank to use Intacct Daily Rate)

.PARAMETER exchrate
currency	Exchange rate value. Do not use if exchangeratetype is set.

.PARAMETER cctype
string	Credit card type

.PARAMETER authcode
string	Authorization code to use

.PARAMETER arpaymentitem
object	Transactions records to apply the payment to. Element may appear 0 to N times. If 0 elements are provided, the AR module’s Customer Account Type setting will dictate how the payment is applied (see the description for the function above).

.PARAMETER onlinecardpayment
object	Online card payment fields only used if paymentmethod is Online Charge Card

.PARAMETER onlineachpayment
object	Online ACH payment fields only used if paymentmethod is Online ACH Debit

.INPUTS

.OUTPUTS
System.Xml.XmlDocument

.LINK
https://developer.intacct.com/api/accounts-receivable/ar-payments/#get-ar-payment

#>
function ConvertTo-ARPaymentLegacyXml {

    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [ValidateSet('create','apply','reverse')]
        [string]$Verb,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$customerid,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [decimal]$paymentamount,

        [parameter(ValueFromPipelineByPropertyName)]
        [decimal]$translatedamount,

        [parameter(ValueFromPipelineByPropertyName)]
        [int]$batchkey,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$bankaccountid,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$undepfundsacct,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$refid,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$overpaylocid,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$overpaydeptid,

        [parameter(ValueFromPipelineByPropertyName)]
        [datetime]$datereceived,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$paymentmethod,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$basecurr,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$currency,

        [parameter(ValueFromPipelineByPropertyName)]
        [datetime]$exchratedate,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$exchratetype,

        [parameter(ValueFromPipelineByPropertyName)]
        [decimal]$exchrate,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$cctype,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$authcode,

        [parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject[]]$arpaymentitem,

        [parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$onlinecardpayment,

        [parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$onlineachpayment
    )

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<$($Verb)_arpayment>")
    }
    process
    {
        # mandatory
        if ($customerid) { [void]$SB.Append("<customerid>$customerid</customerid>")}
        if ($paymentamount) { [void]$SB.Append("<paymentamount>$paymentamount</paymentamount>")}
        # /mandatory

        # optional
        if ($translatedamount) { [void]$SB.Append("<translatedamount>$translatedamount</translatedamount>") }
        if ($batchkey) { [void]$SB.Append("<batchkey>$batchkey</batchkey>") }
        if ($bankaccountid) { [void]$SB.Append("<bankaccountid>$bankaccountid</bankaccountid>") }
        if ($undepfundsacct) { [void]$SB.Append("<undepfundsacct>$undepfundsacct</undepfundsacct>") }
        if ($refid) { [void]$SB.Append("<refid>$refid</refid>") }
        if ($overpaylocid) { [void]$SB.Append("<overpaylocid>$overpaylocid</overpaylocid>") }
        if ($overpaydeptid) { [void]$SB.Append("<overpaydeptid>$overpaydeptid</overpaydeptid>") }
        if ($datereceived) 
        {
            [void]$SB.Append(
            "<datereceived>
                <year>$( $datereceived.ToString('yyyy') )</year>
                <month>$( $datereceived.ToString('MM') )</month>
                <day>$( $datereceived.ToString('dd') )</day>
            </datereceived>")
        }
        if ($paymentmethod) { [void]$SB.Append("<paymentmethod>$paymentmethod</paymentmethod>") }
        if ($basecurr) { [void]$SB.Append("<basecurr>$basecurr</basecurr>") }
        if ($currency) { [void]$SB.Append("<currency>$currency</currency>") }
        if ($exchratedate) 
        {
            [void]$SB.Append(
            "<exchratedate>
                <year>$( $exchratedate.ToString('yyyy') )</year>
                <month>$( $exchratedate.ToString('MM') )</month>
                <day>$( $exchratedate.ToString('dd') )</day>
            </exchratedate>")
        }
        if ($exchratetype) { [void]$SB.Append("<exchratetype>$exchratetype</exchratetype>") }
        if ($exchrate) { [void]$SB.Append("<exchrate>$exchrate</exchrate>") }
        if ($cctype) { [void]$SB.Append("<cctype>$cctype</cctype>") }
        if ($authcode) { [void]$SB.Append("<authcode>$authcode</authcode>") }
        if ($arpaymentitem) { [void]$SB.Append("<arpaymentitem>$arpaymentitem</arpaymentitem>") }
        if ($onlinecardpayment) { [void]$SB.Append("<onlinecardpayment>$onlinecardpayment</onlinecardpayment>") }
        if ($onlineachpayment) { [void]$SB.Append("<onlineachpayment>$onlineachpayment</onlineachpayment>") }
        # /optional
    }
    end 
    {
        [void]$SB.Append("</$($Verb)_arpayment>")
        [xml]$SB.ToString()
    }

}
