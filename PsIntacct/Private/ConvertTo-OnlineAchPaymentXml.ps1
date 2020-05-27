<#
.SYNOPSIS

.PARAMETER bankname
Bank name

.PARAMETER accounttype
Account type

.PARAMETER accountnumber
Account number

.PARAMETER routingnumber
Routing number

.PARAMETER accountholder
Account holder

.PARAMETER usedefaultcard
Use false for No, true for Yes.

#>
function ConvertTo-OnlineAchPaymentXml {

    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$bankname,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$accounttype,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$accountnumber,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$routingnumber,

        [parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$accountholder,

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
            [void]$SB.Append("<onlineachpayment>")
            [void]$SB.Append("<accounttype>$accounttype</accounttype>")
            [void]$SB.Append("<bankname>$bankname</bankname>")
            [void]$SB.Append("<accountnumber>$accountnumber</accountnumber>")
            [void]$SB.Append("<routingnumber>$routingnumber</routingnumber>")
            [void]$SB.Append("<accountholder>$accountholder</accountholder>")
            [void]$SB.Append("<usedefaultcard>$( $usedefaultcard.ToString().ToLower() )</usedefaultcard>")
            [void]$SB.Append("</onlineachpayment>")
        }
        else
        {
            [void]$SB.Append("<ONLINEACHPAYMENT>")
            [void]$SB.Append("<ACCOUNTTYPE>$accounttype</ACCOUNTTYPE>")
            [void]$SB.Append("<BANKNAME>$bankname</BANKNAME>")
            [void]$SB.Append("<ACCOUNTNUMBER>$accountnumber</ACCOUNTNUMBER>")
            [void]$SB.Append("<ROUTINGNUMBER>$routingnumber</ROUTINGNUMBER>")
            [void]$SB.Append("<ACCOUNTHOLDER>$accountholder</ACCOUNTHOLDER>")
            [void]$SB.Append("<USEDEFAULTCARD>$( $usedefaultcard.ToString().ToLower() )</USEDEFAULTCARD>")
            [void]$SB.Append("</ONLINEACHPAYMENT>")
        }
    }
    end 
    {
        [xml]$SB.ToString()
    }

}
