# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARAdjustmentXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PublicPath "ConvertTo-ARAdjustmentItemXml.ps1")

Describe "ConvertTo-ARAdjustmentXml" {

    $Adjustment = [pscustomobject]@{
        customerid=123
        datecreated='03/01/2020'
        aradjustmentitems=[pscustomobject]@{}
    }

    Context "Required fields" {

        it "has 3, mandatory parameters" {
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter customerid -Mandatory -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter datecreated -Mandatory -Type datetime
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter aradjustmentitems -Mandatory -Type pscustomobject[]
        }

        it "returns the expected values" {
            # act
            [xml]$Actual = $Adjustment | ConvertTo-ARAdjustmentXml -Verb 'create'

            # assert
            $Actual.create_aradjustment.customerid | Should -Be $Adjustment.customerid
            $Actual.create_aradjustment.datecreated.year | Should -Be ([datetime]$Adjustment.datecreated).ToString('yyyy')
            $Actual.create_aradjustment.datecreated.month | Should -Be ([datetime]$Adjustment.datecreated).ToString('MM')
            $Actual.create_aradjustment.datecreated.day | Should -Be ([datetime]$Adjustment.datecreated).ToString('dd')
        }

    }

    Context "Optional fields" {

        it "has 3, mandatory parameters" {
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter dateposted -Type datetime
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter batchkey -Type int
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter adjustmentno -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter action -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter invoiceno -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter description -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter externalid -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter basecurr -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter currency -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter exchratedate -Type datetime
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter exchratetype -Type string
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter exchrate -Type decimal
            Get-Command "ConvertTo-ARAdjustmentXml" | Should -HaveParameter nogl -Type bool
        }

        $Adjustment | Add-Member -MemberType NoteProperty -Name 'dateposted' -Value '03/01/2020'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'batchkey' -Value 123
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'adjustmentno' -Value '123'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'action' -Value '123'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'invoiceno' -Value '123'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'description' -Value 'lorem ipsum'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'externalid' -Value '123'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'basecurr' -Value 'USD'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'currency' -Value 'USD'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'exchratedate' -Value '03/01/2020'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'exchratetype' -Value '123'
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'exchrate' -Value 1.0
        $Adjustment | Add-Member -MemberType NoteProperty -Name 'nogl' -Value $false

        it "returns the expected values" {
            # act
            [xml]$Actual = $Adjustment | ConvertTo-ARAdjustmentXml -Verb 'create'

            # assert
            $Actual.create_aradjustment.customerid | Should -Be $Adjustment.customerid
            $Actual.create_aradjustment.dateposted.year | Should -Be ([datetime]$Adjustment.dateposted).ToString('yyyy')
            $Actual.create_aradjustment.dateposted.month | Should -Be ([datetime]$Adjustment.dateposted).ToString('MM')
            $Actual.create_aradjustment.dateposted.day | Should -Be ([datetime]$Adjustment.dateposted).ToString('dd')
            $Actual.create_aradjustment.batchkey | Should -Be $Adjustment.batchkey
            $Actual.create_aradjustment.adjustmentno | Should -Be $Adjustment.adjustmentno
            $Actual.create_aradjustment.action | Should -Be $Adjustment.action
            $Actual.create_aradjustment.invoiceno | Should -Be $Adjustment.invoiceno
            $Actual.create_aradjustment.description | Should -Be $Adjustment.description
            $Actual.create_aradjustment.externalid | Should -Be $Adjustment.externalid
            $Actual.create_aradjustment.basecurr | Should -Be $Adjustment.basecurr
            $Actual.create_aradjustment.currency | Should -Be $Adjustment.currency
            $Actual.create_aradjustment.exchratedate.year | Should -Be ([datetime]$Adjustment.exchratedate).ToString('yyyy')
            $Actual.create_aradjustment.exchratedate.month | Should -Be ([datetime]$Adjustment.exchratedate).ToString('MM')
            $Actual.create_aradjustment.exchratedate.day | Should -Be ([datetime]$Adjustment.exchratedate).ToString('dd')
            $Actual.create_aradjustment.exchratetype | Should -Be $Adjustment.exchratetype
            $Actual.create_aradjustment.exchrate | Should -Be $Adjustment.exchrate
            $Actual.create_aradjustment.nogl | Should -Be $Adjustment.nogl.ToString().ToLower()
        }

    }

}
