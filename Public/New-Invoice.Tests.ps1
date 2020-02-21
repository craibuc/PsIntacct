$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-Invoice" -tag 'unit' {

    Context "Required fields" {
        It "creates the expected message" {
            $true | Should -Be $false
        }    
    }

}
