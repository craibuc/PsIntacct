# /PsIntacct/Public
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# /PsIntacct
$ModuleDirectory = Split-Path -Parent $ScriptDirectory

# /PsIntacct/Tests/Fixtures/
$FixturesDirectory = Join-Path $ModuleDirectory "/Tests/Fixtures/"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$ScriptDirectory\$sut"

Describe "Get-Dimension" {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://xx.yy.zz'}

    Context "Default" {

        BeforeEach {

            # arrange
            Mock Send-Request {
                $Fixture = 'Get-Dimension.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # Write-Debug $Content
                [xml]$Content
            }

            # act
            $Actual = Get-Dimension -Session $Session
        }

        it "configures the function element properly" {
            # assert
            # <getDimensions/>
            Assert-MockCalled Send-Request -ParameterFilter {
                $function = ([xml]$Function).function
                $function.getDimensions -ne $null
            }
        }

        it "returns the correct data elements" {
            # assert
            $Actual.objectName | Should -Not -BeNullOrEmpty
            $Actual.objectLabel | Should -Not -BeNullOrEmpty
            $Actual.termLabel | Should -Not -BeNullOrEmpty
            $Actual.userDefinedDimension | Should -Not -BeNullOrEmpty
            $Actual.enabledInGL | Should -Not -BeNullOrEmpty
        }

    }

}
