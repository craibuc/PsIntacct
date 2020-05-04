<#
.SYNOPSIS
Convert an invoice, represented as a PsCustomObject graph, into its Xml representation

.PARAMETER key
RECORDNO associated with invoice to be updated or reversed

.PARAMETER customerid
Customer ID

.PARAMETER datecreated
Transaction date

.PARAMETER dateposted
GL posting date

.PARAMETER datedue
Due date. Required if not using `termname`

.PARAMETER datereversed
Due reversed.

.PARAMETER termname
Payment term (e.g. 'Net 30') Required if not using `duedate`

.PARAMETER batchkey
Summary RECORDNO

.PARAMETER action
Action. Use Draft or Submit. (Default: Submit)

.PARAMETER invoiceno
Invoice number

.PARAMETER ponumber
Purchase-order number

.PARAMETER description
Description

.PARAMETER externalid
External ID

.PARAMETER billto
Bill to contact

.PARAMETER shipto
Ship to contact

.PARAMETER payto
payto to contact

.PARAMETER returnto
returnto to contact

.PARAMETER basecurrency
Base currency code

.PARAMETER currency
Transaction currency code

.PARAMETER exchratedate
Exchange rate date.

.PARAMETER exchratetype
Exchange rate type. Do not use if `exchrate` is set. (Leave blank to use Intacct Daily Rate)

.PARAMETER exchrate
Exchange rate value. Do not use if `exchangeratetype` is set.

.PARAMETER nogl
Do not post to GL. Use false for No, true for Yes. (Default: false)

.PARAMETER supdocid
Attachments ID

.PARAMETER customfields
Custom fields

.PARAMETER invoiceitems
Invoice lines, must have at least 1 for create.  Optional for update.

.INPUTS
PsCustomObject

.OUTPUTS
System.Xml representation of Invoice, using Intacct's XSD

.LINK
https://developer.intacct.com/api/accounts-receivable/invoices/#create-invoice-legacy
#>

function ConvertTo-InvoiceXml {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Reverse')]
        [int]$key,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$customerid,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [datetime]$datecreated,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [datetime]$dateposted,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [datetime]$datedue,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$termname,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Reverse')]
        [datetime]$datereversed,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [int]$batchkey,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [ValidateSet('Draft','Submit')]
        [string]$action='Submit',

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$invoiceno,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$ponumber,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Reverse')]
        [string]$description,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [string]$externalid,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [string]$billto,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [string]$shipto,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$payto,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$returnto,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$basecurr,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$currency,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [datetime]$exchratedate,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$exchratetype,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$exchrate,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [bool]$nogl,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [string]$supdocid,

        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [pscustomobject[]]$customfields,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Create')]
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Update')]
        [pscustomobject[]]$invoiceitems
    )

    begin 
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
    }
    
    process 
    {
        Write-Debug "ParameterSetName: $($PSCmdlet.ParameterSetName)"
        switch -Wildcard ($PSCmdlet.ParameterSetName) 
        {
            'Create*' 
            {
                [void]$SB.Append("<create_invoice>")
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
                if ($datedue)
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
                [void]$SB.Append("</create_invoice>")
            }
            'Update*' 
            {
                [void]$SB.Append("<update_invoice>")
                if ($key) { [void]$SB.Append("<key>$key</key>") }
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
                if ($datedue)
                {
                    [void]$SB.Append(
                    "<datedue>
                        <year>$( $datedue.ToString('yyyy') )</year>
                        <month>$( $datedue.ToString('MM') )</month>
                        <day>$( $datedue.ToString('dd') )</day>
                    </datedue>")
                }
                if ($termname) { [void]$SB.Append("<termname>$termname</termname>")}
                if ($action) { [void]$SB.Append("<action>$action</action>")}
                if ($invoiceno) { [void]$SB.Append("<invoiceno>$invoiceno</invoiceno>")}
                if ($ponumber) { [void]$SB.Append("<ponumber>$ponumber</ponumber>")}
                if ($description) { [void]$SB.Append("<description>$( [System.Security.SecurityElement]::Escape($description) )</description>")}
                if ($payto) { [void]$SB.Append("<payto><contactname>$payto</contactname></payto>")}
                if ($returnto) { [void]$SB.Append("<returnto><contactname>$returnto</contactname></returnto>")}
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
                [void]$SB.Append("</update_invoice>")
            }
            'Reverse'
            {
                [void]$SB.Append("<reverse_invoice>")
                if ($key) { [void]$SB.Append("<key>$key</key>") }
                if ($datereversed)
                {
                    [void]$SB.Append(
                    "<datereversed>
                        <year>$( $datereversed.ToString('yyyy') )</year>
                        <month>$( $datereversed.ToString('MM') )</month>
                        <day>$( $datereversed.ToString('dd') )</day>
                    </datereversed>")
                }
                if ($description) { [void]$SB.Append("<description>$( [System.Security.SecurityElement]::Escape($description) )</description>")}
                [void]$SB.Append("</reverse_invoice>")
            }
        }
    }
    
    end
    {
        [xml]$SB.ToString()
    }

}
