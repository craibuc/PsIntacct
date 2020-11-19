BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dependencies
    . (Join-Path $PrivatePath "Send-Request.ps1")
    . (Join-Path $PrivatePath "ConvertTo-PlainText.ps1")

    # New-IntacctSession.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/New-IntacctSession.ps1
    . (Join-Path $PublicPath $sut)
}

Describe "New-IntacctSession" -Tag 'unit' {

    Context "Parameter validation" {
    }

    Context "Usage" {

        BeforeEach {
            # arrange
            Mock Send-Request {
                Mock Send-Request {
                    $Fixture = 'New-IntacctSession.Response.xml'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                    # # Write-Debug $Content
                    # [xml]$Content    
    
                    $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                    $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                    $Response
                }    
            }

            $Expected = @{
                SenderCredential = New-MockObject -Type PsCredential
                UserCredential = New-MockObject -Type PsCredential
                CompanyId = 'AcmeAnvils'    
            }

            # act
            $IntacctSession = New-IntacctSession -SenderCredential $Expected.SenderCredential -UserCredential $Expected.UserCredential -CompanyId $Expected.CompanyId

        }

        It "sets the 'Credential' parameter" {
            Should -Invoke Send-Request -ParameterFilter {
                $Credential -eq $Expected.SenderCredential
            }
        }

        It "sets the 'Login' parameter" {
            Should -Invoke Send-Request -ParameterFilter {
                $Login -eq $Expected.UserCredential
            }
        }

        It "sets the 'CompanyId' parameter" {
            Should -Invoke Send-Request -ParameterFilter {
                $CompanyId -eq $Expected.CompanyId
            }
        }

        It "sets the 'Function' parameter" {
            Should -Invoke Send-Request -ParameterFilter {
                $verb = ([xml]$Function).function
                $verb.ChildNodes[0].Name -eq 'getAPISession'
            }
        }

    }

}