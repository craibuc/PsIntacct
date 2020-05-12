# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
# $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-InvoiceItemXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-InvoiceItemXml.ps1
. (Join-Path $PublicPath $sut)


Describe "ConvertTo-InvoiceItemXml" -Tag 'unit' {

    Context "ByAccountNumber" {

        it "has 2, mandatory parameter" {
            Get-Command "ConvertTo-InvoiceItemXml" | Should -HaveParameter glaccountno -Mandatory
            Get-Command "ConvertTo-InvoiceItemXml" | Should -HaveParameter amount -Mandatory
        }

        $Expected = [pscustomobject]@{
            glaccountno='93590253'
            amount=76343.43
        }

        it "returns the expected values" {
            # act
            [xml]$Actual = $Expected | ConvertTo-InvoiceItemXml

            # assert
            $Actual.invoiceitems.lineitem.glaccountno | Should -Be $Expected.glaccountno
            $Actual.invoiceitems.lineitem.amount | Should -Be $Expected.amount

            $Actual.invoiceitems.lineitem.accountlabel | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.offsetglaccountno | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.memo | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.revrecstartdate | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.revrecenddate | Should -BeNullOrEmpty

            $Actual.invoiceitems.lineitem.totalpaid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.totaldue | Should -BeNullOrEmpty

            $Actual.invoiceitems.lineitem.revrectemplate | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.defrevaccount | Should -BeNullOrEmpty

            $Actual.invoiceitems.lineitem.allocationid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.classid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.contractid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.customerid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.departmentid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.employeeid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.itemid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.key | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.locationid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.projectid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.taskid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.vendorid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.warehouseid | Should -BeNullOrEmpty
        }

    } # /context

    Context "ByAccountLabel" {

        it "has 2, mandatory parameters" {
            Get-Command "ConvertTo-InvoiceItemXml" | Should -HaveParameter accountlabel -Mandatory
            Get-Command "ConvertTo-InvoiceItemXml" | Should -HaveParameter amount -Mandatory
        }

        $Expected = [pscustomobject]@{
            accountlabel='account label'
            amount=76343.43
        }

        it "returns the expected values" {
            # act
            [xml]$Actual = $Expected | ConvertTo-InvoiceItemXml

            # assert
            $Actual.invoiceitems.lineitem.accountlabel | Should -Be $Expected.accountlabel
            $Actual.invoiceitems.lineitem.amount | Should -Be $Expected.amount

            $Actual.invoiceitems.lineitem.glaccountno | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.offsetglaccountno | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.memo | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.revrecstartdate | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.revrecenddate | Should -BeNullOrEmpty

            $Actual.invoiceitems.lineitem.totalpaid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.totaldue | Should -BeNullOrEmpty

            $Actual.invoiceitems.lineitem.revrectemplate | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.defrevaccount | Should -BeNullOrEmpty

            $Actual.invoiceitems.lineitem.allocationid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.classid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.contractid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.customerid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.departmentid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.employeeid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.itemid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.key | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.locationid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.projectid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.taskid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.vendorid | Should -BeNullOrEmpty
            $Actual.invoiceitems.lineitem.warehouseid | Should -BeNullOrEmpty
        }

    } # /context

    Context "Optional fields" {

        $Expected = [pscustomobject]@{
            accountlabel='account label'
            amount=76343.43
        }

        $Expected | Add-Member -MemberType NoteProperty -Name 'offsetglaccountno' -Value '93590253'
        $Expected | Add-Member -MemberType NoteProperty -Name 'revrecstartdate' -Value '06/01/2016'
        $Expected | Add-Member -MemberType NoteProperty -Name 'revrecenddate' -Value '05/31/2017'
        $Expected | Add-Member -MemberType NoteProperty -Name 'memo' -Value 'Just another memo'

        $Expected | Add-Member -MemberType NoteProperty -Name 'totalpaid' -Value 23484.93
        $Expected | Add-Member -MemberType NoteProperty -Name 'totaldue' -Value 100.00

        $Expected | Add-Member -MemberType NoteProperty -Name 'revrectemplate' -Value 'RevRec1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'defrevaccount' -Value '2100'

        $Expected | Add-Member -MemberType NoteProperty -Name 'allocationid' -Value 'Allocation1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'classid' -Value 'Class1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'contractid' -Value 'Contract1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'customerid' -Value 'Customer1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'departmentid' -Value 'Department1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'employeeid' -Value 'Employee1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'itemid' -Value 'Item1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'key' -Value 'Key1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'locationid' -Value 'Location1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'projectid' -Value 'Project1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'taskid' -Value 'Task1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'vendorid' -Value 'Vendor1'
        $Expected | Add-Member -MemberType NoteProperty -Name 'warehouseid' -Value 'Warehouse1'
        
        it "returns the expected values" {
            # act
            [xml]$Actual = $Expected | ConvertTo-InvoiceItemXml

            # assert
            $Actual.invoiceitems.lineitem.accountlabel | Should -Be $Expected.accountlabel
            $Actual.invoiceitems.lineitem.glaccountno | Should -Be $Expected.glaccountno
            $Actual.invoiceitems.lineitem.offsetglaccountno | Should -Be $Expected.offsetglaccountno
            $Actual.invoiceitems.lineitem.revrecstartdate.year | Should -Be ([datetime]$Expected.revrecstartdate).ToString('yyyy')
            $Actual.invoiceitems.lineitem.revrecstartdate.month | Should -Be ([datetime]$Expected.revrecstartdate).ToString('MM')
            $Actual.invoiceitems.lineitem.revrecstartdate.day | Should -Be ([datetime]$Expected.revrecstartdate).ToString('dd')
            $Actual.invoiceitems.lineitem.revrecenddate.year | Should -Be ([datetime]$Expected.revrecenddate).ToString('yyyy')
            $Actual.invoiceitems.lineitem.revrecenddate.month | Should -Be ([datetime]$Expected.revrecenddate).ToString('MM')
            $Actual.invoiceitems.lineitem.revrecenddate.day | Should -Be ([datetime]$Expected.revrecenddate).ToString('dd')

            $Actual.invoiceitems.lineitem.totalpaid | Should -Be $Expected.totalpaid
            $Actual.invoiceitems.lineitem.totaldue | Should -Be $Expected.totaldue

            $Actual.invoiceitems.lineitem.revrectemplate | Should -Be $Expected.revrectemplate
            $Actual.invoiceitems.lineitem.defrevaccount | Should -Be $Expected.defrevaccount

            $Actual.invoiceitems.lineitem.allocationid | Should -Be $Expected.allocationid
            $Actual.invoiceitems.lineitem.classid | Should -Be $Expected.classid
            $Actual.invoiceitems.lineitem.contractid | Should -Be $Expected.contractid
            $Actual.invoiceitems.lineitem.customerid | Should -Be $Expected.customerid
            $Actual.invoiceitems.lineitem.departmentid | Should -Be $Expected.departmentid
            $Actual.invoiceitems.lineitem.employeeid | Should -Be $Expected.employeeid
            $Actual.invoiceitems.lineitem.itemid | Should -Be $Expected.itemid
            $Actual.invoiceitems.lineitem.key | Should -Be $Expected.key
            $Actual.invoiceitems.lineitem.locationid | Should -Be $Expected.locationid
            $Actual.invoiceitems.lineitem.projectid | Should -Be $Expected.projectid
            $Actual.invoiceitems.lineitem.projectid | Should -Be $Expected.projectid
            $Actual.invoiceitems.lineitem.taskid | Should -Be $Expected.taskid
            $Actual.invoiceitems.lineitem.warehouseid | Should -Be $Expected.warehouseid

        }

    } # /context

} # /describe