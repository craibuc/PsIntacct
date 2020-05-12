<#
.SYNOPSIS
Create an invoice line-item.

.PARAMETER amount
Transaction amount.

.PARAMETER accountlabel
AR account label. Required if not using glaccountno.

.PARAMETER glaccountno
GL account number. Required if not using accountlabel.

.PARAMETER offsetglaccountno
Offset GL account number

.PARAMETER revrecstartdate
Rev rec start date

.PARAMETER revrecenddate
Rev rec end date

.PARAMETER memo
Memo

.PARAMETER totalpaid
Total paid. Used when nogl on bill is true

.PARAMETER totaldue
Total due. Used when nogl on bill is true

.PARAMETER revrectemplate
Rev rec template ID

.PARAMETER defrevaccount
Deferred revenue GL account number

.PARAMETER allocationid
Allocation ID

.PARAMETER classid
Class ID

.PARAMETER contractid
Contract ID

.PARAMETER customerid
Customer ID

.PARAMETER departmentid
Department ID

.PARAMETER employeeid
Employee ID

.PARAMETER itemid
Item ID

.PARAMETER key
Key

.PARAMETER locationid
Location ID

.PARAMETER projectid
Project ID

.PARAMETER taskid
Task ID. Only available when the parent projectid is also specified.

.PARAMETER vendorid
Vendor ID

.PARAMETER warehouseid
Warehouse ID

.PARAMETER customfields
customfield[0...n]	Custom fields

.LINK
https://developer.intacct.com/api/accounts-receivable/invoices/#create-invoice-legacy

#>

function ConvertTo-InvoiceItemXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByAccountNumber', Mandatory)]
        [string]$glaccountno,
        
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByAccountLabel', Mandatory)]
        [string]$accountlabel,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByAccountNumber', Mandatory)]
		[Parameter(ValueFromPipelineByPropertyName, ParameterSetName='ByAccountLabel', Mandatory)]
        [decimal]$amount,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$memo,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$offsetglaccountno,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$revrecstartdate,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$revrecenddate,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$totalpaid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$totaldue,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$revrectemplate,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$defrevaccount,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$allocationid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$classid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$contractid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$customerid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$departmentid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$employeeid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$itemid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$key,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$locationid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$projectid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$taskid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$vendorid,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$warehouseid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject[]]$customfields
    )

    begin {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append('<invoiceitems>')
    }

    process {
        [void]$SB.Append('<lineitem>')
        
        # required
        if ($glaccountno) { [void]$SB.Append("<glaccountno>$glaccountno</glaccountno>")}
        if ($accountlabel) { [void]$SB.Append("<accountlabel>$accountlabel</accountlabel>")}
        # /required

        if ($offsetglaccountno) { [void]$SB.Append("<offsetglaccountno>$offsetglaccountno</offsetglaccountno>")}
        [void]$SB.Append("<amount>$amount</amount>")
        if ($allocationid) { [void]$SB.AppendLine("<allocationid>$allocationid</allocationid>") }
        if ($memo) { [void]$SB.Append("<memo>$( [System.Security.SecurityElement]::Escape($memo) )</memo>")}
        if ($locationid) { [void]$SB.AppendLine("<locationid>$locationid</locationid>") }
        if ($departmentid) { [void]$SB.AppendLine("<departmentid>$departmentid</departmentid>") }
        if ($key) { [void]$SB.AppendLine("<key>$key</key>") }
        if ($totalpaid) { [void]$SB.Append("<totalpaid>$totalpaid</totalpaid>")}
        if ($totaldue) { [void]$SB.Append("<totaldue>$totaldue</totaldue>")}
        
        if ($customfields)
        {
            $xml = $customfields | ConvertTo-CustomFieldXml
            [void]$SB.Append( $xml )
        }

        if ($revrectemplate) { [void]$SB.Append("<revrectemplate>$revrectemplate</revrectemplate>")}
        if ($defrevaccount) { [void]$SB.Append("<defrevaccount>$defrevaccount</defrevaccount>")}
        if ($revrecstartdate) { [void]$SB.Append("<revrecstartdate><year>$( $revrecstartdate.ToString('yyyy') )</year><month>$($revrecstartdate.ToString('MM'))</month><day>$($revrecstartdate.ToString('dd'))</day></revrecstartdate>") }
        if ($revrecenddate) { [void]$SB.Append("<revrecenddate><year>$($revrecenddate.ToString('yyyy'))</year><month>$($revrecenddate.ToString('MM'))</month><day>$($revrecenddate.ToString('dd'))</day></revrecenddate>")}
        if ($projectid) { [void]$SB.AppendLine("<projectid>$projectid</projectid>") }
        if ($taskid) { [void]$SB.AppendLine("<taskid>$taskid</taskid>") }
        if ($customerid) { [void]$SB.AppendLine("<customerid>$customerid</customerid>") }
        if ($vendorid) { [void]$SB.AppendLine("<vendorid>$vendorid</vendorid>") }
        if ($employeeid) { [void]$SB.AppendLine("<employeeid>$employeeid</employeeid>") }
        if ($itemid) { [void]$SB.AppendLine("<itemid>$itemid</itemid>") }
        if ($classid) { [void]$SB.AppendLine("<classid>$classid</classid>") }
        if ($contractid) { [void]$SB.AppendLine("<contractid>$contractid</contractid>") }
        if ($warehouseid) { [void]$SB.AppendLine("<warehouseid>$warehouseid</warehouseid>") }

        [void]$SB.Append('</lineitem>')
    }
    
    end {
        [void]$SB.Append('</invoiceitems>')
        $SB.ToString()
    }
}
