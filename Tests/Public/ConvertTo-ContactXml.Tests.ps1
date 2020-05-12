# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
# $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ContactXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-ContactXml.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-ContactXml" -Tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command "ConvertTo-ContactXml"

        Context 'PRINTAS' {
            $ParameterName = 'PRINTAS'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'CONTACTNAME' {
            $ParameterName = 'CONTACTNAME'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'COMPANYNAME' {
            $ParameterName = 'COMPANYNAME'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'TAXABLE' {
            $ParameterName = 'TAXABLE'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type boolean
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'TAXGROUP' {
            $ParameterName = 'TAXGROUP'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'PREFIX' {
            $ParameterName = 'PREFIX'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'FIRSTNAME' {
            $ParameterName = 'FIRSTNAME'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'LASTNAME' {
            $ParameterName = 'LASTNAME'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'INITIAL' {
            $ParameterName = 'INITIAL'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'PHONE1' {
            $ParameterName = 'PHONE1'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'PHONE2' {
            $ParameterName = 'PHONE2'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'CELLPHONE' {
            $ParameterName = 'CELLPHONE'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'PAGER' {
            $ParameterName = 'PAGER'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'FAX' {
            $ParameterName = 'FAX'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'EMAIL1' {
            $ParameterName = 'EMAIL1'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'EMAIL2' {
            $ParameterName = 'EMAIL2'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'URL1' {
            $ParameterName = 'URL1'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'URL2' {
            $ParameterName = 'URL2'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'MAILADDRESS' {
            $ParameterName = 'MAILADDRESS'
            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

    }

    $Contact = [pscustomobject]@{
        PRINTAS='Last, First'
        CONTACTNAME='First Last'
    }

    Context "Required fields" {
    
        it "returns the expected values" {
            # act
            $Actual = $Contact | ConvertTo-ContactXml
            
            # assert
            $Actual.DISPLAYCONTACT.PRINTAS | Should -Be $Contact.PRINTAS
            $Actual.DISPLAYCONTACT.CONTACTNAME | Should -Be $Contact.CONTACTNAME
        }

    }

    Context "Optional fields" {

        # arrange
        $Contact | Add-Member -MemberType NoteProperty -Name 'TAXABLE' -Value $false
        $Contact | Add-Member -MemberType NoteProperty -Name 'TAXGROUP' -Value 'tax group'
        $Contact | Add-Member -MemberType NoteProperty -Name 'PREFIX' -Value 'Mr.'
        $Contact | Add-Member -MemberType NoteProperty -Name 'FIRSTNAME' -Value 'John'
        $Contact | Add-Member -MemberType NoteProperty -Name 'LASTNAME' -Value 'Public'
        $Contact | Add-Member -MemberType NoteProperty -Name 'INITIAL' -Value 'Q.'
        $Contact | Add-Member -MemberType NoteProperty -Name 'PHONE1' -Value '111-111-1111'
        $Contact | Add-Member -MemberType NoteProperty -Name 'PHONE2' -Value '222-222-2222'
        $Contact | Add-Member -MemberType NoteProperty -Name 'CELLPHONE' -Value '333-333-3333'
        $Contact | Add-Member -MemberType NoteProperty -Name 'PAGER' -Value '444-444-4444'
        $Contact | Add-Member -MemberType NoteProperty -Name 'FAX' -Value '555-555-5555'
        $Contact | Add-Member -MemberType NoteProperty -Name 'EMAIL1' -Value 'john.q.public@domain.tld'
        $Contact | Add-Member -MemberType NoteProperty -Name 'EMAIL2' -Value 'first.last@domain.tld'
        $Contact | Add-Member -MemberType NoteProperty -Name 'URL1' -Value 'https://a.domain.tld'
        $Contact | Add-Member -MemberType NoteProperty -Name 'URL2' -Value 'https://b.domain.tld'
        # $Contact | Add-Member -MemberType NoteProperty -Name 'MAILADDRESS' -Value 'yyy'

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
            # $Actual.DISPLAYCONTACT.MAILADDRESS | Should -Be $Contact.MAILADDRESS
        }

    }

    Context "Xml escaping" {

        it "creates an Xml document w/o throwing an exception" {

            # arrange
            $Contact.PRINTAS="Steve's, Bobby &"
            $Contact.CONTACTNAME="Bobby & Steve's"
            $Contact.PREFIX="Mr. & Mrs."
            $Contact.FIRSTNAME="Bobby's"
            $Contact.LASTNAME="Steve's"
            $Contact.EMAIL1 = "First Last <first.last@domain.tld>"
            $Contact.EMAIL2 = "First Last <first.last@domain.tld>"
            $Contact.URL1 = "http://www.domain.tld?foo=1&bar=2"
            $Contact.URL2 = "http://www.domain.tld?foo=1&bar=2"

            # act/assert
            { $Contact | ConvertTo-ContactXml -ErrorAction Stop } | Should -Not -Throw

        }

    }

}
