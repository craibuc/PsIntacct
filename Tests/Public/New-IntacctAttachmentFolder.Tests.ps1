BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # reletive directories
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dependencies
    . $PrivatePath/Send-Request.ps1
    . $PrivatePath/ConvertTo-PlainText.ps1

    # New-IntacctAttachmentFolder.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/New-IntacctAttachmentFolder.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "New-IntacctAttachmentFolder" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'New-IntacctAttachmentFolder'
        } 

        $Parameters = @(
            @{
                ParameterName = 'Session'
                Type = [pscustomobject]
            }
            @{
                ParameterName = 'supdocfoldername'
                Type = [string]
                Alias = 'folder'
            }
            @{
                ParameterName = 'supdocfolderdescription'
                Type = [string]
                Alias = 'description'
            }
            @{
                ParameterName = 'supdocparentfoldername'
                Type = [string]
                Alias = 'parentfolder'
            }
        )

        It "<ParameterName> is a <Type>" -TestCases $Parameters {
            param ($ParameterName, $Type)
            $Command | Should -HaveParameter $ParameterName -Type $Type
        }
    
    } # /Contect - parameter validation

    Context "Usage" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

            $IntacctAttachmentFolder = @{
                supdocfoldername = 'supdocfoldername'
            }
        }

        BeforeEach {
            Mock Send-Request {
                $Fixture = 'Create-AttachmentFolder.Response.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # # Write-Debug $Content
                # [xml]$Content    

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }
        }

        Context "Mandatory parameters" {

            BeforeEach {
                [pscustomobject]$IntacctAttachmentFolder | New-IntacctAttachmentFolder -Session $Session
            }

            it "populates the 'supdocfoldername' property" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.create_supdocfolder
                    $verb.supdocfoldername -eq 'supdocfoldername'
                }    
            }

        }

        Context "Optional parameters" {

            BeforeAll {
                $IntacctAttachmentFolder.Add('supdocfolderdescription','supdocfolderdescription')
                $IntacctAttachmentFolder.Add('supdocparentfoldername','supdocparentfoldername')
            }

            BeforeEach {
                [pscustomobject]$IntacctAttachmentFolder | New-IntacctAttachmentFolder -Session $Session
            }

            it "populates the 'supdocfolderdescription' property" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.create_supdocfolder
                    $verb.supdocfolderdescription -eq 'supdocfolderdescription'
                }
            }

            it "populates the 'supdocparentfoldername' property" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.create_supdocfolder
                    $verb.supdocparentfoldername -eq 'supdocparentfoldername'
                }
            }

        }

        Context "Parameter aliases" {

            BeforeAll {
                $IntacctAttachmentFolder.Remove('supdocfoldername')
                $IntacctAttachmentFolder.Add('name','supdocfoldername')

                $IntacctAttachmentFolder.Remove('supdocfolderdescription')
                $IntacctAttachmentFolder.Add('description','supdocfolderdescription')

                $IntacctAttachmentFolder.Remove('supdocparentfoldername')
                $IntacctAttachmentFolder.Add('parentfolder','supdocparentfoldername')
            }

            BeforeEach {
                [pscustomobject]$IntacctAttachmentFolder | New-IntacctAttachmentFolder -Session $Session
            }

            it "populates the 'supdocfoldername' property" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.create_supdocfolder
                    $verb.supdocfoldername -eq 'supdocfoldername'
                }    
            }

            it "populates the 'supdocfolderdescription' property" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.create_supdocfolder
                    $verb.supdocfolderdescription -eq 'supdocfolderdescription'
                }    
            }

            it "populates the 'supdocparentfoldername' property" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.create_supdocfolder
                    $verb.supdocparentfoldername -eq 'supdocparentfoldername'
                }    
            }

        }

    } # /Usage

} # /Describe