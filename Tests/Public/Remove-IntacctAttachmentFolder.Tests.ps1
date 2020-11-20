BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dependencies
    . $PrivatePath/Send-Request.ps1

    # Remove-IntacctAttachmentFolder.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Remove-IntacctAttachmentFolder.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "Remove-IntacctAttachmentFolder" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Remove-IntacctAttachmentFolder'
        } 

        $Parameters = @(
            @{
                ParameterName = 'Session'
                Type = [pscustomobject]
                Mandatory = $true
            }
            @{
                ParameterName = 'supdocname'
                Type = [string]
                Mandatory = $true
            }
        ) 

        Context "Type" {
            It "<ParameterName> is a <Type>" -TestCases $Parameters {
                param ($ParameterName, $Type)
                $Command | Should -HaveParameter $ParameterName -Type $Type
            }    
        }

        Context "Mandatory" {
            It "<ParameterName> is <Mandatory>" -TestCases $Parameters {
                param ($ParameterName, $Mandatory)
                if ($Mandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
                else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
            }    
        }

    } # /Contect - parameter validation

    Context "when 'Session' and 'supdocname' supplied" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}        
        }

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Delete-AttachmentFolder.Response.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # # Write-Debug $Content
                # [xml]$Content    

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }
            
            $supdocname = 'MyFolder'

            # act
            Remove-IntacctAttachmentFolder -Session $Session -supdocname $supdocname
        }

        it "adds the 'delete_supdocfolder' element" {
            # assert
            # <function controlid='$Guid'><delete_supdocfolder key='$supdocname'/></function>
            Assert-MockCalled Send-Request -ParameterFilter {
                $verb = ([xml]$Function).function
                $verb.ChildNodes[0].Name -eq 'delete_supdocfolder'
            }    
        }

        it "configures the function element properly" {
            # assert
            # <function controlid='$Guid'><delete_supdocfolder key='$supdocname'/></function>
            Assert-MockCalled Send-Request -ParameterFilter {
                $verb = ([xml]$Function).function.delete_supdocfolder
                $verb.key -eq $supdocname
            }    
        }

    }

} # /Describe
