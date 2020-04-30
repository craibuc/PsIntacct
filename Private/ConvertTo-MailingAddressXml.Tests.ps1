$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-MailingAddressXml" -Tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command "ConvertTo-MailingAddressXml"

        Context "ADDRESS1" {
            $ParameterName='ADDRESS1'

            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "supports ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "ADDRESS2" {
            $ParameterName='ADDRESS2'

            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "supports ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "CITY" {
            $ParameterName='CITY'

            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "supports ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "STATE" {
            $ParameterName='STATE'

            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "supports ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "ZIP" {
            $ParameterName='ZIP'

            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "supports ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "COUNTRYCODE" {
            $ParameterName='COUNTRYCODE'

            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "supports ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
            it "has a default value of 'US'" {
                $Command | Should -HaveParameter $ParameterName -DefaultValue 'US'
            }
        }

    }

    Context "Usage" {
    
        $Address = [pscustomobject]@{
            ADDRESS1='Address One'
            ADDRESS2='Address Two'
            CITY='Minneapolis'
            STATE='MN'
            ZIP='12345'
            COUNTRYCODE='US'
        }
    
        it "returns the expected values" {
            # act
            [xml]$Actual = $Address | ConvertTo-MailingAddressXml

            # assert
            $Actual.MAILADDRESS.ADDRESS1 | Should -Be $Address.ADDRESS1
            $Actual.MAILADDRESS.ADDRESS2 | Should -Be $Address.ADDRESS2
            $Actual.MAILADDRESS.CITY | Should -Be $Address.CITY
            $Actual.MAILADDRESS.STATE | Should -Be $Address.STATE
            $Actual.MAILADDRESS.ZIP | Should -Be $Address.ZIP
            $Actual.MAILADDRESS.COUNTRYCODE | Should -Be $Address.COUNTRYCODE
        }

        Context "Xml escaping" {

            # arrange
            $Address.ADDRESS1= "Ruth & Steve's"
            $Address.ADDRESS2= "Ruth & Steve's"
            $Address.CITY="Coeur d'Alene"
    
            it "prevents Xml exceptions" {
                # act
                {$Address | ConvertTo-MailingAddressXml -ErrorAction Stop } | Should -Not -Throw
            }

        }

    } # /context

}
