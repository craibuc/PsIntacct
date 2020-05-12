# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-User.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Get-User.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

Describe "Get-User" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://xxx.yyy.zzz'}

    Context "User exists" {

        $Id = 29
        $Name = 'blumbergh'

        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='USERINFO' count='1'>
                            <USERINFO>
                                <RECORDNO>$Id</RECORDNO>
                                <LOGINID>$Name</LOGINID>
                            </USERINFO>
                        </data>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content

        }

        Context "-ID" {

            # act
            $Actual = Get-User -Session $Session -Id $Id

            it "configures the function element properly" {
                
                # <function controlid='$Guid'><read><object>USERINFO</object><keys>$Id</keys><fields>*</fields></read></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.read
                    $verb.object -eq 'USERINFO' -and
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
            $Actual = Get-User -Session $Session -Name $Name

            it "configures the function element properly" {

                # <function controlid='$Guid'><readByName><object>USERINFO</object><keys>$Name</keys><fields>*</fields></readByName></function>

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.readByName
                    $verb.object -eq 'USERINFO' -and
                    $verb.keys -eq $Name -and
                    $verb.fields -eq '*'
                }    
            }

            it "returns the correct LOGINID" {
                # assert
                $Actual.LOGINID | Should -Be $Name
            }

        }


    } # / User exists

    Context "User not exists" {

        # arrange
        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data listtype='USERINFO' count='0'/>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content
    
        }

        Context "-ID" {
            it "writes an non-terminating error that indicates that the user was not found, including the id" {
                # act / assert
                {Get-User -Session $Session -Id 1000 -ErrorAction Stop } | Should -Throw "User 1000 not found"
            }
        }

        Context "-Name" {
            it "writes an non-terminating error that indicates that the user was not found, including the name" {
            # act / assert
            {Get-User -Session $Session -Name 'dummy' -ErrorAction Stop } | Should -Throw "User 'dummy' not found"
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
            {Get-User -Session $Session -Name 'dummy' -ErrorAction Stop } | Should -Throw "There was an error processing the request."
        }
    }

}