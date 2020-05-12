# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
# $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-GLEntry.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-GLEntry.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-GLEntry" -tag 'unit' {

    $Entry = [pscustomobject]@{
        ACCOUNTNO='HEADS'
        TRX_AMOUNT=-100.00
        TR_TYPE=1
    }

    Context "Required fields" {

        # assert
        it "has 3, mandatory parameter" {
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter ACCOUNTNO -Mandatory
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter TRX_AMOUNT -Mandatory
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter TR_TYPE -Mandatory
        }
    
        it "returns the expected values" {
            # act
            [xml]$Actual = $Entry | ConvertTo-GLEntry

            # assert
            $Actual.ENTRIES.GLENTRY.ACCOUNTNO | Should -Be $Entry.ACCOUNTNO
            $Actual.ENTRIES.GLENTRY.TRX_AMOUNT | Should -Be ([System.Math]::Abs($Entry.TRX_AMOUNT))
            $Actual.ENTRIES.GLENTRY.TR_TYPE | Should -Be $Entry.TR_TYPE
        }

    } # /context

    Context "Optional fields" {

        # assert
        it "has 13, optionsl parameter" {
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter DOCUMENT
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter DESCRIPTION
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter ALLOCATION
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter DEPARTMENT
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter LOCATION
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter PROJECTID
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter CUSTOMERID
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter VENDORID
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter EMPLOYEEID
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter ITEMID
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter CLASSID
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter CONTRACTID
            Get-Command "ConvertTo-GLEntry" | Should -HaveParameter WAREHOUSEID
        }

        # arrange
        $Entry | Add-Member -MemberType NoteProperty -Name 'DOCUMENT' -Value 'yyy'
        $Entry | Add-Member -MemberType NoteProperty -Name 'DESCRIPTION' -Value 'lorem ipsum'
        $Entry | Add-Member -MemberType NoteProperty -Name 'ALLOCATION' -Value 'xxx'
        $Entry | Add-Member -MemberType NoteProperty -Name 'DEPARTMENT' -Value 'ADMIN'
        $Entry | Add-Member -MemberType NoteProperty -Name 'LOCATION' -Value '111'
        $Entry | Add-Member -MemberType NoteProperty -Name 'PROJECTID' -Value '222'
        $Entry | Add-Member -MemberType NoteProperty -Name 'CUSTOMERID' -Value '333'
        $Entry | Add-Member -MemberType NoteProperty -Name 'VENDORID' -Value '444'
        $Entry | Add-Member -MemberType NoteProperty -Name 'EMPLOYEEID' -Value '555'
        $Entry | Add-Member -MemberType NoteProperty -Name 'ITEMID' -Value '666'
        $Entry | Add-Member -MemberType NoteProperty -Name 'CLASSID' -Value '777'
        $Entry | Add-Member -MemberType NoteProperty -Name 'CONTRACTID' -Value '888'
        $Entry | Add-Member -MemberType NoteProperty -Name 'WAREHOUSEID' -Value '999'
        
        it "returns the expected values" {
            # act
            [xml]$Actual = $Entry | ConvertTo-GLEntry

            # assert
            $Actual.ENTRIES.GLENTRY.DOCUMENT | Should -Be $Entry.DOCUMENT
            $Actual.ENTRIES.GLENTRY.DESCRIPTION | Should -Be $Entry.DESCRIPTION
            $Actual.ENTRIES.GLENTRY.ALLOCATION | Should -Be $Entry.ALLOCATION
            $Actual.ENTRIES.GLENTRY.DEPARTMENT | Should -Be $Entry.DEPARTMENT
            $Actual.ENTRIES.GLENTRY.LOCATION | Should -Be $Entry.LOCATION
            $Actual.ENTRIES.GLENTRY.PROJECTID | Should -Be $Entry.PROJECTID
            $Actual.ENTRIES.GLENTRY.CUSTOMERID | Should -Be $Entry.CUSTOMERID
            $Actual.ENTRIES.GLENTRY.VENDORID | Should -Be $Entry.VENDORID
            $Actual.ENTRIES.GLENTRY.EMPLOYEEID | Should -Be $Entry.EMPLOYEEID
            $Actual.ENTRIES.GLENTRY.ITEMID | Should -Be $Entry.ITEMID
            $Actual.ENTRIES.GLENTRY.CLASSID | Should -Be $Entry.CLASSID
            $Actual.ENTRIES.GLENTRY.CONTRACTID | Should -Be $Entry.CONTRACTID
            $Actual.ENTRIES.GLENTRY.WAREHOUSEID | Should -Be $Entry.WAREHOUSEID
        }

    } # /context

}
