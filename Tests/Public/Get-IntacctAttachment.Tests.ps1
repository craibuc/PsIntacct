BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsIntacct/PsIntacct/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"

    # /PsIntacct/PsIntacct/Private
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

    # /PsIntacct/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dependencies
    . $PrivatePath/Send-Request.ps1
    . $PrivatePath/ConvertTo-PlainText.ps1

    # Get-IntacctAttachment.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Get-IntacctAttachment.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "Get-IntacctAttachment" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-IntacctAttachment'
        } 

        $Parameters = @(
            @{
                ParameterName = 'Session'
                Type = [pscustomobject]
                ParameterSets = @(
                    @{ParameterSetName='All';Mandatory=$true}
                    @{ParameterSetName='ById';Mandatory=$true}
                )
            }
            # @{
            #     ParameterName = 'start'
            #     Type = [int]
            #     ParameterSets = @(
            #         @{ParameterSetName='All';Mandatory=$true}
            #     )
            # }
            # @{
            #     ParameterName = 'maxitems'
            #     Type = [int]
            #     Mandatory = $false
            # }
            # @{
            #     ParameterName = 'showprivate'
            #     Type = [bool]
            #     Mandatory = $false
            # }
            # @{
            #     ParameterName = 'filter'
            #     Type = [object[]]
            #     Mandatory = $false
            # }
            # @{
            #     ParameterName = 'sorts'
            #     Type = [object[]]
            #     Mandatory = $false
            # }
            @{
                ParameterName = 'supdocid'
                Type = [string]
                ParameterSets = @(
                    @{ParameterSetName='ById';Mandatory=$true}
                )
            }
            @{
                ParameterName = 'Fields'
                Type = [string[]]
                ParameterSets = @(
                    @{ParameterSetName='All';Mandatory=$true}
                    @{ParameterSetName='ById';Mandatory=$false}
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
                    param ($ParameterName, $ParameterSetName, $Mandatory)
                    $Command.Parameters[$ParameterName].ParameterSets[$ParameterSetName].IsMandatory -eq $Mandatory
                }
    
            }
    
        }

    } # /Contect - parameter validation

    Context "when 'Session' is supplied" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}        
        }

        BeforeEach {
    
            Mock Send-Request {
                $Fixture = 'Get-Attachment.Response.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # # Write-Debug $Content
                # [xml]$Content    

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }
        }

        it "adds the 'get_list' element" {
            # act
            $Actual = Get-IntacctAttachment -Session $Session

            # assert
            # <function controlid='$Guid'><get_list object="supdoc"></get_list></function>
            Assert-MockCalled Send-Request -ParameterFilter {
                $verb = ([xml]$Function).function
                $verb.ChildNodes[0].Name -eq 'get_list'
            }    
        }

        # Context "when 'start' is supplied" {
        #     it "adds the 'start' attribute" {
        #         # act
        #         $Actual = Get-IntacctAttachment -Session $Session -start 1

        #         # assert
        #         # <function controlid='$Guid'><get_list object="supdoc" start='0'></get_list></function>
        #         Assert-MockCalled Send-Request -ParameterFilter {
        #             $verb = ([xml]$Function).function.get_list
        #             $verb.start -eq 1
        #         }    
        #     }    
        # }

        # Context "when 'maxitems' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'showPrivate' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'filter' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'sorts' is supplied" {
        #     It "does something" {}
        # }

        Context "when 'fields' is supplied" {
            BeforeEach {
                # arrange    
                Mock Send-Request {
                    $Fixture = 'Get-Attachment.Response.xml'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                    # # Write-Debug $Content
                    # [xml]$Content    
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }

                $Fields = 'supdocid','supdocname'

                # act
                $Actual = Get-IntacctAttachment -Session $Session -fields $Fields
            }

            It "adds the 'fields' element" {
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function
                    $verb.get_list.fields.field[0] -eq $Fields[0] -and
                    $verb.get_list.fields.field[1] -eq $Fields[1]
                }
            }
        }

        Context "when 'supdocid' is supplied" {

            BeforeEach {
                # arrange
                Mock Send-Request {
                    $Fixture = 'Get-Attachment.Response.xml'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                    # # Write-Debug $Content
                    # [xml]$Content    
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }
        
                $supdocid = 'ATT-00000'
            }

            it "adds the 'get' element and 'key' attribute" {
                # act
                $Actual = Get-IntacctAttachment -Session $Session -supdocid $supdocid

                # assert
                # <function controlid='$Guid'><get object="supdoc" key="ATT-00000"></get></function>
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function
                    $verb.ChildNodes[0].Name -eq 'get' -and
                    $verb.get.key -eq $supdocid
                }
            }

            Context "when 'fields' is supplied" {

                BeforeEach {
                    # arrange
                    Mock Send-Request {
                        $Fixture = 'Get-Attachment.Response.xml'
                        $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                        # # Write-Debug $Content
                        # [xml]$Content    
        
                        $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                        $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                        $Response
                    }

                    $Fields = 'supdocid','supdocname'
                }
    
                It "adds the 'fields' element" {
                    # act
                    $Actual = Get-IntacctAttachment -Session $Session -supdocid $supdocid -fields $Fields

                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $verb = ([xml]$Function).function
                        $verb.get.fields.field[0] -eq $Fields[0] -and
                        $verb.get.fields.field[1] -eq $Fields[1]
                    }
                }

            }
    
        }

    }

} # /Describe