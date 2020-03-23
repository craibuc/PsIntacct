<#
.SYNOPSIS

.PARAMETER batchtitle
AR payment summary title

.PARAMETER bankaccountid
Bank account ID. Required if not using undepfundsacct.

.PARAMETER undepfundsacct
Undeposited funds GL account. Required if not using bankaccountid.

.PARAMETER datecreated
GL posting date

#>
function ConvertTo-ARPaymentSummaryXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [string]$batchtitle,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$bankaccountid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$undepfundsacct,

        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [datetime]$datecreated
    )

<#
<create_arpaymentbatch>
    <batchtitle>AR Payments for 2017 Week 03 - CHK-BA1433</batchtitle>
    <bankaccountid>CHK-BA1433</bankaccountid>
    <datecreated>
        <year>2017</year>
        <month>01</month>
        <day>20</day>
    </datecreated>
</create_arpaymentbatch>
#>

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<create_arpaymentbatch>")
    }
    process
    {
        # mandatory
        if ($batchtitle) { [void]$SB.Append("<batchtitle>$batchtitle</batchtitle>") }
        # /mandatory

        if ($bankaccountid) { [void]$SB.Append("<bankaccountid>$bankaccountid</bankaccountid>") }
        if ($undepfundsacct) { [void]$SB.Append("<undepfundsacct>$undepfundsacct</undepfundsacct>") }
        if ($datecreated) 
        {
            [void]$SB.Append(
            "<datecreated>
                <year>$( $datecreated.ToString('yyyy') )</year>
                <month>$( $datecreated.ToString('MM') )</month>
                <day>$( $datecreated.ToString('dd') )</day>
            </datecreated>")
        }
    }
    end
    {
        [void]$SB.Append("</create_arpaymentbatch>")
        [xml]$SB.ToString()
    }

}
