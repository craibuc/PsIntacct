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
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [string]$customerid,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [decimal]$paymentamount,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [int]$batchkey,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Alias('FINANCIALENTITY')]
        [string]$bankaccountid,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [Alias('UNDEPOSITEDACCOUNTNO')]
        [string]$undepfundsacct,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [decimal]$translatedamount,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [Alias('DOCNUMBER')]
        [string]$refid,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Apply')]
        [int]$arpaymentkey,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Apply')]
        [datetime]$paymentdate,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Apply')]
        [string]$memo,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Apply')]
        [string]$overpaylocid,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Apply')]
        [string]$overpaydeptid,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [Alias('RECEIPTDATE')]
        [datetime]$datereceived,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [ValidateSet('Printed Check', 'Cash', 'EFT', 'Credit Card', 'Online Charge Card', 'Online ACH Debit')]
        [string]$paymentmethod,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [string]$basecurr,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [string]$currency,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [datetime]$exchratedate,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [string]$exchratetype,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [decimal]$exchrate,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [string]$cctype,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [string]$authcode,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Apply')]
        [Alias('ARPYMTDETAILS')]
        [pscustomobject[]]$arpaymentitem,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [pscustomobject]$onlinecardpayment,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.batchkey')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.bankaccountid')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create.undepfundsacct')]
        [pscustomobject]$onlineachpayment
    )

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
    }
    process
    {
        switch -Wildcard ($PSCmdlet.ParameterSetName) 
        {
            'Apply' 
            {
                [void]$SB.Append("<apply_arpayment>")

                if ($arpaymentkey) { [void]$SB.Append("<arpaymentkey>$arpaymentkey</arpaymentkey>") }
                if ($paymentdate) 
                {
                    [void]$SB.Append(
                    "<paymentdate>
                        <year>$( $paymentdate.ToString('yyyy') )</year>
                        <month>$( $paymentdate.ToString('MM') )</month>
                        <day>$( $paymentdate.ToString('dd') )</day>
                    </paymentdate>")
                }
                if ($memo) { [void]$SB.Append("<memo>$memo</memo>") }
                if ($overpaylocid) { [void]$SB.Append("<overpaylocid>$overpaylocid</overpaylocid>") }
                if ($overpaydeptid) { [void]$SB.Append("<overpaydeptid>$overpaydeptid</overpaydeptid>") }
                if ($arpaymentitem) 
                {
                    $xml = $arpaymentitem | ConvertTo-ARPaymentItemXml
                    [void]$SB.Append( $xml.OuterXml )
                }

                [void]$SB.Append("</apply_arpayment>")
            }
            'Create.*'
            {
                [void]$SB.Append("<create_arpayment>")

                if ($customerid) { [void]$SB.Append("<customerid>$customerid</customerid>") }    
                if ($paymentamount) { [void]$SB.Append("<paymentamount>$paymentamount</paymentamount>")}
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

                if ($arpaymentitem) 
                {
                    $xml = $arpaymentitem | ConvertTo-ARPaymentItemXml
                    [void]$SB.Append( $xml.arpaymentitems.ChildNodes.OuterXml )
                }

                if ($onlinecardpayment) 
                { 
                    [void]$SB.Append("<onlinecardpayment>") 
                    [void]$SB.Append("<cardnum>$( $onlinecardpayment.cardnum )</cardnum>") 
                    [void]$SB.Append("<expirydate>$( ([datetime]$onlinecardpayment.expirydate).ToString("MM/dd/yyyy") )</expirydate>") 
                    [void]$SB.Append("<cardtype>$( $onlinecardpayment.cardtype )</cardtype>") 
                    [void]$SB.Append("<securitycode>$( $onlinecardpayment.securitycode )</securitycode>") 
                    [void]$SB.Append("<usedefaultcard>$( $onlinecardpayment.usedefaultcard.ToString().ToLower() )</usedefaultcard>") 
                    [void]$SB.Append("</onlinecardpayment>") 
                }

                if ($onlineachpayment) 
                { 
                    [void]$SB.Append("<onlineachpayment>") 
                    [void]$SB.Append("<bankname>$( $onlineachpayment.bankname )</bankname>") 
                    [void]$SB.Append("<accounttype>$( $onlineachpayment.accounttype )</accounttype>") 
                    [void]$SB.Append("<accountnumber>$( $onlineachpayment.accountnumber )</accountnumber>") 
                    [void]$SB.Append("<routingnumber>$( $onlineachpayment.routingnumber )</routingnumber>") 
                    [void]$SB.Append("<accountholder>$( $onlineachpayment.accountholder )</accountholder>") 
                    [void]$SB.Append("<usedefaultcard>$( $onlineachpayment.usedefaultcard.ToString().ToLower() )</usedefaultcard>") 
                    [void]$SB.Append("</onlineachpayment>") 
                }

                [void]$SB.Append("</create_arpayment>")

            }
        }

    }
    end 
    {
        [xml]$SB.ToString()
    }

}
