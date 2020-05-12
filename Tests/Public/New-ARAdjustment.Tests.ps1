# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
# $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-Dimension.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Get-Dimension.ps1
. (Join-Path $PublicPath $sut)

# dependencies
# . (Join-Path $PrivatePath "Send-Request.ps1")

Describe "New-ARAdjustment" -Tag 'unit' {

    Context "Parameter validation" {

        it "has 2, mandatory parameters" {

            Get-Command "New-ARAdjustment" | Should -HaveParameter Session -Mandatory
            Get-Command "New-ARAdjustment" | Should -HaveParameter ARAdjustmentXml -Mandatory -Type xml

        }

    }

}
