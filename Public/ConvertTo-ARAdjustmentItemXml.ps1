<#
.SYNOPSIS

.PARAMETER glaccountno
GL account number. Required if not using accountlabel.

.PARAMETER accountlabel
AP account label. Required if not using glaccountno.

.PARAMETER offsetglaccountno
Offset GL account number

.PARAMETER amount
Transaction amount. Use a positive number to create a debit memo or a negative number to create a credit memo.

.PARAMETER memo
Memo

.PARAMETER locationid
Location ID

.PARAMETER departmentid
Department ID

.PARAMETER key
Key

.PARAMETER totalpaid
Total paid. Used when nogl on bill is true

.PARAMETER totaldue
Total due. Used when nogl on bill is true

.PARAMETER customfields
0...n]	Custom fields

.PARAMETER projectid
Project ID

.PARAMETER taskid
Task ID. Only available when the parent projectid is also specified.

.PARAMETER customerid
Customer ID

.PARAMETER vendorid
Vendor ID

.PARAMETER employeeid
Employee ID

.PARAMETER itemid
Item ID

.PARAMETER classid
Class ID

.PARAMETER contractid
Contract ID

.PARAMETER warehouseid
Warehouse ID

#>
function ConvertTo-ARAdjustmentItemXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$glaccountno,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$accountlabel,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$offsetglaccountno,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [decimal]$amount,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$memo,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$locationid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$departmentid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$key,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$totalpaid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$totaldue,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject[]]$customfields,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$projectid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$taskid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$customerid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$vendorid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$employeeid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$itemid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$classid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$contractid,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$warehouseid
    )

    begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<aradjustmentitems>")
    }
    process
    {
        [void]$SB.Append("<lineitem>")
        if ($batchkey) { [void]$SB.Append("<batchkey>$batchkey</batchkey>") }
        if ($glaccountno) { [void]$SB.Append("<glaccountno>$glaccountno</glaccountno>") }
        if ($accountlabel) { [void]$SB.Append("<accountlabel>$accountlabel</accountlabel>") }
        if ($offsetglaccountno) { [void]$SB.Append("<offsetglaccountno>$offsetglaccountno</offsetglaccountno>") }
        if ($amount) { [void]$SB.Append("<amount>$amount</amount>") }
        if ($memo) { [void]$SB.Append("<memo>$memo</memo>") }
        if ($locationid) { [void]$SB.Append("<locationid>$locationid</locationid>") }
        if ($departmentid) { [void]$SB.Append("<departmentid>$departmentid</departmentid>") }
        if ($key) { [void]$SB.Append("<key>$key</key>") }
        if ($totalpaid) { [void]$SB.Append("<totalpaid>$totalpaid</totalpaid>") }
        if ($totaldue) { [void]$SB.Append("<totaldue>$totaldue</totaldue>") }
        if ($customfields)
        {
            $xml = $customfields | ConvertTo-CustomFieldXml
            [void]$SB.Append( $xml )
        }
        if ($projectid) { [void]$SB.Append("<projectid>$projectid</projectid>") }
        if ($taskid) { [void]$SB.Append("<taskid>$taskid</taskid>") }
        if ($customerid) { [void]$SB.Append("<customerid>$customerid</customerid>") }
        if ($vendorid) { [void]$SB.Append("<vendorid>$vendorid</vendorid>") }
        if ($employeeid) { [void]$SB.Append("<employeeid>$employeeid</employeeid>") }
        if ($itemid) { [void]$SB.Append("<itemid>$itemid</itemid>") }
        if ($classid) { [void]$SB.Append("<classid>$classid</classid>") }
        if ($contractid) { [void]$SB.Append("<contractid>$contractid</contractid>") }
        if ($warehouseid) { [void]$SB.Append("<warehouseid>$warehouseid</warehouseid>") }
        [void]$SB.Append("</lineitem>")
    }
    end
    {
        [void]$SB.Append("</aradjustmentitems>")
        $SB.ToString()
    }

}
