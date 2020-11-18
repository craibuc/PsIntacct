BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsIntacct/PsIntacct/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"

    # ConvertFrom-IntacctFile.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/ConvertFrom-IntacctFile.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "ConvertFrom-IntacctFile" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'ConvertFrom-IntacctFile'
        } 

        $Parameters = @(
            @{
                ParameterName = 'attachments'
                Type = [object]
                Mandatory = $true
                ValueFromPipelineByPropertyName = $true
            }
        )

        Context "Type" {
            It "<ParameterName> is a <Type>" -TestCases $Parameters {
                param($ParameterName,$Type)

                $Command | Should -HaveParameter $ParameterName -Type $Type
            }
        }

        Context "Mandatory" {
            it '<ParameterName> mandatory is <Mandatory>' -TestCases $Parameters {
                param($ParameterName, $Mandatory)
              
                if ($Mandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
                else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
            }
        }

        Context "Pipeline" {
            it '<ParameterName> accepts value from the pipeline is <ValueFromPipelineByPropertyName>' -TestCases $Parameters {
                param($ParameterName, $ValueFromPipelineByPropertyName)
              
                $Command.parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $ValueFromPipelineByPropertyName
            }    
        }

    }

    Context "when 'attachments' parameter is supplied" {

        BeforeAll {
            # arrange
            $Value = 'lorem ipsum'
            $Item = New-Item -ItemType File -Path 'TestDrive:LoremIpsum.pdf' -Value $Value
            
            $Content = [System.IO.File]::ReadAllBytes($Item)
            $Encoded = [System.Convert]::ToBase64String($Content)

            $Expected = [xml]"<attachments>
                <attachment>
                    <attachmentname>LoremIpsum</attachmentname>
                    <attachmenttype>txt</attachmenttype>
                    <attachmentdata>$Encoded</attachmentdata>
                </attachment>
            </attachments>"
            Write-Host $Expected

            $Actual = $Expected | ConvertFrom-IntacctFile
        }
    
        It "has a 'Path' property" {
            $Actual.Path | Should -Be 'LoremIpsum.txt'
        }

        It "has a 'Value' property" {
            $Actual.Value | Should -Be $Content
        }

    }

}