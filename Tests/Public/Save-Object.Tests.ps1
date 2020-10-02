# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# New-Object.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/New-Object.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")
# . (Join-Path $PrivatePath "ConvertTo-PlainText.ps1")

Describe "Save-Object" -Tag 'unit' {

    Context "Parameter validation" {
        # arrange

        $Parameters = @(
            @{ParameterName='Session';Type=[pscustomobject];IsMandatory=$true;ValueFromPipeline=$false}
            @{ParameterName='ObjectXml';Type=[xml];IsMandatory=$true;ValueFromPipeline=$true}
        )
        BeforeAll {
            $Command = Get-Command 'Save-Object'
        }

        it '<ParameterName> is a <Type>' -TestCases $Parameters {
            param($ParameterName, $Type)
          
            $Command | Should -HaveParameter $ParameterName -Type $type
        }

        it '<ParameterName> mandatory is <Mandatory>' -TestCases $Parameters {
            param($ParameterName, $IsMandatory)
          
            if ($IsMandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
            else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
        }

        it '<ParameterName> accepts value from the pipeline is <ValueFromPipeline>' -TestCases $Parameters {
            param($ParameterName, $ValueFromPipeline)
          
            $Command.parameters[$ParameterName].Attributes.ValueFromPipeline | Should -Be $ValueFromPipeline
        }

    }

    Context "Usage" {

        BeforeAll {

            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

        }

        Context "when a RECORDNO is provided" {

            BeforeAll {
                # arrange
                Mock Send-Request {
                    $Fixture = 'Save-Object.update.xml'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                    # Write-Debug $Content
                    [xml]$Content
                }
            }

            BeforeEach {
                # arrange
                [xml]$ObjectXml = "<CUSTOMER><RECORDNO/></CUSTOMER>"
    
                # act
                $Actual = Save-Object -Session $Session -ObjectXml $ObjectXml
            }

            It "adds the update element" {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.getElementsByTagName('RECORDNO').count -eq 1
                }
            }
    
            It "returns the expected result element" {
                $Actual.function | Should -Be 'update'
            }

            It "has a RECORDNO element" {
                $Actual.data.getElementsByTagName('RECORDNO').count | Should -Be 1
            }

        }
    
        Context "when a RECORDNO is NOT provided" {
    
            BeforeAll {
                # arrange
                Mock Send-Request {
                    $Fixture = 'Save-Object.create.xml'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                    # Write-Debug $Content
                    [xml]$Content
                }
            }

            BeforeEach {
                # arrange
                [xml]$ObjectXml = "<CUSTOMER/>"
    
                # act
                $Actual = Save-Object -Session $Session -ObjectXml $ObjectXml
            }

            It "adds the create element" {    
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.getElementsByTagName('RECORDNO').count -eq 0
                }
            }

            It "returns the expected result element" {
                $Actual.function | Should -Be 'create'
            }

            It "has a RECORDNO element" {
                $Actual.data.getElementsByTagName('RECORDNO').count | Should -Be 1
            }

        }

    }

}
