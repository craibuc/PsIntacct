<#
.SYNOPSIS
Convert Customer model to Xml.

.PARAMETER CUSTOMERID
string	Customer ID to create. Required if company does not use auto-numbering.

.PARAMETER NAME
string	Name

.PARAMETER DISPLAYCONTACT
object	Contact info

.PARAMETER STATUS
string	Status. Use active for Active or inactive for Inactive (Default: active)

.PARAMETER ONETIME
boolean	One time. Use false for No, true for Yes. (Default: false)

.PARAMETER HIDEDISPLAYCONTACT
boolean	Exclude from contact list. Use false for No, true for Yes. (Default: false)

.PARAMETER CUSTTYPE
string	Customer type ID

.PARAMETER CUSTREPID
string	Sales rep employee ID

.PARAMETER PARENTID
string	Parent customer ID

.PARAMETER GLGROUP
string	GL group name

.PARAMETER TERRITORYID
string	Territory ID

.PARAMETER SUPDOCID
string	Attachments ID

.PARAMETER TERMNAME
string	Payment term

.PARAMETER OFFSETGLACCOUNTNO
string	Offset AR GL account number

.PARAMETER ARACCOUNT
string	Default AR GL account number

.PARAMETER SHIPPINGMETHOD
string	Shipping method

.PARAMETER RESALENO
string	Resale number

.PARAMETER TAXID
string	Tax ID

.PARAMETER CREDITLIMIT
currency	Credit limit

.PARAMETER ONHOLD
boolean	On hold. Use false for No, true for Yes. (Default: false)

.PARAMETER DELIVERY_OPTIONS
string	Delivery method. Use either Print, E-Mail, or Print#~#E-Mail for both. If using E-Mail, the customer contact must have a valid e-mail address.

.PARAMETER CUSTMESSAGEID
string	Default invoice message

.PARAMETER COMMENTS
string	Comments

.PARAMETER CURRENCY
string	Default currency code

.PARAMETER ADVBILLBY
integer	Bill in advance. Number of months or days before the start date. Use 0 through 9.

.PARAMETER ADVBILLBYTYPE
string	Bill-in-advance time period. Required if using bill in advance. Use days or months.

.PARAMETER ARINVOICEPRINTTEMPLATEID
string	Print option - AR invoice template name

.PARAMETER OEQUOTEPRINTTEMPLATEID
string	Print option - OE quote template name

.PARAMETER OEORDERPRINTTEMPLATEID
string	Print option - OE order template name

.PARAMETER OELISTPRINTTEMPLATEID
string	Print option - OE list template name

.PARAMETER OEINVOICEPRINTTEMPLATEID
string	Print option - OE invoice template name

.PARAMETER OEADJPRINTTEMPLATEID
string	Print option - OE adjustment template name

.PARAMETER OEOTHERPRINTTEMPLATEID
string	Print option - OE other template name

.PARAMETER CONTACTINFO
object	Primary contact. If blank system will use DISPLAYCONTACT.

.PARAMETER BILLTO
object	Bill to contact. If blank system will use DISPLAYCONTACT.

.PARAMETER SHIPTO
object	Ship to contact. If blank system will use DISPLAYCONTACT.

.PARAMETER CONTACT_LIST_INFO
CONTACT_LIST_INFO[]	Contact list. Multiple CONTACT_LIST_INFO elements may then be passed.

.PARAMETER OBJECTRESTRICTION
object	Restriction type. Use Unrestricted, RootOnly, or Restricted. (Default Unrestricted)

.PARAMETER RESTRICTEDLOCATIONS
string	Restricted location ID’s. Use if OBJECTRESTRICTION is Restricted. Implode multiple ID’s with #~#.

.PARAMETER RESTRICTEDDEPARTMENTS
string	Restricted department ID’s. Use if OBJECTRESTRICTION is Restricted. Implode multiple ID’s with #~#.

