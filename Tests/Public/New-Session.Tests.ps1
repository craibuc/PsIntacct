# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# New-Session.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/New-Session.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")
. (Join-Path $PrivatePath "ConvertTo-PlainText.ps1")

Describe "New-Session" -Tag 'unit' {

    # arrange
    $SenderCredential = New-MockObject -Type PsCredential

    $UserCredential = New-MockObject -Type PsCredential
    $CompanyId = 'Acme'

    Context "Valid credentials" {

        Mock Send-Request {

            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control><status>success</status></control>
                <operation>
                    <result>
                        <status>success</status>
                        <data>
                            <api>
                                <sessionid>FsuajisBmWv7EaGbXZ_Ckwc8a-oRoQ..</sessionid>
                                <endpoint>https://api.intacct.com/ia/xml/xmlgw.phtml</endpoint>
                                <locationid></locationid>
                            </api>
                        </data>
                    </result>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content
        }

        # act
        $Actual = New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId

        it "calls Send-Request with the correct parameters" {
            # assert
            Assert-MockCalled Send-Request -ParameterFilter { $Credential -eq $SenderCredential }
            Assert-MockCalled Send-Request -ParameterFilter { $Login -eq $UserCredential }
            Assert-MockCalled Send-Request -ParameterFilter { $CompanyId }
            # <function controlid='$Guid'><getAPISession/></function>
            Assert-MockCalled Send-Request -ParameterFilter {
                $xml = ([xml]$Function).function
                $xml.getAPISession -ne $null
            }    
        }

        It "creates a object with a sessionid and endpoint" {
            # assert
            $Actual.Credential | Should -Be $SenderCredential
            $Actual.sessionid | Should -Not -BeNullOrEmpty
            $Actual.endpoint | Should -Not -BeNullOrEmpty
        }

    }

    Context "Invalid Sender credentials" {

        # arrange
        Mock Send-Request {

            $Content = 
            "<?xml version=11.01 encoding=1UTF-81?>
            <response>
                <control>
                    <status>failure</status>
                    <senderid>lorenzbus</senderid>
                    <controlid>1582314102</controlid>
                    <uniqueid>false</uniqueid>
                    <dtdversion>3.0</dtdversion>
                </control>
                <errormessage>
                    <error>
                        <errorno>XL03000006</errorno>
                        <description></description>
                        <description2>Incorrect Intacct XML Partner ID or password.</description2>
                        <correction></correction>
                    </error>
                </errormessage>
            </response>"
            # Write-Debug $Content
            [xml]$Content
    
        }

        It "throws an exception" {
            # act / assert
            { New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId -ErrorAction Stop } | Should -Throw "Incorrect Intacct XML Partner ID or password."
        }
    }

    Context "Invalid User credentials" {

        # arrange
        Mock Send-Request {

            $Content=
            "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <control>
                    <status>success</status>
                    <senderid>lorenzbus</senderid>
                    <controlid>1582314481</controlid>
                    <uniqueid>false</uniqueid>
                    <dtdversion>3.0</dtdversion>
                </control>
                <operation>
                    <authentication>
                        <status>failure</status>
                        <userid>craig.buchanan</userid>
                        <companyid>lorenzbus-DEV</companyid>
                        <locationid></locationid>
                    </authentication>
                    <errormessage>
                        <error>
                            <errorno>XL03000006</errorno>
                            <description></description>
                            <description2>Sign-in information is incorrect</description2>
                            <correction></correction>
                        </error>
                    </errormessage>
                </operation>
            </response>"
            # Write-Debug $Content
            [xml]$Content

        }

        It "throws an exception" {
            # act / assert
            { New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId -ErrorAction Stop } | Should -Throw "Sign-in information is incorrect"
        }

    }

    Context "Invalid User credentials (401)" {

        Mock Invoke-WebRequest { 
            $Response = New-Object System.Net.Http.HttpResponseMessage 401
            $Phrase = 'Response status code does not indicate success: 401 (Unauthorized).'
            Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
        }

        # Mock Send-Request {
        #     $Content = "<?xml version='1.0' encoding='UTF-8'?>
        #     <response>
        #         <control>
        #             <status>failure</status>
        #         </control>
        #         <errormessage>
        #             <error>
        #                 <errorno>XMLGW_JPP0002</errorno>
        #                 <description>Sign-in information is incorrect. Please check your request.</description>
        #             </error>
        #         </errormessage>
        #     </response>"
        #     # Write-Debug $Content
        #     [xml]$Content
        # }

        It "throws an exception" {
            # arrange
            $Message = 'Unauthorized [401]'
            # $Message = 'Response status code does not indicate success: 401 (Unauthorized).'

            # act / assert
            { New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId -ErrorAction Stop } | Should -Throw $Message
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
            { New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId -ErrorAction Stop } | Should -Throw "There was an error processing the request."
        }
    }

}