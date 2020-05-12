# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-Object.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Get-Object.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

Describe "Get-Object" {

    Context 'Parameter validation' {
        $Command = Get-Command 'Get-Object'

        Context 'Session' {
            $ParameterName = 'Session'

            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'Object' {
            $ParameterName = 'Object'

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
            $ParameterName = 'Details'

            It "is a [switch]" {
                $Command | Should -HaveParameter $ParameterName -Type switch
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }
    }

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://xx.yy.zz'}
    $PSDefaultParameterValues['*:Session'] = $Session

    Context "Default parameters" {

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Get-Object.Default.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # Write-Debug $Content
                [xml]$Content
            }

            # act
            $Actual = Get-Object
        }

        it "configures the function element properly" {

            # assert
            #<inspect><object>*</object></inspect>
            Assert-MockCalled Send-Request -ParameterFilter {
                $inspect = ([xml]$Function).function.inspect
                $inspect.detail -eq $NULL -and
                $inspect.object -eq '*'
            }    
        }

        It "returns the expected 'type' object's properties" {
            # assert
            $Actual.typename | Should -Not -BeNullOrEmpty
            $Actual."#text" | Should -Not -BeNullOrEmpty
        }

    }

    Context "-Object" {

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Get-Object.Object.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # Write-Debug $Content
                [xml]$Content
            }

            # act
            $Actual = Get-Object -Object 'EMPLOYEE'
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

    Context "-Object AND -Details" {

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Get-Object.Object.Details.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # Write-Debug $Content
                [xml]$Content
            }

            # act
            $Actual = Get-Object -Object 'EMPLOYEE' -Details

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
