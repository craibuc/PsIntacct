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

function New-InvoiceItem {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [decimal]$amount,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$glaccountno,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$accountlabel,
        
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
        [string]$customfields
    )

    begin {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append('<invoiceitems>')
    }

    process {
        [void]$SB.Append('<lineitem>')

        if ($amount) { [void]$SB.Append("<amount>$amount</amount>")}
        if ($accountlabel) { [void]$SB.Append("<accountlabel>$accountlabel</accountlabel>")}
        if ($glaccountno) { [void]$SB.Append("<glaccountno>$glaccountno</glaccountno>")}
        if ($offsetglaccountno) { [void]$SB.Append("<offsetglaccountno>$offsetglaccountno</offsetglaccountno>")}
        if ($memo) { [void]$SB.Append("<memo>$memo</memo>")}
        if ($revrecstartdate) { [void]$SB.Append("<revrecstartdate><year>$( $revrecstartdate.ToString('yyyy') )</year><month>$($revrecstartdate.ToString('MM'))</month><day>$($revrecstartdate.ToString('dd'))</day></revrecstartdate>") }
        if ($revrecenddate) { [void]$SB.Append("<revrecenddate><year>$($revrecenddate.ToString('yyyy'))</year><month>$($revrecenddate.ToString('MM'))</month><day>$($revrecenddate.ToString('dd'))</day></revrecenddate>")}

        if ($totalpaid) { [void]$SB.Append("<totalpaid>$totalpaid</totalpaid>")}
        if ($totaldue) { [void]$SB.Append("<totaldue>$totaldue</totaldue>")}

        if ($revrectemplate) { [void]$SB.Append("<revrectemplate>$revrectemplate</revrectemplate>")}
        if ($defrevaccount) { [void]$SB.Append("<defrevaccount>$defrevaccount</defrevaccount>")}

        if ($allocationid) { [void]$SB.AppendLine("<allocationid>$allocationid</allocationid>") }
        if ($classid) { [void]$SB.AppendLine("<classid>$classid</classid>") }
        if ($contractid) { [void]$SB.AppendLine("<contractid>$contractid</contractid>") }
        if ($customerid) { [void]$SB.AppendLine("<customerid>$customerid</customerid>") }
        if ($departmentid) { [void]$SB.AppendLine("<departmentid>$departmentid</departmentid>") }
        if ($employeeid) { [void]$SB.AppendLine("<employeeid>$employeeid</employeeid>") }
        if ($itemid) { [void]$SB.AppendLine("<itemid>$itemid</itemid>") }
        if ($key) { [void]$SB.AppendLine("<key>$key</key>") }
        if ($locationid) { [void]$SB.AppendLine("<locationid>$locationid</locationid>") }
        if ($projectid) { [void]$SB.AppendLine("<projectid>$projectid</projectid>") }
        if ($taskid) { [void]$SB.AppendLine("<taskid>$taskid</taskid>") }
        if ($vendorid) { [void]$SB.AppendLine("<vendorid>$vendorid</vendorid>") }
        if ($warehouseid) { [void]$SB.AppendLine("<warehouseid>$warehouseid</warehouseid>") }

        [void]$SB.Append('</lineitem>')
    }
    
    end {
        [void]$SB.Append('</invoiceitems>')
        $SB.ToString()
    }
}
