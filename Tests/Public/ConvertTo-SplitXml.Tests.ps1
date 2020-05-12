$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-SplitXml" -Tag 'unit' {

    $Split = [pscustomobject]@{
        AMOUNT=123.45
        DEPARTMENTID='department id'
        LOCATIONID='location id'
        PROJECTID='project id'
        CUSTOMERID='customer id'
        VENDORID='vendor id'
        EMPLOYEEID='employee id'
        ITEMID='item id'
        CLASSID='class id'
        CONTRACTID='contract id'
        WAREHOUSEID='warehouse id'
    }

    Context "Optional fields" {

        it "has 11 parameters" {
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter AMOUNT
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter DEPARTMENTID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter LOCATIONID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter PROJECTID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter CUSTOMERID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter VENDORID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter EMPLOYEEID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter ITEMID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter CLASSID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter CONTRACTID
            Get-Command "ConvertTo-SplitXml" | Should -HaveParameter WAREHOUSEID
        }
    
        it "returns the expected values" {
            # act
            [xml]$Actual = $Split | ConvertTo-SplitXml

            # assert
            $Actual.SPLIT.AMOUNT | Should -Be $Split.AMOUNT
            $Actual.SPLIT.DEPARTMENTID | Should -Be $Split.DEPARTMENTID
            $Actual.SPLIT.LOCATIONID | Should -Be $Split.LOCATIONID
            $Actual.SPLIT.PROJECTID | Should -Be $Split.PROJECTID
            $Actual.SPLIT.CUSTOMERID | Should -Be $Split.CUSTOMERID
            $Actual.SPLIT.VENDORID | Should -Be $Split.VENDORID
            $Actual.SPLIT.EMPLOYEEID | Should -Be $Split.EMPLOYEEID
            $Actual.SPLIT.ITEMID | Should -Be $Split.ITEMID
            $Actual.SPLIT.CLASSID | Should -Be $Split.CLASSID
            $Actual.SPLIT.CONTRACTID | Should -Be $Split.CONTRACTID
            $Actual.SPLIT.WAREHOUSEID | Should -Be $Split.WAREHOUSEID
        }

    } # /context

}
