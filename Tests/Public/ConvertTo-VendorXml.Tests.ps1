# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
# $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-VendorXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# dependencies
. (Join-Path $PublicPath "ConvertTo-ContactXml.ps1")

# . /PsIntacct/PsIntacct/Public/ConvertTo-VendorXml.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-VendorXml" -Tag 'unit' {

    $Parameters = @(
        @{ParameterName='VENDORID';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='NAME';Type=[string];IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='DISPLAYCONTACT';Type=[pscustomobject];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='STATUS';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='ONETIME';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='HIDEDISPLAYCONTACT';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='VENDTYPE';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='PARENTID';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='GLGROUP';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='DEFAULT_LEAD_TIME';Type=[int];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='TAXID';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='NAME1099';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='FORM1099TYPE';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='FORM1099BOX';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='SUPDOCID';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='APACCOUNT';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='OFFSETGLACCOUNTNO';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='CREDITLIMIT';Type=[decimal];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='RETAINAGEPERCENTAGE';Type=[decimal];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='ONHOLD';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='DONOTCUTCHECK';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='COMMENTS';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='CURRENCY';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='CONTACTINFO';Type=[pscustomobject];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='PAYTO';Type=[pscustomobject];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='RETURNTO';Type=[pscustomobject];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='CONTACT_LIST_INFO';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='PAYMETHODKEY';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='MERGEPAYMENTREQ';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='PAYMENTNOTIFY';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='BILLINGTYPE';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='PAYMENTPRIORITY';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='TERMNAME';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='DISPLAYTERMDISCOUNT';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='ACHENABLED';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='ACHBANKROUTINGNUMBER';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='ACHACCOUNTNUMBER';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='ACHACCOUNTTYPE';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='ACHREMITTANCETYPE';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='VENDORACCOUNTNO';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='DISPLOCACCTNOCHECK';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='VENDOR_ACCTNO_LOC_HEAD';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='OBJECTRESTRICTION';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='RESTRICTEDLOCATIONS';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='RESTRICTEDDEPARTMENTS';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        @{ParameterName='CUSTOMFIELDS';Type=[pscustomobject];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
    )

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'ConvertTo-VendorXml'
        }

        it '<ParameterName> is a <Type>' -TestCases $Parameters {
            param($ParameterName, $Type)
          
            $Command | Should -HaveParameter $ParameterName -Type $type
        }

        it '<ParameterName> mandatory is <Mandatory>' -TestCases $Parameters {
            param($ParameterName, $IsMandatory)
          
            if ($IsMandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
            else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
        }

        it '<ParameterName> accepts value from the pipeline is <ValueFromPipelineByPropertyName>' -TestCases $Parameters {
            param($ParameterName, $ValueFromPipelineByPropertyName)
          
            $Command.parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $ValueFromPipelineByPropertyName
        }

    }

    Context "Usage" {

        BeforeEach {
            $Contact = [pscustomobject]@{PRINTAS='Last, First';CONTACTNAME='First Last'}
            $Expected = @{
                VENDORID='100'
                NAME='NAME'
                DISPLAYCONTACT=$Contact
                STATUS='inactive'
                ONETIME=$true
                HIDEDISPLAYCONTACT=$true
                VENDTYPE='VENDTYPE'
                PARENTID='200'
                GLGROUP='GLGROUP'
                DEFAULT_LEAD_TIME=1
                TAXID='00-0000000'
                NAME1099='NAME1099'
                FORM1099TYPE='FORM1099TYPE'
                FORM1099BOX='FORM1099BOX'
                SUPDOCID='SUPDOCID'
                APACCOUNT='APACCOUNT'
                OFFSETGLACCOUNTNO='OFFSETGLACCOUNTNO'
                CREDITLIMIT=100.00
                RETAINAGEPERCENTAGE=100.00
                ONHOLD=$true
                DONOTCUTCHECK=$true
                COMMENTS='COMMENTS'
                CURRENCY='USD'
                CONTACTINFO=$Contact
                PAYTO=$Contact
                RETURNTO=$Contact
                CONTACT_LIST_INFO='CONTACT_LIST_INFO'
                PAYMETHODKEY='PAYMETHODKEY'
                MERGEPAYMENTREQ=$true
                PAYMENTNOTIFY=$true
                BILLINGTYPE='BILLINGTYPE'
                PAYMENTPRIORITY='PAYMENTPRIORITY'
                TERMNAME='Net 30'
                DISPLAYTERMDISCOUNT=$true
                ACHENABLED=$true
                ACHBANKROUTINGNUMBER='ACHBANKROUTINGNUMBER'
                ACHACCOUNTNUMBER='ACHACCOUNTNUMBER'
                ACHACCOUNTTYPE='ACHACCOUNTTYPE'
                ACHREMITTANCETYPE='ACHREMITTANCETYPE'
                VENDORACCOUNTNO='VENDORACCOUNTNO'
                DISPLOCACCTNOCHECK=$true
                VENDOR_ACCTNO_LOC_HEAD='VENDOR_ACCTNO_LOC_HEAD'
                OBJECTRESTRICTION='Unrestricted'
                RESTRICTEDLOCATIONS='RESTRICTEDLOCATIONS'
                RESTRICTEDDEPARTMENTS='RESTRICTEDDEPARTMENTS'
                CUSTOMFIELDS=[pscustomobject]@{Foo='Baz';Bar=100}
            }
        }

        It "returns the expected values" {

            # act
            $Actual = ConvertTo-VendorXml @Expected

            # assert
            $Actual.VENDOR.VENDORID | Should -Be $Expected.VENDORID
            $Actual.VENDOR.NAME | Should -Be $Expected.NAME
            $Actual.VENDOR.DISPLAYCONTACT.PRINTAS | Should -Be $Contact.PRINTAS
            $Actual.VENDOR.DISPLAYCONTACT.CONTACTNAME | Should -Be $Contact.CONTACTNAME
            $Actual.VENDOR.STATUS | Should -Be $Expected.STATUS
            $Actual.VENDOR.ONETIME | Should -Be $Expected.ONETIME
            $Actual.VENDOR.HIDEDISPLAYCONTACT | Should -Be $Expected.HIDEDISPLAYCONTACT
            $Actual.VENDOR.VENDTYPE | Should -Be $Expected.VENDTYPE
            $Actual.VENDOR.PARENTID | Should -Be $Expected.PARENTID
            $Actual.VENDOR.GLGROUP | Should -Be $Expected.GLGROUP
            $Actual.VENDOR.DEFAULT_LEAD_TIME | Should -Be $Expected.DEFAULT_LEAD_TIME
            $Actual.VENDOR.TAXID | Should -Be $Expected.TAXID
            $Actual.VENDOR.NAME1099 | Should -Be $Expected.NAME1099
            $Actual.VENDOR.FORM1099TYPE | Should -Be $Expected.FORM1099TYPE
            $Actual.VENDOR.FORM1099BOX | Should -Be $Expected.FORM1099BOX
            $Actual.VENDOR.SUPDOCID | Should -Be $Expected.SUPDOCID
            $Actual.VENDOR.APACCOUNT | Should -Be $Expected.APACCOUNT
            $Actual.VENDOR.OFFSETGLACCOUNTNO | Should -Be $Expected.OFFSETGLACCOUNTNO
            $Actual.VENDOR.CREDITLIMIT | Should -Be $Expected.CREDITLIMIT
            $Actual.VENDOR.RETAINAGEPERCENTAGE | Should -Be $Expected.RETAINAGEPERCENTAGE
            $Actual.VENDOR.ONHOLD | Should -Be $Expected.ONHOLD
            $Actual.VENDOR.DONOTCUTCHECK | Should -Be $Expected.DONOTCUTCHECK
            $Actual.VENDOR.COMMENTS | Should -Be $Expected.COMMENTS
            $Actual.VENDOR.CURRENCY | Should -Be $Expected.CURRENCY
            $Actual.VENDOR.CONTACTINFO.PRINTAS | Should -Be $Contact.PRINTAS
            $Actual.VENDOR.CONTACTINFO.CONTACTNAME | Should -Be $Contact.CONTACTNAME
            $Actual.VENDOR.PAYTO.PRINTAS | Should -Be $Contact.PRINTAS
            $Actual.VENDOR.PAYTO.CONTACTNAME | Should -Be $Contact.CONTACTNAME
            $Actual.VENDOR.RETURNTO.PRINTAS | Should -Be $Contact.PRINTAS
            $Actual.VENDOR.RETURNTO.CONTACTNAME | Should -Be $Contact.CONTACTNAME
            $Actual.VENDOR.CONTACT_LIST_INFO | Should -Be $Expected.CONTACT_LIST_INFO
            $Actual.VENDOR.PAYMETHODKEY | Should -Be $Expected.PAYMETHODKEY
            $Actual.VENDOR.MERGEPAYMENTREQ | Should -Be $Expected.MERGEPAYMENTREQ
            $Actual.VENDOR.PAYMENTNOTIFY | Should -Be $Expected.PAYMENTNOTIFY
            $Actual.VENDOR.BILLINGTYPE | Should -Be $Expected.BILLINGTYPE
            $Actual.VENDOR.PAYMENTPRIORITY | Should -Be $Expected.PAYMENTPRIORITY
            $Actual.VENDOR.TERMNAME | Should -Be $Expected.TERMNAME
            $Actual.VENDOR.DISPLAYTERMDISCOUNT | Should -Be $Expected.DISPLAYTERMDISCOUNT
            $Actual.VENDOR.ACHENABLED | Should -Be $Expected.ACHENABLED
            $Actual.VENDOR.ACHBANKROUTINGNUMBER | Should -Be $Expected.ACHBANKROUTINGNUMBER
            $Actual.VENDOR.ACHACCOUNTNUMBER | Should -Be $Expected.ACHACCOUNTNUMBER
            $Actual.VENDOR.ACHACCOUNTTYPE | Should -Be $Expected.ACHACCOUNTTYPE
            $Actual.VENDOR.ACHREMITTANCETYPE | Should -Be $Expected.ACHREMITTANCETYPE
            $Actual.VENDOR.VENDORACCOUNTNO | Should -Be $Expected.VENDORACCOUNTNO
            $Actual.VENDOR.DISPLOCACCTNOCHECK | Should -Be $Expected.DISPLOCACCTNOCHECK
            $Actual.VENDOR.VENDOR_ACCTNO_LOC_HEAD | Should -Be $Expected.VENDOR_ACCTNO_LOC_HEAD
            $Actual.VENDOR.OBJECTRESTRICTION | Should -Be $Expected.OBJECTRESTRICTION
            $Actual.VENDOR.RESTRICTEDLOCATIONS | Should -Be $Expected.RESTRICTEDLOCATIONS
            $Actual.VENDOR.RESTRICTEDDEPARTMENTS | Should -Be $Expected.RESTRICTEDDEPARTMENTS
            foreach ($property in $Expected.CUSTOMFIELDS.PSObject.Properties) {
                Write-Debug "$($property.Name): $($property.Value)"
                $Actual.VENDOR[$property.Name].'#text' | Should -Be $property.Value
            }
            
        }

    }

    Context "Xml escaping" {

        BeforeAll {
            $Expected = @{
                NAME="Bobby & Steve's"
            }
        }
    
        it "escapes the NAME property" {
            # act/assert
            { ConvertTo-VendorXml @Expected -ErrorAction Stop } | Should -Not -Throw
        }

    }

}