$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-Dimension" {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://xx.yy.zz'}

    Context "Default" {

        BeforeEach {
            # arrange
            Mock Send-Request {

                $Content = 
                "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <control><status>success</status></control>
                    <operation>
                        <result>
                            <status>success</status>
                            <data listtype='arinvoice' count='1'>
                                <dimensions>
                                    <dimension>
                                        <objectName>DEPARTMENT</objectName>
                                        <objectLabel>Department</objectLabel>
                                        <termLabel>Department</termLabel>
                                        <userDefinedDimension>false</userDefinedDimension>
                                        <enabledInGL>true</enabledInGL>
                                    </dimension>
                                </dimensions>
                            </data>
                        </result>
                    </operation>
                </response>"
                # Write-Debug $Content
                [xml]$Content

            }

            # act
            $Actual = Get-Dimension -Session $Session
        }

        it "configures the function element properly" {
            
            # <function controlid='$Guid'><getDimensions/></function>

            # assert
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
