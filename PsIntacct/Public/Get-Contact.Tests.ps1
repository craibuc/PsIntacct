$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"
. "$Parent/Private/Send-Request.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-Contact" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

    Context "Contact exists" {
    
        # arrange
        $Id = 22
        $Name = 'Bill Lumbergh'
    
        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='CONTACT' count='1'>
                            <CONTACT>
                                <RECORDNO>$Id</RECORDNO>
                                <CONTACTNAME>$Name</CONTACTNAME>
                            </CONTACT>
                        </data>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content

        }

        Context "-ID" {

            # act
            $Actual = Get-Contact -Session $Session -Id $Id

            it "configures the function element properly" {
                
                # <function controlid='$Guid'><read><object>CONTACT</object><keys>$Id</keys><fields>*</fields></read></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.read
                    $verb.object -eq 'CONTACT' -and
                    $verb.keys -eq $Id -and
                    $verb.fields -eq '*'
                }    
            }

            it "returns the correct RECORDNO" {
                # assert
                $Actual.RECORDNO | Should -Be $Id
            }

        }

        Context "-Name" {
            
            # act
            $Actual = Get-Contact -Session $Session -Name $Name

            it "configures the function element properly" {

                # <function controlid='$Guid'><readByName><object>CONTACT</object><keys>$Name</keys><fields>*</fields></readByName></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.readByName
                    $verb.object -eq 'CONTACT' -and
                    $verb.keys -eq $Name -and
                    $verb.fields -eq '*'
                }    
            }

            it "returns the correct CONTACTNAME" {
                # assert
                $Actual.CONTACTNAME | Should -Be $Name
            }

        }

    }

    Context "Contact not exists" {

        # arrange
        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='CONTACT' count='0'/>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content
    
        }

        Context "-ID" {
            it "writes an non-terminating error that indicates that the contact was not found, including the id" {
                # act / assert
                {Get-Contact -Session $Session -Id 1000 -ErrorAction Stop } | Should -Throw "Contact 1000 not found"
            }
        }

        Context "-Name" {
            it "writes an non-terminating error that indicates that the contact was not found, including the name" {
            # act / assert
            {Get-Contact -Session $Session -Name 'dummy' -ErrorAction Stop } | Should -Throw "Contact 'dummy' not found"
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
            {Get-Contact -Session $Session -Name 'dummy' -ErrorAction Stop } | Should -Throw "There was an error processing the request."
        }
    }

}