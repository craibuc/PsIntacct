<#
.SYNOPSIS
Convert ARAdjustment model to Xml.

.PARAMETER customerid
Customer ID

.PARAMETER datecreated
Transaction date

.PARAMETER dateposted
GL posting date

.PARAMETER batchkey
Summary record number

.PARAMETER adjustmentno
Adjustment number

.PARAMETER action
Action. Use Draft or Submit. (Default: Submit)

.PARAMETER invoiceno
Invoice number

.PARAMETER description
Description

.PARAMETER externalid
External ID

.PARAMETER basecurr
Base currency code

.PARAMETER currency
Transaction currency code

.PARAMETER exchratedate
Exchange rate date.

.PARAMETER exchratetype
Exchange rate type. Do not use if exchrate is set. (Leave blank to use Intacct Daily Rate)

.PARAMETER exchrate
Exchange rate value. Do not use if exchangeratetype is set.

.PARAMETER nogl
Do not post to GL. Use false for No, true for Yes. (Default: false)

.PARAMETER aradjustmentitems
lineitem[1...n]	Invoice lines, must have at least 1.

.LINK
https://developer.intacct.com/api/accounts-receivable/ar-adjustments/#create-ar-adjustment-legacy

#>
function ConvertTo-ARAdjustmentXml {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('create','update','delete')]
        [string]$Verb,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$customerid,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [datetime]$datecreated,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$dateposted,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$batchkey,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$adjustmentno,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$action,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$invoiceno,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$externalid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$basecurr,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$currency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$exchratedate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$exchratetype,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$exchrate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$nogl,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [pscustomobject[]]$aradjustmentitems
    )

    <#
    <create_aradjustment>
        <customerid>1000</customerid>
        <datecreated>
            <year>2013</year>
            <month>5</month>
            <day>28</day>
        </datecreated>
        <adjustmentno></adjustmentno>
        <invoiceno></invoiceno>
        <description></description>
        <aradjustmentitems>
            <lineitem>
                <glaccountno>4000</glaccountno>
                <amount>1234.56</amount>
                <memo>test line 1</memo>
                <locationid>ARL-VA-US</locationid>
                <departmentid>SAL</departmentid>
                <projectid></projectid>
                <customerid></customerid>
                <vendorid></vendorid>
                <employeeid></employeeid>
                <itemid></itemid>
                <classid></classid>
            </lineitem>
        </aradjustmentitems>
    </create_aradjustment>
    #>

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<$($Verb)_aradjustment>")
    }
    process
    {
        if ($customerid) { [void]$SB.Append("<customerid>$customerid</customerid>") }
        if ($datecreated) 
        {
            [void]$SB.Append(
            "<datecreated>
                <year>$( $datecreated.ToString('yyyy') )</year>
                <month>$( $datecreated.ToString('MM') )</month>
                <day>$( $datecreated.ToString('dd') )</day>
            </datecreated>")
        }
        if ($dateposted) 
        {
            [void]$SB.Append(
            "<dateposted>
                <year>$( $dateposted.ToString('yyyy') )</year>
                <month>$( $dateposted.ToString('MM') )</month>
                <day>$( $dateposted.ToString('dd') )</day>
            </dateposted>")
        }
        if ($batchkey) { [void]$SB.Append("<batchkey>$batchkey</batchkey>") }
        if ($adjustmentno) { [void]$SB.Append("<adjustmentno>$adjustmentno</adjustmentno>") }
        if ($action) { [void]$SB.Append("<action>$action</action>") }
        if ($invoiceno) { [void]$SB.Append("<invoiceno>$invoiceno</invoiceno>") }
        if ($description) { [void]$SB.Append("<description>$description</description>") }
        if ($externalid) { [void]$SB.Append("<externalid>$externalid</externalid>") }
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
        [void]$SB.Append("<nogl>$( $nogl.ToString().ToLower() )</nogl>")
        if ($aradjustmentitems)
        { 
            # [void]$SB.Append("<aradjustmentitems>")

            $ai = $aradjustmentitems | ConvertTo-ARAdjustmentItemXml
            [void]$SB.Append( $ai )

            # [void]$SB.Append("</aradjustmentitems>")
        }
        else { void]$SB.Append("<aradjustmentitems/>") }
    }
    end
    {
        [void]$SB.Append("</$($Verb)_aradjustment>")
        [xml]$SB.ToString()
    }

}
