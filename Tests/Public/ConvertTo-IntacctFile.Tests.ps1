BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsIntacct/PsIntacct/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"

    # ConvertTo-IntacctFile.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/ConvertTo-IntacctFile.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "ConvertTo-IntacctFile" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'ConvertTo-IntacctFile'
        } 

        $Parameters = @(
            @{ParameterName='Path';Type=[string[]]}
        )

        Context "Type" {
            It "<ParameterName> is <Type>" -TestCases $Parameters {
                param($ParameterNam, $Type)

                $Command | Should -HaveParameter $ParameterName -Type $Type
            }
        }
    
    }

    Context "when the 'supdocid' is provided" {

        BeforeAll {
            # arrange
            $Content = 'Minus dolores ut quis adipisci. Voluptas mollitia impedit voluptatem. Quisquam ut soluta corrupti vel optio optio molestiae voluptate. Repudiandae commodi in ut.'

            $Expected = New-Item -ItemType File -Path "TestDrive:Lorem.pdf" -Value $Content

            # act
            $Actual = $Expected | ConvertTo-IntacctFile
        }

        It "populates the 'attachmentname' property" {
            # assert
            $Actual.attachments.attachment.attachmentname | Should -Be $Expected.BaseName
        }

        It "populates the 'attachmenttype' property" {
            # assert
            $Actual.attachments.attachment.attachmenttype | Should -Be $Expected.Extension.Substring(1, ($Expected.Extension.Length -1))
        }

        It "populates the 'attachmentdata' property" {
            # arrange
            $Content = [System.IO.File]::ReadAllBytes($Expected)
            $Encoded = [Convert]::ToBase64String($Content)
            # assert
            $Actual.attachments.attachment.attachmentdata | Should -Be $Encoded
        }

    }

}