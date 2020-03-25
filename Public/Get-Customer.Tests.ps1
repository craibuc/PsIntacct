$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"
. "$Parent/Private/Send-Request.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-Customer" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://xx.yy.zz'}

    Context "-Number" {

        Context "Object exists" {
            # arrange
            $Number = 'CUST-00108'

            Mock Send-Request {

                $Content = "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <control><status>success</status></control>
                    <operation>
                        <result>
                            <status>success</status>
                            <data listtype='CUSTOMER' count='1'>
                                <CUSTOMER>
                                    <CUSTOMERID>$Number</CUSTOMERID>
                                </CUSTOMER>
                            </data>
                        </result>
                    </operation>
                </response>"
                # Write-Debug $Content
                [xml]$Content
            } # /mock

            # act
            $Actual = Get-Customer -Session $Session -Number $Number

            it "configures the function element properly" {
                
                # <function controlid='$Guid'><readByName><object>CUSTOMER</object><keys>$Number</keys><fields>*</fields></readByName><pagesize>100</pagesize></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.readByName
                    $verb.object -eq 'CUSTOMER' -and
                    $verb.keys -eq  $Number -and
                    $verb.fields -eq '*'
                }    
            }

            It "returns the specified invoice" {
                # assert
                $Actual.CUSTOMERID | Should -Be $Number
            }

        }
    
        Context "Object does not exist" {
            # arrange
            $Number = 'ABC-123'

            Mock Send-Request {

                $Content = "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <control><status>success</status></control>
                    <operation>
                        <result>
                            <status>success</status>
                            <data listtype='CUSTOMER' count='0'/>
                        </result>
                    </operation>
                </response>"
                # Write-Debug $Content
                [xml]$Content
            } # /mock

            # act
            $Actual = Get-Customer -Session $Session -Number $Number

            it "configures the function element properly" {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.readByName
                    $verb.object -eq 'CUSTOMER' -and
                    $verb.keys -eq  $Number -and
                    $verb.fields -eq '*'
                }    
            }

            It "returns the specified invoice" {
                # assert
                $Actual.CUSTOMERID | Should -Be $Null
            }

        }
    
    }

    Context "Pipeline" {
            # arrange
            $Customer = [pscustomobject]@{CUSTOMERID='CUST-00108'}

            Mock Send-Request {

                $Content = "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <control><status>success</status></control>
                    <operation>
                        <result>
                            <status>success</status>
                            <data listtype='CUSTOMER' count='1'>
                                <CUSTOMER>
                                    <CUSTOMERID>$($Customer.CUSTOMERID)</CUSTOMERID>
                                </CUSTOMER>
                            </data>
                        </result>
                    </operation>
                </response>"
                Write-Debug $Content
                [xml]$Content
            } # /mock

            # act
            $Actual = $Customer | Get-Customer -Session $Session

            it "configures the function element properly" {
                
                # <function controlid='$Guid'><readByName><object>CUSTOMER</object><keys>$Number</keys><fields>*</fields></readByName><pagesize>100</pagesize></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.readByName
                    $verb.object -eq 'CUSTOMER' -and
                    $verb.keys -eq $Customer.CUSTOMERID -and
                    $verb.fields -eq '*'
                }    
            }

            It "returns the specified invoice" {
                # assert
                $Actual.CUSTOMERID | Should -Be $Customer.CUSTOMERID
            }
    }

}
