# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
# $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARPaymentSummaryXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-ARPaymentSummaryXml.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-ARPaymentSummaryXml" -Tag 'unit' {

    $Summary = [pscustomobject]@{
        batchtitle='lorem ipsum'
        datecreated='03/23/2020'
    }

    Context "Required fields" {

        it "has 2, mandatory parameters" {
            Get-Command "ConvertTo-ARPaymentSummaryXml" | Should -HaveParameter batchtitle -Mandatory -Type string
            Get-Command "ConvertTo-ARPaymentSummaryXml" | Should -HaveParameter datecreated -Mandatory -Type datetime
        }

        it "returns the expected values" {
            # act
            [xml]$Actual = $Summary | ConvertTo-ARPaymentSummaryXml

            # assert
            $Actual.create_arpaymentbatch.batchtitle | Should -Be $Summary.batchtitle
            $Actual.create_arpaymentbatch.datecreated.year | Should -Be ([datetime]$Summary.datecreated).ToString('yyyy')
            $Actual.create_arpaymentbatch.datecreated.month | Should -Be ([datetime]$Summary.datecreated).ToString('MM')
            $Actual.create_arpaymentbatch.datecreated.day | Should -Be ([datetime]$Summary.datecreated).ToString('dd')
        }

    }

    Context "Required fields" {

        it "has 2, optional parameters" {
            Get-Command "ConvertTo-ARPaymentSummaryXml" | Should -HaveParameter bankaccountid -Type string
            Get-Command "ConvertTo-ARPaymentSummaryXml" | Should -HaveParameter undepfundsacct -Type string
        }

        $Summary | Add-Member -MemberType NoteProperty -Name 'bankaccountid' -Value '123456'
        $Summary | Add-Member -MemberType NoteProperty -Name 'undepfundsacct' -Value 'abcdef'

        it "returns the expected values" {
            # act
            [xml]$Actual = $Summary | ConvertTo-ARPaymentSummaryXml

            # assert
            $Actual.create_arpaymentbatch.bankaccountid | Should -Be $Summary.bankaccountid
            $Actual.create_arpaymentbatch.undepfundsacct | Should -Be $Summary.undepfundsacct
        }
    }
}
