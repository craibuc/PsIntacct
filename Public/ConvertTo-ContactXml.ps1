<#
.SYNOPSIS
Convert Contact model to Xml.

.PARAMETER PRINTAS
Print as

.PARAMETER CONTACTNAME
If left blank, system will create the name as [NAME](C[CUSTOMERID])

.PARAMETER COMPANYNAME
Company name

.PARAMETER TAXABLE
Taxable. Use false for No, true for Yes. (Default: true)

.PARAMETER TAXGROUP
Contact tax group name

.PARAMETER PREFIX
Prefix

.PARAMETER FIRSTNAME
First name

.PARAMETER LASTNAME
Last name

.PARAMETER INITIAL
Middle name

.PARAMETER PHONE1
Primary phone number

.PARAMETER PHONE2
Secondary phone number

.PARAMETER CELLPHONE
Cellular phone number

.PARAMETER PAGER
Pager number

.PARAMETER FAX
Fax number

.PARAMETER EMAIL1
Primary email address

.PARAMETER EMAIL2
Secondary email address

.PARAMETER URL1
Primary URL

.PARAMETER URL2
Secondary URL

.PARAMETER MAILADDRESS
Mail address

#>
function ConvertTo-ContactXml {

    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$PRINTAS,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
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
        [pscustomobject]$MAILADDRESS
    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<DISPLAYCONTACT>")    
    }
    Process
    {
        # mandatory
        if ($PRINTAS) { [void]$SB.Append("<PRINTAS>$( [System.Security.SecurityElement]::Escape($PRINTAS) )</PRINTAS>") }
        if ($CONTACTNAME) { [void]$SB.Append("<CONTACTNAME>$( [System.Security.SecurityElement]::Escape($CONTACTNAME) )</CONTACTNAME>") }
        # /mandatory

        if ($COMPANYNAME) { [void]$SB.Append("<COMPANYNAME>$( [System.Security.SecurityElement]::Escape($COMPANYNAME) )</COMPANYNAME>") }
        [void]$SB.Append("<TAXABLE>$( $TAXABLE.ToString().ToLower() )</TAXABLE>")
        if ($TAXGROUP) { [void]$SB.Append("<TAXGROUP>$TAXGROUP</TAXGROUP>") }
        if ($PREFIX) { [void]$SB.Append("<PREFIX>$PREFIX</PREFIX>") }
        if ($FIRSTNAME) { [void]$SB.Append("<FIRSTNAME>$( [System.Security.SecurityElement]::Escape($FIRSTNAME) )</FIRSTNAME>") }
        if ($LASTNAME) { [void]$SB.Append("<LASTNAME>$( [System.Security.SecurityElement]::Escape($LASTNAME) )</LASTNAME>") }
        if ($INITIAL) { [void]$SB.Append("<INITIAL>$INITIAL</INITIAL>") }
        if ($PHONE1) { [void]$SB.Append("<PHONE1>$PHONE1</PHONE1>") }
        if ($PHONE2) { [void]$SB.Append("<PHONE2>$PHONE2</PHONE2>") }
        if ($CELLPHONE) { [void]$SB.Append("<CELLPHONE>$CELLPHONE</CELLPHONE>") }
        if ($PAGER) { [void]$SB.Append("<PAGER>$PAGER</PAGER>") }
        if ($FAX) { [void]$SB.Append("<FAX>$FAX</FAX>") }
        if ($EMAIL1) { [void]$SB.Append("<EMAIL1>$EMAIL1</EMAIL1>") }
        if ($EMAIL2) { [void]$SB.Append("<EMAIL2>$EMAIL2</EMAIL2>") }
        if ($URL1) { [void]$SB.Append("<URL1>$( [System.Security.SecurityElement]::Escape($URL1) )</URL1>") }
        if ($URL2) { [void]$SB.Append("<URL2>$( [System.Security.SecurityElement]::Escape($URL2) )</URL2>") }
        if ($MAILADDRESS)
        { 
            $ma = $MAILADDRESS | ConvertTo-MailingAddressXml
            [void]$SB.Append( $ma.OuterXml )
            # [void]$SB.Append($MAILADDRESS) 
        }
        else { [void]$SB.Append("<MAILADDRESS/>") }
    }
    End
    {
        [void]$SB.Append("</DISPLAYCONTACT>")
        $xml = $SB.ToString()
        # Write-Debug $xml
        [xml]$xml
    }

}
