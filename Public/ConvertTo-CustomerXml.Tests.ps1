$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-CustomerXml" -Tag 'unit' {

    $Customer = [pscustomobject]@{
        CUSTOMERID='C1234'
        NAME='SaaS Company Inc'
    }

    Context "Required fields" {

        it "has 2, mandatory parameters" {
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CUSTOMERID -Type string -Mandatory
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter NAME -Type string -Mandatory
        }

        it "returns the expected values" {
            # act
            [xml]$Actual = $Customer | ConvertTo-CustomerXml

            # assert
            $Actual.CUSTOMER.CUSTOMERID | Should -Be $Customer.CUSTOMERID
            $Actual.CUSTOMER.NAME | Should -Be $Customer.NAME
        }

    }

    Context "Optional fields" {

        it "has 37, optional parameters" {
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter DISPLAYCONTACT -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter STATUS -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter ONETIME -Type boolean
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter HIDEDISPLAYCONTACT -Type boolean
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CUSTTYPE -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CUSTREPID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter PARENTID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter GLGROUP -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter TERRITORYID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter SUPDOCID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter TERMNAME -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OFFSETGLACCOUNTNO -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter ARACCOUNT -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter SHIPPINGMETHOD -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter RESALENO -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter TAXID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CREDITLIMIT -Type decimal
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter ONHOLD -Type boolean
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter DELIVERY_OPTIONS -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CUSTMESSAGEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter COMMENTS -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CURRENCY -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter ADVBILLBY -Type int
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter ADVBILLBYTYPE -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter ARINVOICEPRINTTEMPLATEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OEQUOTEPRINTTEMPLATEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OEORDERPRINTTEMPLATEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OELISTPRINTTEMPLATEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OEINVOICEPRINTTEMPLATEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OEADJPRINTTEMPLATEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OEOTHERPRINTTEMPLATEID -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CONTACTINFO -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter BILLTO -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter SHIPTO -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter CONTACT_LIST_INFO -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter OBJECTRESTRICTION -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter RESTRICTEDLOCATIONS -Type string
            Get-Command "ConvertTo-CustomerXml" | Should -HaveParameter RESTRICTEDDEPARTMENTS -Type string
        }

        $Customer | Add-Member -MemberType NoteProperty -Name 'DISPLAYCONTACT' -Value '<DISPLAYCONTACT/>'
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
        $Customer | Add-Member -MemberType NoteProperty -Name 'OBJECTRESTRICTION' -Value 'Restricted'
        $Customer | Add-Member -MemberType NoteProperty -Name 'RESTRICTEDLOCATIONS' -Value 'restrictedlocations'
        $Customer | Add-Member -MemberType NoteProperty -Name 'RESTRICTEDDEPARTMENTS' -Value 'restricteddepartments'

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
        }

    }

}
