$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-InvoiceXml" -Tag 'unit' {

    $Invoice = [pscustomobject]@{
        customerid='ABC123'
        datecreated = '02/20/2020'
    }

    Context "Required fields" {

        it "has 3, mandatory parameter" {
            Get-Command "ConvertTo-InvoiceXml" | Should -HaveParameter Verb -Mandatory
            Get-Command "ConvertTo-InvoiceXml" | Should -HaveParameter customerid -Mandatory
            Get-Command "ConvertTo-InvoiceXml" | Should -HaveParameter datecreated -Mandatory -Type datetime
        }
    
        it "returns the expected values" {
            # act
            $Actual = $Invoice | ConvertTo-InvoiceXml -Verb 'create'
            
            # assert
            $Actual.create_invoice.customerid | Should -Be $Invoice.customerid
            $Actual.create_invoice.datecreated.year | Should -Be ([datetime]$Invoice.datecreated).year.ToString('0000')
            $Actual.create_invoice.datecreated.month | Should -Be ([datetime]$Invoice.datecreated).month.ToString('00')
            $Actual.create_invoice.datecreated.day | Should -Be ([datetime]$Invoice.datecreated).day.ToString('00')
        }

    }

}
