$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-ARAdjustment" -Tag 'unit' {

    Context "Parameter validation" {

        it "has 2, mandatory parameters" {

            Get-Command "New-ARAdjustment" | Should -HaveParameter Session -Mandatory
            Get-Command "New-ARAdjustment" | Should -HaveParameter ARAdjustmentXml -Mandatory -Type xml

        }

    }

}
