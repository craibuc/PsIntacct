$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Set-Customer" -Tag 'unit' {
    It "does something useful" -Skip {
        $true | Should -Be $false
    }
}