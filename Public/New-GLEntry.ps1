<#
.SYNOPIS
Create 

.PARAMETER ACCOUNTNO
Account number

.PARAMETER TRX_AMOUNT
Absolute value of Amount. Relates to TR_TYPE.

.PARAMETER TR_TYPE
Transaction type. 1 for Increase, otherwise -1 for Decrease.

.PARAMETER DOCUMENT
Document number of entry

.PARAMETER DESCRIPTION
Memo. If left blank, set this value to match BATCH_TITLE.

.PARAMETER ALLOCATION
Allocation ID. All other dimension elements are ignored if allocation is set. Use Custom for custom splits and see SPLIT element below.

.PARAMETER DEPARTMENT
Department ID

.PARAMETER LOCATION
Location ID. Required if multi-entity enabled.

.PARAMETER PROJECTID
Project ID

.PARAMETER CUSTOMERID
Customer ID

.PARAMETER VENDORID
Vendor ID

.PARAMETER EMPLOYEEID
Employee ID

.PARAMETER ITEMID
Item ID

.PARAMETER CLASSID
Class ID

.PARAMETER CONTRACTID
Contract ID

.PARAMETER WAREHOUSEID
Warehouse ID

.PARAMETER SPLIT
Custom allocation split. Required if ALLOCATION equals Custom. Multiple SPLIT elements may then be passed.

.PARAMETER Custom
Custom fields. For a multi-pick-list custom field, implode multiple field values with #~#.

.LINK
https://developer.intacct.com/api/general-ledger/stat-journal-entries/#create-statistical-journal-entry

#>
function New-GLEntry {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$ACCOUNTNO,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$TRX_AMOUNT,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [ValidateSet(1,-1)]
        [string]$TR_TYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DOCUMENT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DESCRIPTION,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ALLOCATION,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DEPARTMENT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LOCATION,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PROJECTID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CUSTOMERID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$VENDORID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$EMPLOYEEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ITEMID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CLASSID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CONTRACTID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$WAREHOUSEID

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$SPLIT

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$Custom
    )
    
    begin
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"
        $SB = New-Object -TypeName System.Text.StringBuilder

        # return a void, rather than a StringBuilder instance
        [void]$SB.Append('<ENTRIES>')
    }
    
    process
    {
        [void]$SB.Append('<GLENTRY>')
        # mandatory
        if ($ACCOUNTNO) { [void]$SB.Append("<ACCOUNTNO>$ACCOUNTNO</ACCOUNTNO>") }
        if ($TRX_AMOUNT) { [void]$SB.Append("<TRX_AMOUNT>$([System.Math]::Abs($TRX_AMOUNT))</TRX_AMOUNT>") }
        if ($TR_TYPE) { [void]$SB.Append("<TR_TYPE>$TR_TYPE</TR_TYPE>") }
        # # optional
        if ($DOCUMENT) { [void]$SB.Append("<DOCUMENT>$DOCUMENT</DOCUMENT>") }
        if ($DESCRIPTION) { [void]$SB.Append("<DESCRIPTION>$DESCRIPTION</DESCRIPTION>") }
        if ($ALLOCATION) { [void]$SB.Append("<ALLOCATION>$ALLOCATION</ALLOCATION>") }
        if ($DEPARTMENT) { [void]$SB.Append("<DEPARTMENT>$DEPARTMENT</DEPARTMENT>") }
        if ($LOCATION) { [void]$SB.Append("<LOCATION>$LOCATION</LOCATION>") }
        if ($PROJECTID) { [void]$SB.Append("<PROJECTID>$PROJECTID</PROJECTID>") }
        if ($CUSTOMERID) { [void]$SB.Append("<CUSTOMERID>$CUSTOMERID</CUSTOMERID>") }
        if ($VENDORID) { [void]$SB.Append("<VENDORID>$VENDORID</VENDORID>") }
        if ($EMPLOYEEID) { [void]$SB.Append("<EMPLOYEEID>$EMPLOYEEID</EMPLOYEEID>") }
        if ($ITEMID) { [void]$SB.Append("<ITEMID>$ITEMID</ITEMID>") }
        if ($CLASSID) { [void]$SB.Append("<CLASSID>$CLASSID</CLASSID>") }
        if ($CONTRACTID) { [void]$SB.Append("<CONTRACTID>$CONTRACTID</CONTRACTID>") }
        if ($WAREHOUSEID) { [void]$SB.Append("<WAREHOUSEID>$WAREHOUSEID</WAREHOUSEID>") }
        # if ($SPLIT) { $Fields+= "<SPLIT/>"}
        [void]$SB.Append('</GLENTRY>')
    }
    
    end
    {
        [void]$SB.Append('</ENTRIES>')
        # serialize
        $SB.ToString()
    }

}
