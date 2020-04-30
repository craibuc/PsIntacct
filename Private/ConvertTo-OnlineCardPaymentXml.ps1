<#
.SYNOPSIS

.PARAMETER cardnum
Card number

.PARAMETER expirydate
Expiration date

.PARAMETER cardtype
Card type

.PARAMETER securitycode
Security code

.PARAMETER usedefaultcard
Use false for No, true for Yes.

.LINK
https://developer.intacct.com/api/accounts-receivable/ar-payments/#create-ar-payment-legacy

#>
function ConvertTo-OnlineCardPaymentXml {

    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$cardnum,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [datetime]$expirydate,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$cardtype,

        [parameter(ValueFromPipelineByPropertyName)]
        [string]$securitycode,

        [parameter(ValueFromPipelineByPropertyName)]
        [bool]$usedefaultcard,

        [switch]$Legacy
        )

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
    }
    process
    {
        if ($Legacy)
        {
            [void]$SB.Append("<onlinecardpayment>")
            [void]$SB.Append("<cardnum>$cardnum</cardnum>")
            [void]$SB.Append("<expirydate>$( $expirydate.ToString('MM/dd/yyyy') )</expirydate>")
            [void]$SB.Append("<cardtype>$cardtype</cardtype>")
            [void]$SB.Append("<securitycode>$securitycode</securitycode>")
            [void]$SB.Append("<usedefaultcard>$( $usedefaultcard.ToString().ToLower() )</usedefaultcard>")
            [void]$SB.Append("</onlinecardpayment>")
        }
        else
        {
            [void]$SB.Append("<ONLINECARDPAYMENT>")
            [void]$SB.Append("<CARDNUM>$cardnum</CARDNUM>")
            [void]$SB.Append("<EXPIRYDATE>$( $expirydate.ToString('MM/dd/yyyy') )</EXPIRYDATE>")
            [void]$SB.Append("<CARDTYPE>$cardtype</CARDTYPE>")
            [void]$SB.Append("<SECURITYCODE>$securitycode</SECURITYCODE>")
            [void]$SB.Append("<USEDEFAULTCARD>$( $usedefaultcard.ToString().ToLower() )</USEDEFAULTCARD>")
            [void]$SB.Append("</ONLINECARDPAYMENT>")
        }
    }
    end 
    {
        [xml]$SB.ToString()
    }

}
