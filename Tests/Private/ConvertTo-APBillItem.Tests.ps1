# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-APBillItem.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Private/ConvertTo-APBillItem.ps1
. (Join-Path $PrivatePath $sut)

Describe "ConvertTo-APBillItem" -tag 'Unit' {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'ConvertTo-APBillItem'
        }
        
        $Parameters = @(
            @{Name='ACCOUNTNO';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='ACCOUNTLABEL';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='OFFSETGLACCOUNTNO';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='TRX_AMOUNT';Type=[decimal];ValueFromPipelineByPropertyName=$true}
            @{Name='TOTALTRXAMOUNT';Type=[decimal];ValueFromPipelineByPropertyName=$true}
            @{Name='ENTRYDESCRIPTION';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='FORM1099';Type=[boolean];ValueFromPipelineByPropertyName=$true}
            @{Name='FORM1099TYPE';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='FORM1099BOX';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='BILLABLE';Type=[boolean];ValueFromPipelineByPropertyName=$true}
            @{Name='ALLOCATION';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='LOCATIONID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='DEPARTMENTID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='PROJECTID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='TASKID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='COSTTYPEID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='CUSTOMERID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='VENDORID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='EMPLOYEEID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='ITEMID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='CLASSID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='CONTRACTID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='WAREHOUSEID';Type=[string];ValueFromPipelineByPropertyName=$true}
            @{Name='GLDIM';Type=[int];ValueFromPipelineByPropertyName=$true}
            @{Name='CUSTOMFIELDS';Type=[pscustomobject];ValueFromPipelineByPropertyName=$true}
            @{Name='TAXENTRIES';Type=[pscustomobject];ValueFromPipelineByPropertyName=$true}
        )

        It "<Name> is a [<Type>]" -TestCases $Parameters {
            param($Name,$Type)
            $Command | Should -HaveParameter $Name -Type $Type
        }

        it '<Name> accepts value from the pipeline is <ValueFromPipelineByPropertyName>' -TestCases $Parameters {
            param($Name, $ValueFromPipelineByPropertyName)
          
            $Command.parameters[$Name].Attributes.ValueFromPipelineByPropertyName | Should -Be $ValueFromPipelineByPropertyName
        }

    } # /parameter validation

    Context "By Account No" {

        BeforeAll {
            # arrange
            $Expected = @{
                ACCOUNTNO='ACCOUNTNO'
                OFFSETGLACCOUNTNO='OFFSETGLACCOUNTNO'
                TRX_AMOUNT=100.00
                TOTALTRXAMOUNT=200.00
                ENTRYDESCRIPTION='ENTRYDESCRIPTION'
                FORM1099=$true
                FORM1099TYPE='FORM1099TYPE'
                FORM1099BOX='FORM1099BOX'
                BILLABLE=$true
                ALLOCATION='ALLOCATION'
                LOCATIONID='LOCATIONID'
                DEPARTMENTID='DEPARTMENTID'
                PROJECTID='PROJECTID'
                TASKID='TASKID'
                COSTTYPEID='COSTTYPEID'
                CUSTOMERID='CUSTOMERID'
                VENDORID='VENDORID'
                EMPLOYEEID='EMPLOYEEID'
                ITEMID='ITEMID'
                CLASSID='CLASSID'
                CONTRACTID='CONTRACTID'
                WAREHOUSEID='WAREHOUSEID'
                GLDIM=123
                CUSTOMFIELDS=[pscustomobject]@{FOO='BAR'}
                # TAXENTRIES=$null # not implemented
            }
        }

        It "returns the expected values" {

            # act
            $Actual = [pscustomobject]$Expected | ConvertTo-APBillItem

            # assert
            $Actual.APBILLITEMS.APBILLITEM.ACCOUNTNO | Should -Be $Expected.ACCOUNTNO
            $Actual.APBILLITEMS.APBILLITEM.OFFSETGLACCOUNTNO | Should -Be $Expected.OFFSETGLACCOUNTNO
            $Actual.APBILLITEMS.APBILLITEM.TRX_AMOUNT | Should -Be $Expected.TRX_AMOUNT
            $Actual.APBILLITEMS.APBILLITEM.TOTALTRXAMOUNT | Should -Be $Expected.TOTALTRXAMOUNT
            $Actual.APBILLITEMS.APBILLITEM.ENTRYDESCRIPTION | Should -Be $Expected.ENTRYDESCRIPTION
            $Actual.APBILLITEMS.APBILLITEM.FORM1099 | Should -Be $Expected.FORM1099
            $Actual.APBILLITEMS.APBILLITEM.FORM1099TYPE | Should -Be $Expected.FORM1099TYPE
            $Actual.APBILLITEMS.APBILLITEM.FORM1099BOX | Should -Be $Expected.FORM1099BOX
            $Actual.APBILLITEMS.APBILLITEM.BILLABLE | Should -Be $Expected.BILLABLE
            $Actual.APBILLITEMS.APBILLITEM.ALLOCATION | Should -Be $Expected.ALLOCATION
            $Actual.APBILLITEMS.APBILLITEM.LOCATIONID | Should -Be $Expected.LOCATIONID
            $Actual.APBILLITEMS.APBILLITEM.DEPARTMENTID | Should -Be $Expected.DEPARTMENTID
            $Actual.APBILLITEMS.APBILLITEM.PROJECTID | Should -Be $Expected.PROJECTID
            $Actual.APBILLITEMS.APBILLITEM.TASKID | Should -Be $Expected.TASKID
            $Actual.APBILLITEMS.APBILLITEM.COSTTYPEID | Should -Be $Expected.COSTTYPEID
            $Actual.APBILLITEMS.APBILLITEM.CUSTOMERID | Should -Be $Expected.CUSTOMERID
            $Actual.APBILLITEMS.APBILLITEM.VENDORID | Should -Be $Expected.VENDORID
            $Actual.APBILLITEMS.APBILLITEM.EMPLOYEEID | Should -Be $Expected.EMPLOYEEID
            $Actual.APBILLITEMS.APBILLITEM.ITEMID | Should -Be $Expected.ITEMID
            $Actual.APBILLITEMS.APBILLITEM.CLASSID | Should -Be $Expected.CLASSID
            $Actual.APBILLITEMS.APBILLITEM.CONTRACTID | Should -Be $Expected.CONTRACTID
            $Actual.APBILLITEMS.APBILLITEM.WAREHOUSEID | Should -Be $Expected.WAREHOUSEID
            $Actual.APBILLITEMS.APBILLITEM.GLDIM | Should -Be $Expected.GLDIM
            foreach ($property in $Expected.CUSTOMFIELDS.PSObject.Properties) {
                Write-Debug "$($property.Name): $($property.Value)"
                $Actual.APBILLITEMS.APBILLITEM[$property.Name].'#text' | Should -Be $property.Value
            }
            # $Actual.APBILLITEMS.APBILLITEM.TAXENTRIES | Should -Be $Expected.TAXENTRIES
        }

    }

    Context "By Account Label" {

        BeforeAll {
            # arrange
            $Expected = @{
                ACCOUNTLABEL='ACCOUNTLABEL'
                OFFSETGLACCOUNTNO='OFFSETGLACCOUNTNO'
                TRX_AMOUNT=100.00
                TOTALTRXAMOUNT=200.00
                ENTRYDESCRIPTION='ENTRYDESCRIPTION'
                FORM1099=$true
                FORM1099TYPE='FORM1099TYPE'
                FORM1099BOX='FORM1099BOX'
                BILLABLE=$true
                ALLOCATION='ALLOCATION'
                LOCATIONID='LOCATIONID'
                DEPARTMENTID='DEPARTMENTID'
                PROJECTID='PROJECTID'
                TASKID='TASKID'
                COSTTYPEID='COSTTYPEID'
                CUSTOMERID='CUSTOMERID'
                VENDORID='VENDORID'
                EMPLOYEEID='EMPLOYEEID'
                ITEMID='ITEMID'
                CLASSID='CLASSID'
                CONTRACTID='CONTRACTID'
                WAREHOUSEID='WAREHOUSEID'
                GLDIM=123
                CUSTOMFIELDS=[pscustomobject]@{FOO='BAR'}
                # TAXENTRIES=$null # not implemented
            }
        }

        It "returns the expected values" {

            # act
            $Actual = [pscustomobject]$Expected | ConvertTo-APBillItem

            # assert
            $Actual.APBILLITEMS.APBILLITEM.ACCOUNTLABEL | Should -Be $Expected.ACCOUNTLABEL
            $Actual.APBILLITEMS.APBILLITEM.OFFSETGLACCOUNTNO | Should -Be $Expected.OFFSETGLACCOUNTNO
            $Actual.APBILLITEMS.APBILLITEM.TRX_AMOUNT | Should -Be $Expected.TRX_AMOUNT
            $Actual.APBILLITEMS.APBILLITEM.TOTALTRXAMOUNT | Should -Be $Expected.TOTALTRXAMOUNT
            $Actual.APBILLITEMS.APBILLITEM.ENTRYDESCRIPTION | Should -Be $Expected.ENTRYDESCRIPTION
            $Actual.APBILLITEMS.APBILLITEM.FORM1099 | Should -Be $Expected.FORM1099
            $Actual.APBILLITEMS.APBILLITEM.FORM1099TYPE | Should -Be $Expected.FORM1099TYPE
            $Actual.APBILLITEMS.APBILLITEM.FORM1099BOX | Should -Be $Expected.FORM1099BOX
            $Actual.APBILLITEMS.APBILLITEM.BILLABLE | Should -Be $Expected.BILLABLE
            $Actual.APBILLITEMS.APBILLITEM.ALLOCATION | Should -Be $Expected.ALLOCATION
            $Actual.APBILLITEMS.APBILLITEM.LOCATIONID | Should -Be $Expected.LOCATIONID
            $Actual.APBILLITEMS.APBILLITEM.DEPARTMENTID | Should -Be $Expected.DEPARTMENTID
            $Actual.APBILLITEMS.APBILLITEM.PROJECTID | Should -Be $Expected.PROJECTID
            $Actual.APBILLITEMS.APBILLITEM.TASKID | Should -Be $Expected.TASKID
            $Actual.APBILLITEMS.APBILLITEM.COSTTYPEID | Should -Be $Expected.COSTTYPEID
            $Actual.APBILLITEMS.APBILLITEM.CUSTOMERID | Should -Be $Expected.CUSTOMERID
            $Actual.APBILLITEMS.APBILLITEM.VENDORID | Should -Be $Expected.VENDORID
            $Actual.APBILLITEMS.APBILLITEM.EMPLOYEEID | Should -Be $Expected.EMPLOYEEID
            $Actual.APBILLITEMS.APBILLITEM.ITEMID | Should -Be $Expected.ITEMID
            $Actual.APBILLITEMS.APBILLITEM.CLASSID | Should -Be $Expected.CLASSID
            $Actual.APBILLITEMS.APBILLITEM.CONTRACTID | Should -Be $Expected.CONTRACTID
            $Actual.APBILLITEMS.APBILLITEM.WAREHOUSEID | Should -Be $Expected.WAREHOUSEID
            $Actual.APBILLITEMS.APBILLITEM.GLDIM | Should -Be $Expected.GLDIM
            foreach ($property in $Expected.CUSTOMFIELDS.PSObject.Properties) {
                Write-Debug "$($property.Name): $($property.Value)"
                $Actual.APBILLITEMS.APBILLITEM[$property.Name].'#text' | Should -Be $property.Value
            }
            # $Actual.APBILLITEMS.APBILLITEM.TAXENTRIES | Should -Be $Expected.TAXENTRIES
        }

    }

}
