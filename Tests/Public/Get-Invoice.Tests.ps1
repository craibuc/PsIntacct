# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-Dimension.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Get-Dimension.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

Describe "Get-Invoice" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

    Context "Invoice exists" {

        # arrange
        $Id = 1320
        $Number = 'INV-000722'

        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='arinvoice' count='1'>
                            <arinvoice>
                                <RECORDNO>$Id</RECORDNO>
                                <RECORDID>$Number</RECORDID>
                            </arinvoice>
                        </data>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content

        }

        Context "-Id" {

            # act
            $Actual = Get-Invoice -Session $Session -Id $Id

            it "configures the function element properly" {
                
                # <function controlid='$Guid'><read><object>ARINVOICE</object><keys>$Id</keys><fields>*</fields></read></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.read
                    $verb.object -eq 'ARINVOICE' -and
                    $verb.keys -eq $Id -and
                    $verb.fields -eq '*'
                }    
            }

            it "returns the correct RECORDNO" {
                # assert
                $Actual.RECORDNO | Should -Be $Id
            }

        }

        Context "-Number" {

            # act
            $Actual = Get-Invoice -Session $Session -Number $Number

            it "configures the function element properly" {
                
                # <function controlid='$Guid'><readByQuery><object>ARINVOICE</object><keys>$Number</keys><fields>*</fields></readByQuery><pagesize>100</pagesize></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.readByQuery
                    $verb.object -eq 'ARINVOICE' -and
                    $verb.query -eq "RECORDID='$Number'" -and
                    $verb.fields -eq '*' -and
                    $verb.pagesize -eq 100
                }    
            }

            It "returns the specified invoice" {
                # assert
                $Actual.RECORDID | Should -Be $Number
            }    
        }

    }

    Context "Invoice not exists" {

        # arrange
        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='ARINVOICE' count='0'/>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content
    
        }

        Context "-ID" {
            it "writes an non-terminating error that indicates that the invoice was not found, including the id" {
                # act / assert
                {Get-Invoice -Session $Session -Id 1000 -ErrorAction Stop } | Should -Throw "Invoice 1000 not found"
            }
        }

        Context "-Name" {
            it "writes an non-terminating error that indicates that the invoice was not found, including the name" {
            # act / assert
            {Get-Invoice -Session $Session -Number 'INV-XXXXX' -ErrorAction Stop } | Should -Throw "Invoice 'INV-XXXXX' not found"
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
            {Get-Invoice -Session $Session -Number 'XXXXXX' -ErrorAction Stop } | Should -Throw "There was an error processing the request."
        }
    }

}
