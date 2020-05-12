# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-Dimension.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Get-Dimension.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

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
