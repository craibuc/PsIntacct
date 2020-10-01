# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ContactXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# dependencies
. (Join-Path $PrivatePath "ConvertTo-MailingAddressXml.ps1")

# . /PsIntacct/PsIntacct/Public/ConvertTo-ContactXml.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-ContactXml" -Tag 'unit' {

    Context "Parameter validation" {

        $Parameters = @(
            @{ParameterName='ROOT_ELEMENT';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$false;DefaultValue='DISPLAYCONTACT';ValidValues=@('DISPLAYCONTACT','CONTACT','CONTACTINFO','PAYTO','RETURNTO')}
            @{ParameterName='PRINTAS';Type=[string];IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='CONTACTNAME';Type=[string];IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='COMPANYNAME';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='TAXABLE';Type=[bool];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='TAXGROUP';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='PREFIX';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='FIRSTNAME';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='LASTNAME';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='INITIAL';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='PHONE1';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='PHONE2';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='CELLPHONE';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='PAGER';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='FAX';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='EMAIL1';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='EMAIL2';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='URL1';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='URL2';Type=[string];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            @{ParameterName='MAILADDRESS';Type=[pscustomobject];IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
        )

        BeforeAll {
            $Command = Get-Command 'ConvertTo-ContactXml'
        }

        it '<ParameterName> is a <Type>' -TestCases $Parameters {
            param($ParameterName, $Type)
          
            $Command | Should -HaveParameter $ParameterName -Type $type
        }

        it '<ParameterName> mandatory is <IsMandatory>' -TestCases $Parameters {
            param($ParameterName, $IsMandatory)
          
            if ($IsMandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
            else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
        }

        it '<ParameterName> accepts value from the pipeline is <ValueFromPipelineByPropertyName>' -TestCases $Parameters {
            param($ParameterName, $ValueFromPipelineByPropertyName)
          
            $Command.parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $ValueFromPipelineByPropertyName
        }

        it '<ParameterName> has a valid values of <ValidValues>' -TestCases $Parameters {
            param($ParameterName, $ValidValues)
          
            if ($ValidValues)
            {
                $ret = (Compare-Object $Command.parameters[$ParameterName].Attributes.ValidValues $ValidValues).InputObject
                $ret | Should -Be $null
            }
        }

    }

    Context "Required fields" {

        BeforeAll {
            $Contact = [pscustomobject]@{
                PRINTAS='Last, First'
                CONTACTNAME='First Last'
            }        
        }

        it "returns the expected values" {
            # act
            $Actual = $Contact | ConvertTo-ContactXml
            
            # assert
            $Actual.DISPLAYCONTACT.PRINTAS | Should -Be $Contact.PRINTAS
            $Actual.DISPLAYCONTACT.CONTACTNAME | Should -Be $Contact.CONTACTNAME
        }

    }

    Context "Optional fields" {

        BeforeAll {
            $Contact = [pscustomobject]@{
                PRINTAS='Last, First'
                CONTACTNAME='First Last'
                TAXABLE=$true
                TAXGROUP='tax group'
                PREFIX='Mr.'
                FIRSTNAME='John'
                LASTNAME='Public'
                INITIAL='Q.'
                PHONE1='111-111-1111'
                PHONE2='222-222-2222'
                CELLPHONE='333-333-3333'
                PAGER='444-444-4444'
                FAX='555-555-5555'
                EMAIL1='john.q.public@domain.tld'
                EMAIL2='first.last@domain.tld'
                URL1='https://a.domain.tld'
                URL2='https://b.domain.tld'
                MAILADDRESS=[pscustomobject]@{ADDRESS1='ADDRESS1'}
            }        
        }

        it "returns the expected values" {
            # act
            $Actual = $Contact | ConvertTo-ContactXml
            
            # assert
            $Actual.DISPLAYCONTACT.TAXABLE | Should -Be $Contact.TAXABLE.ToString().ToLower()
            $Actual.DISPLAYCONTACT.TAXGROUP | Should -Be $Contact.TAXGROUP
            $Actual.DISPLAYCONTACT.PREFIX | Should -Be $Contact.PREFIX
            $Actual.DISPLAYCONTACT.FIRSTNAME | Should -Be $Contact.FIRSTNAME
            $Actual.DISPLAYCONTACT.LASTNAME | Should -Be $Contact.LASTNAME
            $Actual.DISPLAYCONTACT.INITIAL | Should -Be $Contact.INITIAL
            $Actual.DISPLAYCONTACT.PHONE1 | Should -Be $Contact.PHONE1
            $Actual.DISPLAYCONTACT.PHONE2 | Should -Be $Contact.PHONE2
            $Actual.DISPLAYCONTACT.CELLPHONE | Should -Be $Contact.CELLPHONE
            $Actual.DISPLAYCONTACT.PAGER | Should -Be $Contact.PAGER
            $Actual.DISPLAYCONTACT.FAX | Should -Be $Contact.FAX
            $Actual.DISPLAYCONTACT.EMAIL1 | Should -Be $Contact.EMAIL1
            $Actual.DISPLAYCONTACT.EMAIL2 | Should -Be $Contact.EMAIL2
            $Actual.DISPLAYCONTACT.URL1 | Should -Be $Contact.URL1
            $Actual.DISPLAYCONTACT.URL2 | Should -Be $Contact.URL2
            $Actual.DISPLAYCONTACT.MAILADDRESS.ADDRESS1 | Should -Be $Contact.MAILADDRESS.ADDRESS1
        }

    }

    Context "Xml escaping" {

        BeforeAll {
            $Contact = [pscustomobject]@{
                PRINTAS="Steve's, Bobby &"
                CONTACTNAME="Bobby & Steve's"
                PREFIX="Mr. & Mrs."
                FIRSTNAME="Bobby's"
                LASTNAME="Steve's"
                EMAIL1 = "First Last <first.last@domain.tld>"
                EMAIL2 = "First Last <first.last@domain.tld>"
                URL1 = "http://www.domain.tld?foo=1&bar=2"
                URL2 = "http://www.domain.tld?foo=1&bar=2"
            }
        }

        it "creates an Xml document w/o throwing an exception" {
            # act/assert
            { $Contact | ConvertTo-ContactXml -ErrorAction Stop } | Should -Not -Throw

        }

    }

}
