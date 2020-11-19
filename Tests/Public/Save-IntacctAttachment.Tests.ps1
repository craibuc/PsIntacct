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

    # Save-IntacctAttachment.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Save-IntacctAttachment.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "Save-IntacctAttachment" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Save-IntacctAttachment'
        } 

        $Parameters = @(
            @{
                ParameterName = 'Session'
                Type = [pscustomobject]
                ParameterSets = @(
                    @{ParameterSetName='Create';Mandatory=$true}
                    @{ParameterSetName='Update';Mandatory=$false}
                )
            }
            @{
                ParameterName = 'supdocid'
                Type = [string]
                ParameterSets = @(
                    @{ParameterSetName='Update';Mandatory=$true}
                )
            }
            @{
                ParameterName = 'supdocname'
                Type = [string]
                ParameterSets = @(
                    @{ParameterSetName='Create';Mandatory=$true}
                    @{ParameterSetName='Update';Mandatory=$false}
                )
            }
            @{
                ParameterName = 'supdocfoldername'
                Type = [string]
                Alias = 'folder'
                ParameterSets = @(
                    @{ParameterSetName='Create';Mandatory=$true}
                    @{ParameterSetName='Update';Mandatory=$false}
                )
            }
            @{
                ParameterName = 'supdocdescription'
                Type = [string]
                Alias = 'description'
                ParameterSets = @(
                    @{ParameterSetName='Create';Mandatory=$false}
                    @{ParameterSetName='Update';Mandatory=$false}
                )
            }
            @{
                ParameterName = 'attachments'
                Type = [object]
                ParameterSets = @(
                    @{ParameterSetName='Create';Mandatory=$false}
                    @{ParameterSetName='Update';Mandatory=$true}
                )
            }
        ) | ForEach-Object {

            $Parameter = $_

            It "<ParameterName> is a <Type>" -TestCases $Parameter {
                param ($ParameterName, $Type)
                $Command | Should -HaveParameter $ParameterName -Type $Type
            }

            $_.ParameterSets | ForEach-Object {

                $Case = @{
                    ParameterName = $Parameter.ParameterName
                }
                $Case += $_

                It "<ParameterName> is $( $_.Mandatory ? 'a mandatory': 'an optional') member of <ParameterSetName>" -TestCases $Case {
                    param ($ParameterName,$ParameterSetName,$Mandatory)
                    $Command.Parameters[$ParameterName].ParameterSets[$ParameterSetName].IsMandatory -eq $Mandatory
                }
    
            }
    
        }

    } # /Contect - parameter validation

    Context "Usage" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}        
        }

        Context "Create" {
            BeforeAll {
                $IntacctAttachment = @{
                    supdocname = 'supdocname'
                    supdocfoldername = 'supdocfoldername'
                }
            }

            BeforeEach {
                Mock Send-Request {
                    $Fixture = 'Create-Attachment.Response.xml'
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
                    [pscustomobject]$IntacctAttachment | Save-IntacctAttachment -Session $Session
                }

                it "DOES NOT populate the 'supdocid' property" {
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.create_supdoc
                        $verb.supdocid -eq ''
                    }
                }

                it "populates the 'supdocname' property" {
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.create_supdoc
                        $verb.supdocname -eq 'supdocname'
                    }    
                }
    
                it "populates the 'supdocfoldername' property" {
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.create_supdoc
                        $verb.supdocfoldername -eq 'supdocfoldername'
                    }    
                }
    
            }
    
            Context "Optional parameters" {

                BeforeAll {
                    $IntacctAttachment.Add('supdocdescription','supdocdescription')

                    # file attachment
                    $Content = 'Minus dolores ut quis adipisci. Voluptas mollitia impedit voluptatem. Quisquam ut soluta corrupti vel optio optio molestiae voluptate. Repudiandae commodi in ut.'
                    $File = New-Item -ItemType File -Path "TestDrive:Lorem.pdf" -Value $Content
                    $attachments = $File | ConvertTo-IntacctFile
                    $IntacctAttachment.Add('attachments',$attachments)
                }

                BeforeEach {
                    [pscustomobject]$IntacctAttachment | Save-IntacctAttachment -Session $Session
                }

                it "populates the 'supdocdescription' property" {
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.create_supdoc
                        $verb.supdocdescription -eq 'supdocdescription'
                    }
                }

                it "populates the 'attachments' property" {
                    # arrange

                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.create_supdoc
                        $verb.attachments.attachment.attachmentname -eq 'Lorem'
                    }
                }

            }

            Context "Parameter aliases" {

                BeforeAll {
                    $IntacctAttachment.Remove('supdocfoldername')
                    $IntacctAttachment.Add('folder','supdocfoldername')

                    $IntacctAttachment.Remove('supdocdescription')
                    $IntacctAttachment.Add('description','supdocdescription')
                }

                BeforeEach {
                    [pscustomobject]$IntacctAttachment | Save-IntacctAttachment -Session $Session
                }

                it "populates the 'supdocfoldername' property" {
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.create_supdoc
                        $verb.supdocfoldername -eq 'supdocfoldername'
                    }    
                }

                it "populates the 'supdocfoldername' property" {
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.create_supdoc
                        $verb.supdocfoldername -eq 'supdocfoldername'
                    }    
                }

            }

        } # /Create

        Context "Update" {

            BeforeAll {
                $IntacctAttachment = @{
                    supdocid = 'supdocid'
                }
            }

            BeforeEach {
                Mock Send-Request {
                    $Fixture = 'Update-Attachment.Response.xml'
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
                    [pscustomobject]$IntacctAttachment | Save-IntacctAttachment -Session $Session
                }

                it "populates the 'supdocid' property" {
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function.update_supdoc
                        $verb.supdocid -eq 'supdocid'
                    }
                }
    
                Context "Optional parameters" {

                    BeforeAll {
                        $IntacctAttachment.Add('supdocname','supdocname')
                        $IntacctAttachment.Add('supdocfoldername','supdocfoldername')
                        $IntacctAttachment.Add('supdocdescription','supdocdescription')
                    }
    
                    BeforeEach {
                        [pscustomobject]$IntacctAttachment | Save-IntacctAttachment -Session $Session
                    }
    
                    it "populates the 'supdocname' property" {
                        # assert
                        Should -Invoke Send-Request -ParameterFilter {
                            $verb = ([xml]$Function).function.update_supdoc
                            $verb.supdocname -eq 'supdocname'
                        }    
                    }

                    it "populates the 'supdocfoldername' property" {
                        # assert
                        Should -Invoke Send-Request -ParameterFilter {
                            $verb = ([xml]$Function).function.update_supdoc
                            $verb.supdocfoldername -eq 'supdocfoldername'
                        }    
                    }

                    it "populates the 'supdocdescription' property" {
                        # assert
                        Should -Invoke Send-Request -ParameterFilter {
                            $verb = ([xml]$Function).function.update_supdoc
                            $verb.supdocdescription -eq 'supdocdescription'
                        }    
                    }
    
                }

            }

        } # /Update

    } # /Usage

} # /Describe