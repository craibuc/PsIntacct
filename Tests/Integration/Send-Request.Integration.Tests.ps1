$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"
. "$Parent/Public/New-Session.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Send-Request" -tag 'integration' {
    
    # assumes that a credential file exists in PsIntacct\Credential.User.xml
    $UserCredential = Convert-Path "$Parent\Credential.User.xml" | Import-Clixml

    # assumes that a credential file exists in PsIntacct\Credential.Sender.xml
    $SenderCredential = Convert-Path "$Parent\Credential.Sender.xml" | Import-Clixml

    $Session = New-Session -UserCredential $UserCredential -SenderCredential $SenderCredential

    $PSDefaultParameterValues['*:Session'] = $Session

    Context "Invalid XML sent" {

        Mock Invoke-WebRequest { 
            $Response = New-Object System.Net.Http.HttpResponseMessage 500
            $Phrase = 'Response status code does not indicate success: 500 (Internal Server Error).'
            Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
        }

        It "generates an internal-server erroor (500)" {
            { Send-Request -Session $Session -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 500 (Internal Server Error)."
        }    
    }

    Context "Invalid credentials" {

        Mock Invoke-WebRequest { 
            $Response = New-Object System.Net.Http.HttpResponseMessage 401
            $Phrase = 'Response status code does not indicate success: 401 (Unauthorized).'
            Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
        }

        It "generates an unauthorized (401)" {
            { Send-Request -Session $Session -ErrorAction Stop } | Should -Throw 'Response status code does not indicate success: 401 (Unauthorized).'
        }    
    }

    Context "Duplicate records" {

        Mock Invoke-WebRequest { 

            $Content = `
                '<?xml version="1.0" encoding="UTF-8"?>
                <response>
                    <control>failure<status></status></control>
                    <operation>
                        <result><status>failure</status></result>
                        <errormessage>
                            <error>
                                <errorno>BL34000061</errorno>
                                <description2>Another Contact with the given value(s)   already exists</description2>
                                <correction>Use a unique value instead.</correction>
                            </error>
                            <error>
                                <errorno>BL01001973</errorno>
                                <description2>Could not create Contact record!</description2>
                                <correction></correction>
                            </error>
                        </errormessage>
                    </operation>
                </response>'
        }

        It "generates mulitple errors" -Skip {
            { Send-Request -Session $Session -ErrorAction Stop } | Should -Throw 'Response status code does not indicate success: 401 (Unauthorized).'
        }    
    }

    Context "Valid XML and function" {

        Mock Invoke-WebRequest { 
            $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
            $Content = `
                '<?xml version="1.0" encoding="UTF-8"?>
                <response>
                    <control><status>success</status></control>
                    <operation><result><status>success</status></result></operation>
                </response>'
            $Response | Add-Member -NotePropertyName Content -NotePropertyValue $Content -Force
            $Response
        }

        It "returns the reponse's Content object" {
            # act
            $Content = Send-Request -Session $Session

            # assert
            Assert-MockCalled Invoke-WebRequest
            $Content | Should -BeOfType [xml]
            $Content.response.control.status | Should -Be 'success'
            $Content.response.operation.result.status | Should -Be 'success'
        }    
    }

}
