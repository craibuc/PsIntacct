<#
.PARAMETER ACCOUNTNO
GL account number. Required if not using ACCOUNTLABEL.
.PARAMETER ACCOUNTLABEL
AP account label. Required if not using ACCOUNTNO.
.PARAMETER OFFSETGLACCOUNTNO
AP account number
.PARAMETER TRX_AMOUNT
Transaction amount before taxes. This value is required if INCLUSIVETAX is set to false (or omitted) on the header. (This value will be ignored as an input if INCLUSIVETAX is true because the value will be calculated for you.)
.PARAMETER TOTALTRXAMOUNT
Transaction amount for the line including taxes, which is required if INCLUSIVETAX is set to true on the header. The system uses the value you provide here and the tax rate of the tax detail (DETAILID) for the tax entry to calculate the transaction amount (TRX_AMOUNT) for the line and transaction tax (TRX_TAX) for the tax entry. (AU, GB, ZA only)
.PARAMETER ENTRYDESCRIPTION
Memo
.PARAMETER FORM1099
Form 1099. Use false for No, true for Yes. Vendor must be set up for 1099s.
.PARAMETER FORM1099TYPE
Form 1099 type
.PARAMETER FORM1099BOX
Form 1099 box
.PARAMETER BILLABLE
Billable. Use false for No, true for Yes. (Default: false)
.PARAMETER ALLOCATION
Allocation ID
.PARAMETER LOCATIONID
Location ID
.PARAMETER DEPARTMENTID
Department ID
.PARAMETER PROJECTID
Project ID
.PARAMETER TASKID
Task ID. Only available when the parent PROJECTID is also specified.
.PARAMETER COSTTYPEID
Cost type ID. Only available when PROJECTID and TASKID are specified. (Construction subscription)
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
.PARAMETER GLDIM
User defined dimension id field. UDD object integration name usually appended to GLDIM
.PARAMETER Custom
Custom fields. For a multi-pick-list custom field, implode multiple field values with #~#.
.PARAMETER TAXENTRIES
TAXENTRY[1]	Tax entry for the line (AU, GB, ZA only)
#>

function ConvertTo-APBillItem 
{

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='ByAccountNo',Mandatory)]
        [string]$ACCOUNTNO,
        [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='ByAccountLabel',Mandatory)]
        [string]$ACCOUNTLABEL,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OFFSETGLACCOUNTNO,
        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TRX_AMOUNT,
        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$TOTALTRXAMOUNT,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ENTRYDESCRIPTION,
        [Parameter(ValueFromPipelineByPropertyName)]
        [boolean]$FORM1099,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FORM1099TYPE,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FORM1099BOX,
        [Parameter(ValueFromPipelineByPropertyName)]
        [boolean]$BILLABLE,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ALLOCATION,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LOCATIONID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DEPARTMENTID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PROJECTID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TASKID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$COSTTYPEID,
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
        [string]$WAREHOUSEID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$GLDIM,
        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$CUSTOMFIELDS,
        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$TAXENTRIES
    )
    
    begin {
        $SB = [Text.StringBuilder]::new()
        [void]$SB.Append("<APBILLITEM>")        
    }
    
    process {
        
        foreach($parameter in $PSBoundParameters.GetEnumerator())
        {
            switch ($parameter.Key) {
                # encode reserved Xml characters (& --> &amp;)
                # {$_ -in 'NAME'} { 
                #     $Text = "<{0}>{1}</{0}>" -f $parameter.Key, [System.Security.SecurityElement]::Escape($parameter.Value)
                #     [void]$SB.Append( $Text )
                # }
                # boolean fields need to be lower case
                {$_ -in 'FORM1099','BILLABLE'} { 
                    $Text = "<{0}>{1}</{0}>" -f $parameter.Key, $parameter.Value.ToString().ToLower()
                    [void]$SB.Append( $Text )
                }
                # pscustomobjects
                {$_ -in 'CUSTOMFIELDS'} {
                    foreach ($property in $parameter.Value.PSObject.Properties) {
                        $Text = "<{0}>{1}</{0}>" -f $property.Name, $property.Value
                        [void]$SB.Append( $Text )
                    }
                }
                {$_ -in 'TAXENTRIES'} {
                    Throw [NotImplementedException]::new()
                }
                # otherwise
                Default { 
                    $Text = "<{0}>{1}</{0}>" -f $parameter.Key, $parameter.Value
                    [void]$SB.Append( $Text )
                }
            } # /switch
        } # /foreach

    }
    
    end {
        [void]$SB.Append("</APBILLITEM>")
        Write-Debug $SB.ToString()
        [xml]$SB.ToString()   
    }

}