# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARAdjustmentXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

. (Join-Path $PublicPath $sut)

Describe "Format-Xml" {
    It "does something useful" -skip {
        $true | Should -Be $false
    }
}
