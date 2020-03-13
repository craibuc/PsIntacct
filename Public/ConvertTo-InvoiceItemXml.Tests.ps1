$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-InvoiceItemXml" -Tag 'unit' {

    $InvoiceItem = [pscustomobject]@{amount=76343.43}

    Context "Required fields" {

        it "has 1, mandatory parameter" {
            Get-Command "ConvertTo-InvoiceItemXml" | Should -HaveParameter amount -Mandatory
        }
    
        it "returns the expected values" {
            # act
            [xml]$Actual = $InvoiceItem | ConvertTo-InvoiceItemXml

            # assert
            $Actual.invoiceitems.lineitem.amount | Should -Be $InvoiceItem.amount
            $Actual.invoiceitems.lineitem.accountlabel | Should -BeNullOrEmpty
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

        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'accountlabel' -Value 'TestBill Account1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'glaccountno' -Value '0123456789'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'offsetglaccountno' -Value '93590253'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'revrecstartdate' -Value '06/01/2016'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'revrecenddate' -Value '05/31/2017'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'memo' -Value 'Just another memo'

        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'totalpaid' -Value 23484.93
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'totaldue' -Value 100.00

        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'revrectemplate' -Value 'RevRec1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'defrevaccount' -Value '2100'

        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'allocationid' -Value 'Allocation1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'classid' -Value 'Class1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'contractid' -Value 'Contract1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'customerid' -Value 'Customer1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'departmentid' -Value 'Department1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'employeeid' -Value 'Employee1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'itemid' -Value 'Item1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'key' -Value 'Key1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'locationid' -Value 'Location1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'projectid' -Value 'Project1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'taskid' -Value 'Task1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'vendorid' -Value 'Vendor1'
        $InvoiceItem | Add-Member -MemberType NoteProperty -Name 'warehouseid' -Value 'Warehouse1'
        
        it "returns the expected values" {
            # act
            [xml]$Actual = $InvoiceItem | ConvertTo-InvoiceItemXml

            # assert
            $Actual.invoiceitems.lineitem.accountlabel | Should -Be $InvoiceItem.accountlabel
            $Actual.invoiceitems.lineitem.glaccountno | Should -Be $InvoiceItem.glaccountno
            $Actual.invoiceitems.lineitem.offsetglaccountno | Should -Be $InvoiceItem.offsetglaccountno
            $Actual.invoiceitems.lineitem.revrecstartdate.year | Should -Be ([datetime]$InvoiceItem.revrecstartdate).ToString('yyyy')
            $Actual.invoiceitems.lineitem.revrecstartdate.month | Should -Be ([datetime]$InvoiceItem.revrecstartdate).ToString('MM')
            $Actual.invoiceitems.lineitem.revrecstartdate.day | Should -Be ([datetime]$InvoiceItem.revrecstartdate).ToString('dd')
            $Actual.invoiceitems.lineitem.revrecenddate.year | Should -Be ([datetime]$InvoiceItem.revrecenddate).ToString('yyyy')
            $Actual.invoiceitems.lineitem.revrecenddate.month | Should -Be ([datetime]$InvoiceItem.revrecenddate).ToString('MM')
            $Actual.invoiceitems.lineitem.revrecenddate.day | Should -Be ([datetime]$InvoiceItem.revrecenddate).ToString('dd')

            $Actual.invoiceitems.lineitem.totalpaid | Should -Be $InvoiceItem.totalpaid
            $Actual.invoiceitems.lineitem.totaldue | Should -Be $InvoiceItem.totaldue

            $Actual.invoiceitems.lineitem.revrectemplate | Should -Be $InvoiceItem.revrectemplate
            $Actual.invoiceitems.lineitem.defrevaccount | Should -Be $InvoiceItem.defrevaccount

            $Actual.invoiceitems.lineitem.allocationid | Should -Be $InvoiceItem.allocationid
            $Actual.invoiceitems.lineitem.classid | Should -Be $InvoiceItem.classid
            $Actual.invoiceitems.lineitem.contractid | Should -Be $InvoiceItem.contractid
            $Actual.invoiceitems.lineitem.customerid | Should -Be $InvoiceItem.customerid
            $Actual.invoiceitems.lineitem.departmentid | Should -Be $InvoiceItem.departmentid
            $Actual.invoiceitems.lineitem.employeeid | Should -Be $InvoiceItem.employeeid
            $Actual.invoiceitems.lineitem.itemid | Should -Be $InvoiceItem.itemid
            $Actual.invoiceitems.lineitem.key | Should -Be $InvoiceItem.key
            $Actual.invoiceitems.lineitem.locationid | Should -Be $InvoiceItem.locationid
            $Actual.invoiceitems.lineitem.projectid | Should -Be $InvoiceItem.projectid
            $Actual.invoiceitems.lineitem.projectid | Should -Be $InvoiceItem.projectid
            $Actual.invoiceitems.lineitem.taskid | Should -Be $InvoiceItem.taskid
            $Actual.invoiceitems.lineitem.warehouseid | Should -Be $InvoiceItem.warehouseid

        }

    } # /context

} # /describe