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
        [bool]$usedefaultcard
        )

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
    }
    process
    {
        [void]$SB.Append("<onlinecardpayment>")
        [void]$SB.Append("<cardnum>$cardnum</cardnum>")
        [void]$SB.Append("<expirydate>$( $expirydate.ToString('MM/dd/yyyy') )</expirydate>")
        [void]$SB.Append("<cardtype>$cardtype</cardtype>")
        [void]$SB.Append("<securitycode>$securitycode</securitycode>")
        [void]$SB.Append("<usedefaultcard>$( $usedefaultcard.ToString().ToLower() )</usedefaultcard>")
        [void]$SB.Append("</onlinecardpayment>")
    }
    end 
    {
        [xml]$SB.ToString()
    }

}
