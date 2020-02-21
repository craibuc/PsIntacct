$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"
. "$Parent/Private/Send-Request.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-ArPayment" {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://xxx.yyy.zzz'}

    Context "A/R Payment exists" {

        $Id = 1

        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='ARPYMT' count='1'>
                            <ARPYMT>
                                <RECORDNO>$Id</RECORDNO>
                            </ARPYMT>
                        </data>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content

        }

        Context "-Id" {

            # act
            $Actual = Get-ArPayment -Session $Session -Id $Id

            it "configures the function element properly" {
                
                # <function controlid='$Guid'><read><object>ARPYMT</object><keys>1</keys><fields>*</fields></read></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.read
                    $verb.object -eq 'ARPYMT' -and
                    $verb.keys -eq $Id -and
                    $verb.fields -eq '*'
                }    
            }

            it "returns the correct RECORDNO" {
                # assert
                $Actual.RECORDNO | Should -Be $Id
            }

        }
    } # /context

    Context "A/R payment not exists" {

        # arrange
        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='ARPYMT' count='0'/>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content
    
        }

        Context "-Id" {
            it "writes an non-terminating error that indicates that the A/R payment was not found, including the id" {
                # act / assert
                {Get-ArPayment -Session $Session -Id 1000 -ErrorAction Stop } | Should -Throw "A/R Payment 1000 not found"
            }
        }

    }

    Context "Error encountered" {

        # arrange
        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>failure</status>
                        <errormessage>
                            <error>
                                <errorno>DL02000001</errorno>
                                <description>Error</description>
                                <description2>There was an error processing the request.</description2>
                                <correction>Do something else</correction>
                            </error>
                        </errormessage>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content
    
        }
    
        it "generates a non-terminating error" {
            # act / assert
            {Get-ArPayment -Session $Session -Id 0 -ErrorAction Stop } | Should -Throw "There was an error processing the request."
        }

    } # /context

}
