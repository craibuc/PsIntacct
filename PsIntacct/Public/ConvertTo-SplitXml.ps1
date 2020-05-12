<#
.SYNOPSIS
Convert Split model to Xml.

.PARAMETER AMOUNT
Split transaction amount. The sum of the AMOUNT values for all the SPLIT elements must equal the TRX_AMOUNT value for the GLENTRY element.

.PARAMETER DEPARTMENTID
Department ID

.PARAMETER LOCATIONID
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

#>
function ConvertTo-SplitXml 
{

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$AMOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DEPARTMENTID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LOCATIONID,

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
    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<SPLIT>")    
    }
    Process
    {
        if ($AMOUNT) { [void]$SB.Append("<AMOUNT>$AMOUNT</AMOUNT>") }
        if ($DEPARTMENTID) { [void]$SB.Append("<DEPARTMENTID>$DEPARTMENTID</DEPARTMENTID>") }
        if ($LOCATIONID) { [void]$SB.Append("<LOCATIONID>$LOCATIONID</LOCATIONID>") }
        if ($PROJECTID) { [void]$SB.Append("<PROJECTID>$PROJECTID</PROJECTID>") }
        if ($CUSTOMERID) { [void]$SB.Append("<CUSTOMERID>$CUSTOMERID</CUSTOMERID>") }
        if ($VENDORID) { [void]$SB.Append("<VENDORID>$VENDORID</VENDORID>") }
        if ($EMPLOYEEID) { [void]$SB.Append("<EMPLOYEEID>$EMPLOYEEID</EMPLOYEEID>") }
        if ($ITEMID) { [void]$SB.Append("<ITEMID>$ITEMID</ITEMID>") }
        if ($CLASSID) { [void]$SB.Append("<CLASSID>$CLASSID</CLASSID>") }
        if ($CONTRACTID) { [void]$SB.Append("<CONTRACTID>$CONTRACTID</CONTRACTID>") }
        if ($WAREHOUSEID) { [void]$SB.Append("<WAREHOUSEID>$WAREHOUSEID</WAREHOUSEID>") }
    }
    End
    {
        [void]$SB.Append("</SPLIT>")
        $SB.ToString()    
    }
}
