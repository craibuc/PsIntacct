<#
.SYNOPSIS

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

#>
function New-Invoice {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$CustomerId,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [datetime]$DateCreated,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$DatePosted,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$DateDue,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Terms,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BatchKey,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Draft','Submit')]
        [string]$Action='Submit',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$InvoiceNo,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PoNumber,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ExternalId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BillTo,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ShipTo,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BaseCurrency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Currency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$ExchangeRateDate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ExchangeRateType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ExchangeRate,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$NoGL,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DocumentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$CustomField

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [pscustomobject[]]$invoiceitems
    )
        
    begin 
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"    
    }
    
    process 
    {
        # $Fields = @()
        if ($CustomerId) { $Fields+= "<customerid>$CustomerId</customerid>"}
        if ($DateCreated)
        {
            $Fields+= 
            "<datecreated>
                <year>$( $DateCreated.ToString('yyyy') )</year>
                <month>$( $DateCreated.ToString('MM') )</month>
                <day>$( $DateCreated.ToString('dd') )</day>
            </datecreated>"
        }
        if ($DatePosted)
        {
            $Fields+= 
            "<dateposted>
                <year>$( $DatePosted.ToString('yyyy') )</year>
                <month>$( $DatePosted.ToString('MM') )</month>
                <day>$( $DatePosted.ToString('dd') )</day>
            </dateposted>"
        }
        if ($DateDue)
        {
            $Fields+= 
            "<datedue>
                <year>$( $DateDue.ToString('yyyy') )</year>
                <month>$( $DateDue.ToString('MM') )</month>
                <day>$( $DateDue.ToString('dd') )</day>
            </datedue>"
        }
        if ($Terms) { $Fields+= "<termname>$Terms</termname>"}
        if ($BatchKey) { $Fields+= "<batchkey>$BatchKey</batchkey>"}
        if ($Action) { $Fields+= "<action>$Action</action>"}
        if ($InvoiceNo) { $Fields+= "<invoiceno>$InvoiceNo</invoiceno>"}
        if ($PoNumber) { $Fields+= "<ponumber>$PoNumber</ponumber>"}
        if ($Description) { $Fields+= "<description>$Description</description>"}
        if ($ExternalId) { $Fields+= "<externalid>$ExternalId</externalid>"}
        if ($BillTo) { $Fields+= "<billto><contactname>$BillTo</contactname></billto>"}
        if ($ShipTo) { $Fields+= "<shipto><contactname>$ShipTo</contactname></shipto>"}
        if ($BaseCurrency) { $Fields+= "<basecurr>$BaseCurrency</basecurr>"}
        if ($Currency) { $Fields+= "<currency>$Currency</currency>"}
        if ($ExchangeRateDate) 
        {
            $Fields+= 
            "<exchratedate>
                <year>$( $ExchangeRateDate.ToString('yyyy') )</year>
                <month>$( $ExchangeRateDate.ToString('MM') )</month>
                <day>$( $ExchangeRateDate.ToString('dd') )</day>
            </exchratedate>"
        }
        if ($ExchangeRateType) { $Fields+= "<exchratetype>$ExchangeRateType</exchratetype>"}
        if ($ExchangeRate) { $Fields+= "<exchrate>$ExchangeRate</exchrate>"}

        if ($NoGL) { $Fields+= "<nogl>$($NoGL.ToString().ToLower())</nogl>"}
        if ($DocumentId) { $Fields+= "<supdocid>$DocumentId</supdocid>"}

        if ($CustomField) 
        {
            $Fields+= '<customfields>'
            foreach ($Key in $CustomField.Keys) 
            {
                $Fields+=
                "<customfield>
                    <customfieldname>$($Key)</customfieldname>
                    <customfieldvalue>$($CustomField[$Key])</customfieldvalue>
                </customfield>"
            }
            $Fields+='</customfields>'
        }

        $Function = 
"
<function controlid='$( New-Guid )'>
    <create_invoice>
        $( $Fields -Join "`n" )
    </create_invoice>
</function>
"

        Write-Debug $Function

        try
        {
            $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
            Write-Debug "status: $($Content.response.operation.result.status)"
        }
        catch
        {
            $_
        }

    }
    
    end {}

}
