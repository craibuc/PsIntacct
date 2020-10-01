<#
.SYNOPSIS
Convert Vendor model to Xml.

.PARAMETER VENDORID
Vendor VENDORID to create. Required if company does not use auto-numbering.
.PARAMETER NAME
Name
.PARAMETER DISPLAYCONTACT
Contact info
.PARAMETER STATUS
Use active for Active or inactive for Inactive (Default: active)
.PARAMETER ONETIME
One time. Use false for No, true for Yes. (Default: false)
.PARAMETER HIDEDISPLAYCONTACT
Exclude from contact list. Use false for No, true for Yes. (Default: false)
.PARAMETER VENDTYPE
Vendor type ID
.PARAMETER PARENTID
Parent vendor ID
.PARAMETER GLGROUP
GL group name
.PARAMETER DEFAULT_LEAD_TIME
Default lead time in days for replenishment purposes. Can be overridden by lead time specified on an item with that vendor, or lead time specified for on an item with a warehouse/vendor combination with that vendor. (Default: 1)
.PARAMETER TAXID
Tax ID
.PARAMETER NAME1099
Form 1099 name
.PARAMETER FORM1099TYPE
Form 1099 type
.PARAMETER FORM1099BOX
Form 1099 box
.PARAMETER SUPDOCID
Attachments ID
.PARAMETER APACCOUNT
Default expense GL account number
.PARAMETER OFFSETGLACCOUNTNO
AP account number
.PARAMETER CREDITLIMIT
Credit limit
.PARAMETER RETAINAGEPERCENTAGE
Default retainage percentage for vendors. (Construction subscription)
.PARAMETER ONHOLD
On hold. Use false for No, true for Yes. (Default: false)
.PARAMETER DONOTCUTCHECK
Do not pay. Use false for No, true for Yes. (Default: false)
.PARAMETER COMMENTS
Comments
.PARAMETER CURRENCY
Default currency code
.PARAMETER CONTACTINFO
Primary contact. If blank system will use DISPLAYCONTACT.
.PARAMETER PAYTO
Pay to contact. If blank system will use DISPLAYCONTACT.
.PARAMETER RETURNTO
Return to contact. If blank system will use DISPLAYCONTACT.
.PARAMETER CONTACT_LIST_INFO
[]	Contact list. Multiple CONTACT_LIST_INFO elements may then be passed.
.PARAMETER PAYMETHODKEY
Preferred payment method
.PARAMETER MERGEPAYMENTREQ
Merge payment requests. Use false for No, true for Yes. (Default: true)
.PARAMETER PAYMENTNOTIFY
Send automatic payment notification. Use false for No, true for Yes. (Default: false)
.PARAMETER BILLINGTYPE
Vendor billing type
.PARAMETER PAYMENTPRIORITY
Payment priority
.PARAMETER TERMNAME
Payment term
.PARAMETER DISPLAYTERMDISCOUNT
Display term discount on check stub. Use false for No, true for Yes. (Default: true)
.PARAMETER ACHENABLED
ACH enabled. Use false for No, true for Yes. (Default: false)
.PARAMETER ACHBANKROUTINGNUMBER
ACH bank routing number
.PARAMETER ACHACCOUNTNUMBER
ACH bank account number
.PARAMETER ACHACCOUNTTYPE
ACH bank account type
.PARAMETER ACHREMITTANCETYPE
ACH bank account class
.PARAMETER VENDORACCOUNTNO
Vendor account number
.PARAMETER DISPLOCACCTNOCHECK
Display location assigned account number on check stub. Use false for No, true for Yes. (Default: false)
.PARAMETER VENDOR_ACCTNO_LOC_HEAD
Vendor location assigned account numbers. Multiple VENDOR_ACCTNO_LOC_HEAD elements may then be passed.
.PARAMETER OBJECTRESTRICTION
Restriction type. Use Unrestricted, RootOnly, or Restricted. (Default Unrestricted)
.PARAMETER RESTRICTEDLOCATIONS
Restricted location ID’s. Use if OBJECTRESTRICTION is Restricted. Implode multiple ID’s with #~#.
.PARAMETER RESTRICTEDDEPARTMENTS
Restricted department ID’s. Use if OBJECTRESTRICTION is Restricted. Implode multiple ID’s with #~#.
.PARAMETER CUSTOMFIELDS
Custom fields. For a multi-pick-list custom field, implode multiple field values with #~#.

.LINK
https://developer.intacct.com/api/accounts-payable/vendors/#create-vendor

#>

function ConvertTo-VendorXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$VENDORID,

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
        [string]$VENDTYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PARENTID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$GLGROUP,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$DEFAULT_LEAD_TIME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TAXID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$NAME1099,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FORM1099TYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FORM1099BOX,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$SUPDOCID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$APACCOUNT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$OFFSETGLACCOUNTNO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$CREDITLIMIT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$RETAINAGEPERCENTAGE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$ONHOLD,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$DONOTCUTCHECK,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$COMMENTS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CURRENCY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$CONTACTINFO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$PAYTO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$RETURNTO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CONTACT_LIST_INFO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PAYMETHODKEY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$MERGEPAYMENTREQ=$true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$PAYMENTNOTIFY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BILLINGTYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PAYMENTPRIORITY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TERMNAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$DISPLAYTERMDISCOUNT=$true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$ACHENABLED,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ACHBANKROUTINGNUMBER,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ACHACCOUNTNUMBER,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ACHACCOUNTTYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ACHREMITTANCETYPE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$VENDORACCOUNTNO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$DISPLOCACCTNOCHECK,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$VENDOR_ACCTNO_LOC_HEAD,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Unrestricted','RootOnly','Restricted')]
        [string]$OBJECTRESTRICTION='Unrestricted',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$RESTRICTEDLOCATIONS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$RESTRICTEDDEPARTMENTS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$CUSTOMFIELDS
    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<VENDOR>")
    }
    Process
    {

        foreach($parameter in $PSBoundParameters.GetEnumerator())
        {
            switch ($parameter.Key) {
                # encode reserved Xml characters (& --> &amp;)
                {$_ -in 'NAME'} { 
                    $Text = "<{0}>{1}</{0}>" -f $parameter.Key, [System.Security.SecurityElement]::Escape($parameter.Value)
                    [void]$SB.Append( $Text )
                }
                # boolean fields need to be lower case
                {$_ -in 'ONETIME','HIDEDISPLAYCONTACT','ONHOLD','DONOTCUTCHECK','MERGEPAYMENTREQ','PAYMENTNOTIFY','DISPLAYTERMDISCOUNT','ACHENABLED','DISPLOCACCTNOCHECK'} { 
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
                # 
                {$_ -in 'DISPLAYCONTACT','CONTACTINFO','PAYTO','RETURNTO'} {
                    $dc = $parameter.Value | ConvertTo-ContactXml -ROOT_ELEMENT $_
                    [void]$SB.Append( $dc.OuterXml )
                }
                # otherwise
                Default { 
                    $Text = "<{0}>{1}</{0}>" -f $parameter.Key, $parameter.Value
                    [void]$SB.Append( $Text )
                }
            } # /switch
        } # /foreach

    }
    End
    {
        [void]$SB.Append("</VENDOR>")
        Write-Debug $SB.ToString()
        [xml]$SB.ToString()
    }

}