BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dependencies
    . (Join-Path $PrivatePath "Send-Request.ps1")

    # Get-Class.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Get-Class.ps1
    . (Join-Path $PublicPath $sut)
}

Describe "Get-Class" {

    Context 'Parameter validation' {
        BeforeAll {
            $Command = Get-Command 'Get-Class'
        }

        Context 'Session' {
            BeforeAll {
                $ParameterName = 'Session'
            }

            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'Name' {
            BeforeAll {
                $ParameterName = 'Name'
            }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "has a default value of '*'" {
                $Command | Should -HaveParameter $ParameterName -DefaultValue '*'
            }
        }

        Context 'Details' {
            BeforeAll {
                $ParameterName = 'Details'
            }

            It "is a [switch]" {
                $Command | Should -HaveParameter $ParameterName -Type switch
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }
    }

    Context "Usage" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://xx.yy.zz'}
            $PSDefaultParameterValues['*:Session'] = $Session
        }

        Context "when 'Session' parameter is supplied" {

            BeforeEach {
                # arrange
                Mock Send-Request {
                    $Fixture = 'Get-Object.Default.xml'
                    $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                    # Write-Debug $Content
                    [xml]$Content
                }
    
                # act
                $Actual = Get-Class
            }
    
            it "adds the 'inspect' and 'object' elements" {
    
                # assert
                #<inspect><object>*</object></inspect>
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function
                    $verb.ChildNodes[0].Name -eq 'inspect' -and
                    $verb.inspect.detail -eq $NULL -and
                    $verb.inspect.object -eq '*'
                }    
            }
    
            It "returns the expected 'type' object's properties" {
                # assert
                $Actual.typename | Should -Not -BeNullOrEmpty
                $Actual."#text" | Should -Not -BeNullOrEmpty
            }
    
        }
    
    }

    Context "when the 'Name' parameter is supplied" {

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Get-Object.Object.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # Write-Debug $Content
                [xml]$Content
            }

            # act
            $Actual = Get-Class -Name 'EMPLOYEE'
        }

        it "configures the function element properly" {

            # assert
            # <inspect detail='0'><object>EMPLOYEE</object></inspect>
            Assert-MockCalled Send-Request -ParameterFilter {
                $inspect = ([xml]$Function).function.inspect
                $inspect.detail -eq '0' -and
                $inspect.object -eq 'EMPLOYEE'
            }
        }

        It "returns the expected 'type' object's properties" {
            # assert
            $Actual.Name | Should -Not -BeNullOrEmpty
            $Actual.Fields | Should -Not -BeNullOrEmpty
        }

    }

    Context "when the 'Name' and 'Details' parameters are supplied" {

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Get-Object.Object.Details.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # Write-Debug $Content
                [xml]$Content
            }

            # act
            $Actual = Get-Class -Name 'EMPLOYEE' -Details

        }

        it "configures the function element properly" {

            # assert
            # <inspect detail='1'><object>EMPLOYEE</object></inspect>
            Assert-MockCalled Send-Request -ParameterFilter {
                $inspect = ([xml]$Function).function.inspect
                $inspect.detail -eq '1' -and
                $inspect.object -eq 'EMPLOYEE'
            }    
        }

        It "returns the expected 'type' object's properties" {
            # assert
            $Actual.Name | Should -Not -BeNullOrEmpty
            $Actual.Attributes | Should -Not -BeNullOrEmpty
            $Actual.Fields | Should -Not -BeNullOrEmpty
        }

    }

}
