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

    # Remove-IntacctAttachment.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Remove-IntacctAttachment.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "Remove-IntacctAttachment" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Remove-IntacctAttachment'
        } 

        $Parameters = @(
            @{
                ParameterName = 'Session'
                Type = [pscustomobject]
                Mandatory = $true
            }
            @{
                ParameterName = 'id'
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

    Context "when 'Session' and 'id' supplied" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}        
        }

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Delete-Attachment.Response.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # # Write-Debug $Content
                # [xml]$Content    

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }
            
            $id = 'ATT-0000'

            # act
            Remove-IntacctAttachment -Session $Session -id $id
        }

        it "configures the function element properly" {
            # assert
            # <function controlid='$Guid'><delete_supdoc key=""$id""></delete_supdoc></function>
            Assert-MockCalled Send-Request -ParameterFilter {
                $verb = ([xml]$Function).function.delete_supdoc
                $verb.key -eq $id
            }    
        }

    }

} # /Describe