.PARAMETER Custom
Optional	varies	Custom fields. For a multi-pick-list custom field, implode multiple field values with #~#.
#>
function ConvertTo-CustomerXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$CUSTOMERID,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$NAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$DISPLAYCONTACT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('active','inactive')]
        [string]$STATUS='active',

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$ONETIME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$HIDEDISPLAYCONTACT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CUSTTYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CUSTREPID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PARENTID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$GLGROUP,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TERRITORYID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$SUPDOCID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TERMNAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OFFSETGLACCOUNTNO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ARACCOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$SHIPPINGMETHOD,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$RESALENO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TAXID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$CREDITLIMIT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$ONHOLD,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DELIVERY_OPTIONS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CUSTMESSAGEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$COMMENTS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CURRENCY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(0, 9)]
        [int]$ADVBILLBY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ADVBILLBYTYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ARINVOICEPRINTTEMPLATEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OEQUOTEPRINTTEMPLATEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OEORDERPRINTTEMPLATEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OELISTPRINTTEMPLATEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OEINVOICEPRINTTEMPLATEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OEADJPRINTTEMPLATEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OEOTHERPRINTTEMPLATEID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CONTACTINFO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BILLTO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$SHIPTO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CONTACT_LIST_INFO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Unrestricted', 'RootOnly', 'Restricted')]
        [string]$OBJECTRESTRICTION='Unrestricted',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$RESTRICTEDLOCATIONS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$RESTRICTEDDEPARTMENTS
    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<CUSTOMER>")
    }
    Process
    {
        # mandatory
        if ($CUSTOMERID) { [void]$SB.Append("<CUSTOMERID>$CUSTOMERID</CUSTOMERID>") }
        if ($NAME) { [void]$SB.Append("<NAME>$NAME</NAME>") }
        # /mandatory

        if ($DISPLAYCONTACT)
        { 
            $dc = $DISPLAYCONTACT | ConvertTo-ContactXml
            [void]$SB.Append( $dc.OuterXml )
            # [void]$SB.Append($DISPLAYCONTACT) 
        } 
        else { [void]$SB.Append("<DISPLAYCONTACT/>") }

        [void]$SB.Append("<HIDEDISPLAYCONTACT>$($HIDEDISPLAYCONTACT.ToString().ToLower())</HIDEDISPLAYCONTACT>")
        if ($STATUS) { [void]$SB.Append("<STATUS>$STATUS</STATUS>") }
        [void]$SB.Append("<ONETIME>$( $ONETIME.ToString().ToLower() )</ONETIME>")
        if ($CUSTTYPE) { [void]$SB.Append("<CUSTTYPE>$CUSTTYPE</CUSTTYPE>") }
        if ($CUSTREPID) { [void]$SB.Append("<CUSTREPID>$CUSTREPID</CUSTREPID>") }
        if ($PARENTID) { [void]$SB.Append("<PARENTID>$PARENTID</PARENTID>") }
        if ($GLGROUP) { [void]$SB.Append("<GLGROUP>$GLGROUP</GLGROUP>") }
        if ($TERRITORYID) { [void]$SB.Append("<TERRITORYID>$TERRITORYID</TERRITORYID>") }
        if ($SUPDOCID) { [void]$SB.Append("<SUPDOCID>$SUPDOCID</SUPDOCID>") }
        if ($TERMNAME) { [void]$SB.Append("<TERMNAME>$TERMNAME</TERMNAME>") }
        if ($OFFSETGLACCOUNTNO) { [void]$SB.Append("<OFFSETGLACCOUNTNO>$OFFSETGLACCOUNTNO</OFFSETGLACCOUNTNO>") }
        if ($ARACCOUNT) { [void]$SB.Append("<ARACCOUNT>$ARACCOUNT</ARACCOUNT>") }
        if ($SHIPPINGMETHOD) { [void]$SB.Append("<SHIPPINGMETHOD>$SHIPPINGMETHOD</SHIPPINGMETHOD>") }
        if ($RESALENO) { [void]$SB.Append("<RESALENO>$RESALENO</RESALENO>") }
        if ($TAXID) { [void]$SB.Append("<TAXID>$TAXID</TAXID>") }
        if ($CREDITLIMIT) { [void]$SB.Append("<CREDITLIMIT>$CREDITLIMIT</CREDITLIMIT>") }
        if ($ONHOLD) { [void]$SB.Append("<ONHOLD>$ONHOLD</ONHOLD>") }
        if ($DELIVERY_OPTIONS) { [void]$SB.Append("<DELIVERY_OPTIONS>$DELIVERY_OPTIONS</DELIVERY_OPTIONS>") }
        if ($CUSTMESSAGEID) { [void]$SB.Append("<CUSTMESSAGEID>$CUSTMESSAGEID</CUSTMESSAGEID>") }
        if ($COMMENTS) { [void]$SB.Append("<COMMENTS>$COMMENTS</COMMENTS>") }
        if ($CURRENCY) { [void]$SB.Append("<CURRENCY>$CURRENCY</CURRENCY>") }

        if ($ADVBILLBY) { [void]$SB.Append("<ADVBILLBY>$ADVBILLBY</ADVBILLBY>") }
        if ($ADVBILLBYTYPE) { [void]$SB.Append("<ADVBILLBYTYPE>$ADVBILLBYTYPE</ADVBILLBYTYPE>") }
        if ($ARINVOICEPRINTTEMPLATEID) { [void]$SB.Append("<ARINVOICEPRINTTEMPLATEID>$ARINVOICEPRINTTEMPLATEID</ARINVOICEPRINTTEMPLATEID>") }
        if ($OEQUOTEPRINTTEMPLATEID) { [void]$SB.Append("<OEQUOTEPRINTTEMPLATEID>$OEQUOTEPRINTTEMPLATEID</OEQUOTEPRINTTEMPLATEID>") }
        if ($OEORDERPRINTTEMPLATEID) { [void]$SB.Append("<OEORDERPRINTTEMPLATEID>$OEORDERPRINTTEMPLATEID</OEORDERPRINTTEMPLATEID>") }
        if ($OELISTPRINTTEMPLATEID) { [void]$SB.Append("<OELISTPRINTTEMPLATEID>$OELISTPRINTTEMPLATEID</OELISTPRINTTEMPLATEID>") }
        if ($OEINVOICEPRINTTEMPLATEID) { [void]$SB.Append("<OEINVOICEPRINTTEMPLATEID>$OEINVOICEPRINTTEMPLATEID</OEINVOICEPRINTTEMPLATEID>") }
        if ($OEADJPRINTTEMPLATEID) { [void]$SB.Append("<OEADJPRINTTEMPLATEID>$OEADJPRINTTEMPLATEID</OEADJPRINTTEMPLATEID>") }
        if ($OEOTHERPRINTTEMPLATEID) { [void]$SB.Append("<OEOTHERPRINTTEMPLATEID>$OEOTHERPRINTTEMPLATEID</OEOTHERPRINTTEMPLATEID>") }
        if ($CONTACTINFO) { [void]$SB.Append("<CONTACTINFO>$CONTACTINFO</CONTACTINFO>") }
        if ($BILLTO) { [void]$SB.Append("<BILLTO>$BILLTO</BILLTO>") }
        if ($SHIPTO) { [void]$SB.Append("<SHIPTO>$SHIPTO</SHIPTO>") }
        if ($CONTACT_LIST_INFO) { [void]$SB.Append($CONTACT_LIST_INFO) } # else { [void]$SB.Append("<CONTACT_LIST_INFO/>") }
        # if ($OBJECTRESTRICTION) { [void]$SB.Append("<OBJECTRESTRICTION>$OBJECTRESTRICTION</OBJECTRESTRICTION>") }
        if ($RESTRICTEDLOCATIONS) { [void]$SB.Append("<RESTRICTEDLOCATIONS>$RESTRICTEDLOCATIONS</RESTRICTEDLOCATIONS>") }
        if ($RESTRICTEDDEPARTMENTS) { [void]$SB.Append("<RESTRICTEDDEPARTMENTS>$RESTRICTEDDEPARTMENTS</RESTRICTEDDEPARTMENTS>") }
    }
    End
    {
        [void]$SB.Append("</CUSTOMER>")
        $SB.ToString()
    }

}
