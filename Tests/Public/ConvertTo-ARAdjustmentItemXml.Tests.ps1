# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARAdjustmentItemXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-ARAdjustmentItemXml.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-ARAdjustmentItemXml" -Tag 'unit' {

    $Expected = [pscustomobject]@{
        amount=100.00
    }

    Context "Required fields" {

        it "has 1, mandatory parameters" {
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter amount -Mandatory -Type decimal
        }

        it "returns the expected values" {
            # act
            [xml]$Actual = $Expected | ConvertTo-ARAdjustmentItemXml

            # assert
            $Actual.aradjustmentitems.lineitem.amount | Should -Be $Expected.amount
        }

    }

    Context "Optional fields" {

        it "has 19, mandatory parameters" {
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter glaccountno -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter accountlabel -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter offsetglaccountno -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter memo -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter locationid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter departmentid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter key -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter totalpaid -Type decimal
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter totaldue -Type decimal
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter customfields -Type pscustomobject[]
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter projectid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter taskid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter customerid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter vendorid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter employeeid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter itemid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter classid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter contractid -Type string
            Get-Command "ConvertTo-ARAdjustmentItemXml" | Should -HaveParameter warehouseid -Type string
        }

        $Expected | Add-Member -MemberType NoteProperty -Name 'glaccountno' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'accountlabel' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'offsetglaccountno' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'memo' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'locationid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'departmentid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'key' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'totalpaid' -Value 100.00
        $Expected | Add-Member -MemberType NoteProperty -Name 'totaldue' -Value 100.00
        # $Expected | Add-Member -MemberType NoteProperty -Name 'customfields' -Value [pscustomobject]@{}
        $Expected | Add-Member -MemberType NoteProperty -Name 'projectid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'taskid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'customerid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'vendorid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'employeeid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'itemid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'classid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'contractid' -Value 'abc'
        $Expected | Add-Member -MemberType NoteProperty -Name 'warehouseid' -Value 'abc'

        it "returns the expected values" {
            # act
            [xml]$Actual = $Expected | ConvertTo-ARAdjustmentItemXml

            # assert
            $Actual.aradjustmentitems.lineitem.glaccountno | Should -Be $Expected.glaccountno
            $Actual.aradjustmentitems.lineitem.accountlabel | Should -Be $Expected.accountlabel
            $Actual.aradjustmentitems.lineitem.offsetglaccountno | Should -Be $Expected.offsetglaccountno
            $Actual.aradjustmentitems.lineitem.memo | Should -Be $Expected.memo
            $Actual.aradjustmentitems.lineitem.locationid | Should -Be $Expected.locationid
            $Actual.aradjustmentitems.lineitem.departmentid | Should -Be $Expected.departmentid
            $Actual.aradjustmentitems.lineitem.key | Should -Be $Expected.key
            $Actual.aradjustmentitems.lineitem.totalpaid | Should -Be $Expected.totalpaid
            $Actual.aradjustmentitems.lineitem.totaldue | Should -Be $Expected.totaldue
            # $Actual.aradjustmentitems.lineitem.customfields | Should -Be $Expected.customfields
            $Actual.aradjustmentitems.lineitem.projectid | Should -Be $Expected.projectid
            $Actual.aradjustmentitems.lineitem.taskid | Should -Be $Expected.taskid
            $Actual.aradjustmentitems.lineitem.customerid | Should -Be $Expected.customerid
            $Actual.aradjustmentitems.lineitem.vendorid | Should -Be $Expected.vendorid
            $Actual.aradjustmentitems.lineitem.employeeid | Should -Be $Expected.employeeid
            $Actual.aradjustmentitems.lineitem.itemid | Should -Be $Expected.itemid
            $Actual.aradjustmentitems.lineitem.classid | Should -Be $Expected.classid
            $Actual.aradjustmentitems.lineitem.contractid | Should -Be $Expected.contractid
            $Actual.aradjustmentitems.lineitem.warehouseid | Should -Be $Expected.warehouseid
        }
    }
}
