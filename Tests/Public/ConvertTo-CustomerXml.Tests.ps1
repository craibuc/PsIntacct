# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
# $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-CustomerXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-CustomerXml.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-CustomerXml" -Tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command 'ConvertTo-CustomerXml'

        Context "CUSTOMERID" {
            $ParameterName = 'CUSTOMERID'

            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }
        Context "NAME" {
            $ParameterName = 'NAME'

            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }
        Context "DISPLAYCONTACT" {
            $ParameterName = 'DISPLAYCONTACT'

            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }
        Context "STATUS" {
            $ParameterName = 'STATUS'

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "has a default value of 'active'" {
                $Command | Should -HaveParameter $ParameterName -DefaultValue 'active'
            }
        }
        Context "ONETIME" {
            $ParameterName = 'ONETIME'

            It "is a [boolean]" {
                $Command | Should -HaveParameter $ParameterName -Type boolean
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }
        Context "HIDEDISPLAYCONTACT" {
            $ParameterName = 'HIDEDISPLAYCONTACT'

            It "is a [boolean]" {
                $Command | Should -HaveParameter $ParameterName -Type boolean
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }
        Context "OBJECTRESTRICTION" {
            $ParameterName = 'OBJECTRESTRICTION'

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "has a default value of 'Unrestricted'" {
                $Command | Should -HaveParameter $ParameterName -DefaultValue 'Unrestricted'
            }
        }
        Context "CUSTOMFIELDS" {
            $ParameterName = 'CUSTOMFIELDS'

            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        it "has optional parameters" {
            $Command | Should -HaveParameter CUSTTYPE -Type string
            $Command | Should -HaveParameter CUSTREPID -Type string
            $Command | Should -HaveParameter PARENTID -Type string
            $Command | Should -HaveParameter GLGROUP -Type string
            $Command | Should -HaveParameter TERRITORYID -Type string
            $Command | Should -HaveParameter SUPDOCID -Type string
            $Command | Should -HaveParameter TERMNAME -Type string
            $Command | Should -HaveParameter OFFSETGLACCOUNTNO -Type string
            $Command | Should -HaveParameter ARACCOUNT -Type string
            $Command | Should -HaveParameter SHIPPINGMETHOD -Type string
            $Command | Should -HaveParameter RESALENO -Type string
            $Command | Should -HaveParameter TAXID -Type string
            $Command | Should -HaveParameter CREDITLIMIT -Type decimal
            $Command | Should -HaveParameter ONHOLD -Type boolean
            $Command | Should -HaveParameter DELIVERY_OPTIONS -Type string
            $Command | Should -HaveParameter CUSTMESSAGEID -Type string
            $Command | Should -HaveParameter COMMENTS -Type string
            $Command | Should -HaveParameter CURRENCY -Type string
            $Command | Should -HaveParameter ADVBILLBY -Type int
            $Command | Should -HaveParameter ADVBILLBYTYPE -Type string
            $Command | Should -HaveParameter ARINVOICEPRINTTEMPLATEID -Type string
            $Command | Should -HaveParameter OEQUOTEPRINTTEMPLATEID -Type string
            $Command | Should -HaveParameter OEORDERPRINTTEMPLATEID -Type string
            $Command | Should -HaveParameter OELISTPRINTTEMPLATEID -Type string
            $Command | Should -HaveParameter OEINVOICEPRINTTEMPLATEID -Type string
            $Command | Should -HaveParameter OEADJPRINTTEMPLATEID -Type string
            $Command | Should -HaveParameter OEOTHERPRINTTEMPLATEID -Type string
            $Command | Should -HaveParameter CONTACTINFO -Type string
            $Command | Should -HaveParameter BILLTO -Type string
            $Command | Should -HaveParameter SHIPTO -Type string
            $Command | Should -HaveParameter CONTACT_LIST_INFO -Type string
            $Command | Should -HaveParameter RESTRICTEDLOCATIONS -Type string
            $Command | Should -HaveParameter RESTRICTEDDEPARTMENTS -Type string
        }
    }

    $Customer = [pscustomobject]@{
        CUSTOMERID='C1234'
        NAME='SaaS Company Inc'
    }

    Context "Required fields" {

        it "returns the expected values" {
            # act
            [xml]$Actual = $Customer | ConvertTo-CustomerXml

            # assert
            $Actual.CUSTOMER.CUSTOMERID | Should -Be $Customer.CUSTOMERID
            $Actual.CUSTOMER.NAME | Should -Be $Customer.NAME
        }

    }

    Context "Optional fields" {

        $Customer | Add-Member -MemberType NoteProperty -Name 'DISPLAYCONTACT' -Value $null
        $Customer | Add-Member -MemberType NoteProperty -Name 'STATUS' -Value 'inactive'
        $Customer | Add-Member -MemberType NoteProperty -Name 'ONETIME' -Value $true
        $Customer | Add-Member -MemberType NoteProperty -Name 'HIDEDISPLAYCONTACT' -Value $true
        $Customer | Add-Member -MemberType NoteProperty -Name 'CUSTTYPE' -Value 'custtype'
        $Customer | Add-Member -MemberType NoteProperty -Name 'CUSTREPID' -Value 'custrepid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'PARENTID' -Value 'parentid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'GLGROUP' -Value 'glgroup'
        $Customer | Add-Member -MemberType NoteProperty -Name 'TERRITORYID' -Value 'territoryid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'SUPDOCID' -Value 'supdocid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'TERMNAME' -Value 'termname'
        $Customer | Add-Member -MemberType NoteProperty -Name 'OFFSETGLACCOUNTNO' -Value 'offsetglaccountno'
        $Customer | Add-Member -MemberType NoteProperty -Name 'ARACCOUNT' -Value 'araccount'
        $Customer | Add-Member -MemberType NoteProperty -Name 'SHIPPINGMETHOD' -Value 'shippingmethod'
        $Customer | Add-Member -MemberType NoteProperty -Name 'RESALENO' -Value 'resaleno'
        $Customer | Add-Member -MemberType NoteProperty -Name 'TAXID' -Value 'taxid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'CREDITLIMIT' -Value 100.00
        $Customer | Add-Member -MemberType NoteProperty -Name 'ONHOLD' -Value $true
        $Customer | Add-Member -MemberType NoteProperty -Name 'DELIVERY_OPTIONS' -Value 'delivery_options'
        $Customer | Add-Member -MemberType NoteProperty -Name 'CUSTMESSAGEID' -Value 'custmessageid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'COMMENTS' -Value 'comments'
        $Customer | Add-Member -MemberType NoteProperty -Name 'CURRENCY' -Value 'currency'
        $Customer | Add-Member -MemberType NoteProperty -Name 'ADVBILLBY' -Value 9
        $Customer | Add-Member -MemberType NoteProperty -Name 'ADVBILLBYTYPE' -Value 'advbillbytype'
        $Customer | Add-Member -MemberType NoteProperty -Name 'ARINVOICEPRINTTEMPLATEID' -Value 'arinvoiceprinttemplateid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'OEQUOTEPRINTTEMPLATEID' -Value 'oequoteprinttemplateid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'OEORDERPRINTTEMPLATEID' -Value 'oeorderprinttemplateid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'OELISTPRINTTEMPLATEID' -Value 'oelistprinttemplateid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'OEINVOICEPRINTTEMPLATEID' -Value 'oeinvoiceprinttemplateid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'OEADJPRINTTEMPLATEID' -Value 'oeadjprinttemplateid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'OEOTHERPRINTTEMPLATEID' -Value 'oeotherprinttemplateid'
        $Customer | Add-Member -MemberType NoteProperty -Name 'CONTACTINFO' -Value 'contactinfo'
        $Customer | Add-Member -MemberType NoteProperty -Name 'BILLTO' -Value 'billto'
        $Customer | Add-Member -MemberType NoteProperty -Name 'SHIPTO' -Value 'shipto'
        $Customer | Add-Member -MemberType NoteProperty -Name 'CONTACT_LIST_INFO' -Value 'contact_list_info'
        # $Customer | Add-Member -MemberType NoteProperty -Name 'OBJECTRESTRICTION' -Value 'Restricted'
        $Customer | Add-Member -MemberType NoteProperty -Name 'RESTRICTEDLOCATIONS' -Value 'restrictedlocations'
        $Customer | Add-Member -MemberType NoteProperty -Name 'RESTRICTEDDEPARTMENTS' -Value 'restricteddepartments'
        $CUSTOMFIELDS = [pscustomobject]@{CUSTOM_NAME='CUSTOM_VALUE'}
        $Customer | Add-Member -MemberType NoteProperty -Name 'CUSTOMFIELDS' -Value $CUSTOMFIELDS

        it "returns the expected values" {
            # act
            [xml]$Actual = $Customer | ConvertTo-CustomerXml

            # assert
            # $Actual.CUSTOMER.DISPLAYCONTACT | Should -Be $Customer.DISPLAYCONTACT
            $Actual.CUSTOMER.STATUS | Should -Be $Customer.STATUS
            $Actual.CUSTOMER.ONETIME | Should -Be $Customer.ONETIME
            $Actual.CUSTOMER.HIDEDISPLAYCONTACT | Should -Be $Customer.HIDEDISPLAYCONTACT
            $Actual.CUSTOMER.CUSTTYPE | Should -Be $Customer.CUSTTYPE
            $Actual.CUSTOMER.CUSTREPID | Should -Be $Customer.CUSTREPID
            $Actual.CUSTOMER.PARENTID | Should -Be $Customer.PARENTID
            $Actual.CUSTOMER.GLGROUP | Should -Be $Customer.GLGROUP
            $Actual.CUSTOMER.TERRITORYID | Should -Be $Customer.TERRITORYID
            $Actual.CUSTOMER.SUPDOCID | Should -Be $Customer.SUPDOCID
            $Actual.CUSTOMER.TERMNAME | Should -Be $Customer.TERMNAME
            $Actual.CUSTOMER.OFFSETGLACCOUNTNO | Should -Be $Customer.OFFSETGLACCOUNTNO
            $Actual.CUSTOMER.ARACCOUNT | Should -Be $Customer.ARACCOUNT
            $Actual.CUSTOMER.SHIPPINGMETHOD | Should -Be $Customer.SHIPPINGMETHOD
            $Actual.CUSTOMER.RESALENO | Should -Be $Customer.RESALENO
            $Actual.CUSTOMER.TAXID | Should -Be $Customer.TAXID
            $Actual.CUSTOMER.CREDITLIMIT | Should -Be $Customer.CREDITLIMIT
            $Actual.CUSTOMER.ONHOLD | Should -Be $Customer.ONHOLD
            $Actual.CUSTOMER.DELIVERY_OPTIONS | Should -Be $Customer.DELIVERY_OPTIONS
            $Actual.CUSTOMER.CUSTMESSAGEID | Should -Be $Customer.CUSTMESSAGEID
            $Actual.CUSTOMER.COMMENTS | Should -Be $Customer.COMMENTS
            $Actual.CUSTOMER.CURRENCY | Should -Be $Customer.CURRENCY
            $Actual.CUSTOMER.ADVBILLBY | Should -Be $Customer.ADVBILLBY
            $Actual.CUSTOMER.ADVBILLBYTYPE | Should -Be $Customer.ADVBILLBYTYPE
            $Actual.CUSTOMER.ARINVOICEPRINTTEMPLATEID | Should -Be $Customer.ARINVOICEPRINTTEMPLATEID
            $Actual.CUSTOMER.OEQUOTEPRINTTEMPLATEID | Should -Be $Customer.OEQUOTEPRINTTEMPLATEID
            $Actual.CUSTOMER.OEORDERPRINTTEMPLATEID | Should -Be $Customer.OEORDERPRINTTEMPLATEID
            $Actual.CUSTOMER.OELISTPRINTTEMPLATEID | Should -Be $Customer.OELISTPRINTTEMPLATEID
            $Actual.CUSTOMER.OEINVOICEPRINTTEMPLATEID | Should -Be $Customer.OEINVOICEPRINTTEMPLATEID
            $Actual.CUSTOMER.OEADJPRINTTEMPLATEID | Should -Be $Customer.OEADJPRINTTEMPLATEID
            $Actual.CUSTOMER.OEOTHERPRINTTEMPLATEID | Should -Be $Customer.OEOTHERPRINTTEMPLATEID
            $Actual.CUSTOMER.CONTACTINFO | Should -Be $Customer.CONTACTINFO
            $Actual.CUSTOMER.BILLTO | Should -Be $Customer.BILLTO
            $Actual.CUSTOMER.SHIPTO | Should -Be $Customer.SHIPTO
            # $Actual.CUSTOMER.CONTACT_LIST_INFO | Should -Be $Customer.CONTACT_LIST_INFO
            $Actual.CUSTOMER.OBJECTRESTRICTION | Should -Be $Customer.OBJECTRESTRICTION
            $Actual.CUSTOMER.RESTRICTEDLOCATIONS | Should -Be $Customer.RESTRICTEDLOCATIONS
            $Actual.CUSTOMER.RESTRICTEDDEPARTMENTS | Should -Be $Customer.RESTRICTEDDEPARTMENTS
            $Actual.CUSTOMER.CUSTOM_NAME | Should -Be $Customer.CUSTOMFIELDS.CUSTOM_NAME
        }

    }

    Context "Xml escaping" {

        it "creates an Xml document w/o throwing an exception" {

            # arrange
            $Customer.NAME="Bobby & Steve's"
            $Customer.CUSTTYPE="Foo & Bar"

            # act/assert
            {$Customer | ConvertTo-CustomerXml -ErrorAction Stop} | Should -Not -Throw
        }

    }

}
