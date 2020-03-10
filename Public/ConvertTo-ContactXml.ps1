<#
PRINTAS	Required	string	Print as
CONTACTNAME	Optional	string	If left blank, system will create the name as [NAME](C[CUSTOMERID])
COMPANYNAME	Optional	string	Company name
TAXABLE	Optional	boolean	Taxable. Use false for No, true for Yes. (Default: true)
TAXGROUP	Optional	string	Contact tax group name
PREFIX	Optional	string	Prefix
FIRSTNAME	Optional	string	First name
LASTNAME	Optional	string	Last name
INITIAL	Optional	string	Middle name
PHONE1	Optional	string	Primary phone number
PHONE2	Optional	string	Secondary phone number
CELLPHONE	Optional	string	Cellular phone number
PAGER	Optional	string	Pager number
FAX	Optional	string	Fax number
EMAIL1	Optional	string	Primary email address
EMAIL2	Optional	string	Secondary email address
URL1	Optional	string	Primary URL
URL2	Optional	string	Secondary URL
MAILADDRESS	Optional	object	Mail address
#>
function ConvertTo-ContactXml {

    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$PRINTAS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CONTACTNAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$COMPANYNAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$TAXABLE=$true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TAXGROUP,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PREFIX,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FIRSTNAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LASTNAME,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$INITIAL,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PHONE1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PHONE2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CELLPHONE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PAGER,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FAX,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$EMAIL1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$EMAIL2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$URL1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$URL2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$MAILADDRESS

    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<DISPLAYCONTACT>")    
    }
    Process
    {
        if ($PRINTAS) { [void]$SB.Append("<PRINTAS>$PRINTAS</PRINTAS>") }
        if ($CONTACTNAME) { [void]$SB.Append("<CONTACTNAME>$CONTACTNAME</CONTACTNAME>") }
        if ($COMPANYNAME) { [void]$SB.Append("<COMPANYNAME>$COMPANYNAME</COMPANYNAME>") }
        [void]$SB.Append("<TAXABLE>$( $TAXABLE.ToString().ToLower() )</TAXABLE>")
        if ($TAXGROUP) { [void]$SB.Append("<TAXGROUP>$TAXGROUP</TAXGROUP>") }
        if ($PREFIX) { [void]$SB.Append("<PREFIX>$PREFIX</PREFIX>") }
        if ($FIRSTNAME) { [void]$SB.Append("<FIRSTNAME>$FIRSTNAME</FIRSTNAME>") }
        if ($LASTNAME) { [void]$SB.Append("<LASTNAME>$LASTNAME</LASTNAME>") }
        if ($INITIAL) { [void]$SB.Append("<INITIAL>$INITIAL</INITIAL>") }
        if ($PHONE1) { [void]$SB.Append("<PHONE1>$PHONE1</PHONE1>") }
        if ($PHONE2) { [void]$SB.Append("<PHONE2>$PHONE2</PHONE2>") }
        if ($CELLPHONE) { [void]$SB.Append("<CELLPHONE>$CELLPHONE</CELLPHONE>") }
        if ($PAGER) { [void]$SB.Append("<PAGER>$PAGER</PAGER>") }
        if ($FAX) { [void]$SB.Append("<FAX>$FAX</FAX>") }
        if ($EMAIL1) { [void]$SB.Append("<EMAIL1>$EMAIL1</EMAIL1>") }
        if ($EMAIL2) { [void]$SB.Append("<EMAIL2>$EMAIL2</EMAIL2>") }
        if ($URL1) { [void]$SB.Append("<URL1>$URL1</URL1>") }
        if ($URL2) { [void]$SB.Append("<URL2>$URL2</URL2>") }
        if ($MAILADDRESS) { [void]$SB.Append($MAILADDRESS) } 
        else { [void]$SB.Append("<MAILADDRESS/>") }
    }
    End
    {
        [void]$SB.Append("</DISPLAYCONTACT>")
        $SB.ToString()    
    }

}
