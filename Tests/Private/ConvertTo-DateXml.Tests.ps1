# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-DateXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Private/ConvertTo-DateXml.ps1
. (Join-Path $PrivatePath $sut)

Describe "ConvertTo-DateXml" -tag 'Unit' {

    Context "Parameter validation" {
        $Command = Get-Command 'ConvertTo-DateXml'

        Context "InputObject" {
            $ParameterName = 'InputObject'
            
            it "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            it "supports ValueFromPipeline" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipeline | Should -Be $true
            }
        }

        Context "Element" {
            $ParameterName = 'Element'
            
            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

    }

    Context "Usage" {
        # arrange
        $Expected = Get-Date
        $Element = 'duedate'

        # act
        $Actual = $Expected | ConvertTo-DateXml -Element $Element

        # assert
        $Actual."$Element".year | Should -Be $Expected.Year
        $Actual."$Element".month | Should -Be $Expected.Month
        $Actual."$Element".day | Should -Be $Expected.Day
    }

}
