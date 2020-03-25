<#
.SYNOPSIS
Convert an invoice, represented as a PsCustomObject graph, into its Xml representation

.PARAMETER CustomerId
Customer ID

.PARAMETER DateCreated
Transaction date

.PARAMETER DatePosted
GL posting date

.PARAMETER DateDue
Due date. Required if not using Terms.

.PARAMETER Terms
Payment term. Required if not using DateDue.

.PARAMETER batchkey
Summary RECORDNO

.PARAMETER Action
Action. Use Draft or Submit. (Default: Submit)

.PARAMETER InvoiceNo
Invoice number

.PARAMETER PoNumber
Purchase-order number

.PARAMETER Description
Description

.PARAMETER ExternalId
External ID

.PARAMETER BillTo
Bill to contact

.PARAMETER ShipTo
Ship to contact

.PARAMETER BaseCurrency
Base currency code

.PARAMETER Currency
Transaction currency code

.PARAMETER exchratedate
Exchange rate date.

.PARAMETER exchratetype
Exchange rate type. Do not use if exchrate is set. (Leave blank to use Intacct Daily Rate)

.PARAMETER exchrate
Exchange rate value. Do not use if exchangeratetype is set.

.PARAMETER nogl
Do not post to GL. Use false for No, true for Yes. (Default: false)

.PARAMETER supdocid
Attachments ID

.PARAMETER customfields
customfield[0...n]	Custom fields

.PARAMETER invoiceitems
lineitem[1...n]	Invoice lines, must have at least 1.

.INPUTS
PsCustomObject

.OUTPUTS
System.Xml representation of Invoice, using Intacct's XSD

#>
function ConvertTo-InvoiceXml {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('create','update','reverse','delete')]
        [string]$Verb,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$customerid,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [datetime]$datecreated,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$dateposted,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$datedue,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$termname,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$batchkey,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Draft','Submit')]
        [string]$action='Submit',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$invoiceno,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ponumber,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$externalid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$billto,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$shipto,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$basecurr,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$currency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$exchratedate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$exchratetype,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$exchrate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$nogl,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$supdocid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject[]]$invoiceitems,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject[]]$customfields
    )

    begin 
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<$($Verb)_invoice>")
    }
    
    process 
    {
        if ($CustomerId) { [void]$SB.Append("<customerid>$customerid</customerid>")}
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
        if ($DateDue)
        {
            [void]$SB.Append(
            "<datedue>
                <year>$( $datedue.ToString('yyyy') )</year>
                <month>$( $datedue.ToString('MM') )</month>
                <day>$( $datedue.ToString('dd') )</day>
            </datedue>")
        }
        if ($termname) { [void]$SB.Append("<termname>$termname</termname>")}
        if ($batchkey) { [void]$SB.Append("<batchkey>$batchkey</batchkey>")}
        if ($action) { [void]$SB.Append("<action>$action</action>")}
        if ($invoiceno) { [void]$SB.Append("<invoiceno>$invoiceno</invoiceno>")}
        if ($ponumber) { [void]$SB.Append("<ponumber>$ponumber</ponumber>")}
        if ($description) { [void]$SB.Append("<description>$( [System.Security.SecurityElement]::Escape($description) )</description>")}
        if ($externalid) { [void]$SB.Append("<externalid>$externalid</externalid>")}
        if ($billto) { [void]$SB.Append("<billto><contactname>$billto</contactname></billto>")}
        if ($shipto) { [void]$SB.Append("<shipto><contactname>$shipto</contactname></shipto>")}
        if ($basecurr) { [void]$SB.Append("<basecurr>$basecurr</basecurr>")}
        if ($currency) { [void]$SB.Append("<currency>$currency</currency>")}
        if ($exchratedate) 
        {
            [void]$SB.Append(
            "<exchratedate>
                <year>$( $exchratedate.ToString('yyyy') )</year>
                <month>$( $exchratedate.ToString('MM') )</month>
                <day>$( $exchratedate.ToString('dd') )</day>
            </exchratedate>")
        }
        if ($exchratetype) { [void]$SB.Append("<exchratetype>$exchratetype</exchratetype>")}
        if ($exchrate) { [void]$SB.Append("<exchrate>$exchrate</exchrate>")}

        if ($nogl) { [void]$SB.Append("<nogl>$($nogl.ToString().ToLower())</nogl>")}
        if ($supdocid) { [void]$SB.Append("<supdocid>$supdocid</supdocid>")}

        if ($customfields)
        {
            $xml = $customfields | ConvertTo-CustomFieldXml
            [void]$SB.Append( $xml )
        }

        if ($invoiceitems)
        {
            $xml = $invoiceitems | ConvertTo-InvoiceItemXml
            [void]$SB.Append( $xml )
        }
    }
    
    end
    {
        [void]$SB.Append("</$($Verb)_invoice>")

        [xml]$SB.ToString()
    }

}
