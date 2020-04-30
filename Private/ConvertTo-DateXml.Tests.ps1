$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
