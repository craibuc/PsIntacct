<#
CUSTOMERID	Optional	string	Customer ID to create. Required if company does not use auto-numbering.
NAME	Required	string	Name
DISPLAYCONTACT	Required	object	Contact info
STATUS	Optional	string	Status. Use active for Active or inactive for Inactive (Default: active)
ONETIME	Optional	boolean	One time. Use false for No, true for Yes. (Default: false)
HIDEDISPLAYCONTACT	Optional	boolean	Exclude from contact list. Use false for No, true for Yes. (Default: false)
CUSTTYPE	Optional	string	Customer type ID
CUSTREPID	Optional	string	Sales rep employee ID
PARENTID	Optional	string	Parent customer ID
GLGROUP	Optional	string	GL group name
TERRITORYID	Optional	string	Territory ID
SUPDOCID	Optional	string	Attachments ID
TERMNAME	Optional	string	Payment term
OFFSETGLACCOUNTNO	Optional	string	Offset AR GL account number
ARACCOUNT	Optional	string	Default AR GL account number
SHIPPINGMETHOD	Optional	string	Shipping method
RESALENO	Optional	string	Resale number
TAXID	Optional	string	Tax ID
CREDITLIMIT	Optional	currency	Credit limit
ONHOLD	Optional	boolean	On hold. Use false for No, true for Yes. (Default: false)
DELIVERY_OPTIONS	Optional	string	Delivery method. Use either Print, E-Mail, or Print#~#E-Mail for both. If using E-Mail, the customer contact must have a valid e-mail address.
CUSTMESSAGEID	Optional	string	Default invoice message
COMMENTS	Optional	string	Comments
CURRENCY	Optional	string	Default currency code
ADVBILLBY	Optional	integer	Bill in advance. Number of months or days before the start date. Use 0 through 9.
ADVBILLBYTYPE	Optional	string	Bill-in-advance time period. Required if using bill in advance. Use days or months.
ARINVOICEPRINTTEMPLATEID	Optional	string	Print option - AR invoice template name
OEQUOTEPRINTTEMPLATEID	Optional	string	Print option - OE quote template name
OEORDERPRINTTEMPLATEID	Optional	string	Print option - OE order template name
OELISTPRINTTEMPLATEID	Optional	string	Print option - OE list template name
OEINVOICEPRINTTEMPLATEID	Optional	string	Print option - OE invoice template name
OEADJPRINTTEMPLATEID	Optional	string	Print option - OE adjustment template name
OEOTHERPRINTTEMPLATEID	Optional	string	Print option - OE other template name
CONTACTINFO	Optional	object	Primary contact. If blank system will use DISPLAYCONTACT.
BILLTO	Optional	object	Bill to contact. If blank system will use DISPLAYCONTACT.
SHIPTO	Optional	object	Ship to contact. If blank system will use DISPLAYCONTACT.
CONTACT_LIST_INFO	Optional	CONTACT_LIST_INFO[]	Contact list. Multiple CONTACT_LIST_INFO elements may then be passed.
OBJECTRESTRICTION	Optional	object	Restriction type. Use Unrestricted, RootOnly, or Restricted. (Default Unrestricted)
RESTRICTEDLOCATIONS	Optional	string	Restricted location ID’s. Use if OBJECTRESTRICTION is Restricted. Implode multiple ID’s with #~#.
RESTRICTEDDEPARTMENTS	Optional	string	Restricted department ID’s. Use if OBJECTRESTRICTION is Restricted. Implode multiple ID’s with #~#.
Custom fields	Optional	varies	Custom fields. For a multi-pick-list custom field, implode multiple field values with #~#.
#>
function ConvertTo-CustomerXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$CUSTOMERID,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$NAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DISPLAYCONTACT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('active','inactive')]
        [string]$STATUS='active',

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [bool]$ONETIME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$HIDEDISPLAYCONTACT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CUSTTYPE,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$CUSTREPID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PARENTID

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$GLGROUP,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$TERRITORYID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$SUPDOCID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$TERMNAME,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OFFSETGLACCOUNTNO,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$ARACCOUNT,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$SHIPPINGMETHOD,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$RESALENO,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$TAXID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$CREDITLIMIT,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$ONHOLD,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$DELIVERY_OPTIONS,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$CUSTMESSAGEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$COMMENTS,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$CURRENCY,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$ADVBILLBY,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$ADVBILLBYTYPE,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$ARINVOICEPRINTTEMPLATEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OEQUOTEPRINTTEMPLATEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OEORDERPRINTTEMPLATEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OELISTPRINTTEMPLATEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OEINVOICEPRINTTEMPLATEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OEADJPRINTTEMPLATEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OEOTHERPRINTTEMPLATEID,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$CONTACTINFO,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$BILLTO,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$SHIPTO,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$CONTACT_LIST_INFO

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$OBJECTRESTRICTION,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$RESTRICTEDLOCATIONS,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$RESTRICTEDDEPARTMENTS
    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<CUSTOMER>")    
    }
    Process
    {
        if ($CUSTOMERID) { [void]$SB.Append("<CUSTOMERID>$CUSTOMERID</CUSTOMERID>") }
        if ($NAME) { [void]$SB.Append("<NAME>$NAME</NAME>") }
        if ($DISPLAYCONTACT) { [void]$SB.Append($DISPLAYCONTACT) } else { [void]$SB.Append("<DISPLAYCONTACT/>") }
        [void]$SB.Append("<HIDEDISPLAYCONTACT>$($HIDEDISPLAYCONTACT.ToString().ToLower())</HIDEDISPLAYCONTACT>")
        if ($STATUS) { [void]$SB.Append("<STATUS>$STATUS</STATUS>") }
        if ($CUSTTYPE) { [void]$SB.Append("<CUSTTYPE>$CUSTTYPE</CUSTTYPE>") }
        # if ($CUSTREPID) { [void]$SB.Append("<CUSTREPID>$CUSTREPID</CUSTREPID>") }
        if ($PARENTID) { [void]$SB.Append("<PARENTID>$PARENTID</PARENTID>") }
        # if ($CONTACT_LIST_INFO) { [void]$SB.Append($CONTACT_LIST_INFO) } else { [void]$SB.Append("<CONTACT_LIST_INFO/>") }
    }
    End
    {
        [void]$SB.Append("</CUSTOMER>")
        $SB.ToString()    
    }

}
