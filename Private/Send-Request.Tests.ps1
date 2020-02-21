$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Send-Request" {
    
    # sender
    $sender_id = 'sender_id'
    $sender_password = 'sender_password'
    $SenderSecureString = ConvertTo-SecureString $sender_password -AsPlainText -Force
    $SenderCredential = New-Object System.Management.Automation.PSCredential($sender_id, $SenderSecureString)

    # user
    $userid='user_id'
    $user_password='user_password'

    $UserSecureString = ConvertTo-SecureString $user_password -AsPlainText -Force
    $UserCredential = New-Object System.Management.Automation.PSCredential($userid, $UserSecureString)
    $CompanyId = 'Acme'
    
    $Session = [PSCustomObject]@{sessionid='01324656789';endpoint='https://xxx.yyy.zzz/'}
    $Function = "<function controlid='$( New-Guid )'></function>"
    
    Context "ForLogin parameter set" {
        
        # arrange
        $Function = "<function controlid='$( New-Guid )'><getAPISession /></function>"

        Mock Invoke-WebRequest

        # act

        # Get-Command "Send-Request" | Should -HaveParameter Credential -Mandatory
        # Get-Command "Send-Request" | Should -HaveParameter Login -Mandatory
        # Get-Command "Send-Request" | Should -HaveParameter Function -Mandatory
        # Get-Command "Send-Request" | Should -Not -HaveParameter Session

        BeforeEach {
            Send-Request -Credential $SenderCredential -Login $UserCredential -CompanyId $CompanyId -Function $Function
        }
        
        it "uses the correct method, content-type, and Uri" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $ContentType -eq 'application/xml' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq 'https://api.intacct.com/ia/xml/xmlgw.phtml' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { ([xml]$Body) }
        }    

        it "-Credential creates the correct request/control elements" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $xml = ([xml]$Body).request.control
                $xml.senderid -eq $sender_id -and
                $xml.password -eq $sender_password
                $xml.uniqueid -eq 'false'
            }
        }

        it "-Login creates the correct request/operation/authentication/login elements" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $xml = ([xml]$Body).request.operation.authentication.login
                $xml.userid -eq $UserCredential.UserName -and
                $xml.password -eq $user_password -and
                $xml.companyid -eq $CompanyId
            }
        }
     
        it "-Function creates the correct requestion/operation/content/function element" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $xml = ([xml]$Body).request.operation.content
                $xml.function -ne $null
                $xml.function.getAPISession -ne $null
            }
        }

    }

    Context "ForSession parameter set" {

        Mock Invoke-WebRequest

        # act
        # Get-Command "Send-Request" | Should -HaveParameter Credential -Mandatory
        # Get-Command "Send-Request" | Should -HaveParameter Session -Mandatory
        # Get-Command "Send-Request" | Should -HaveParameter Function -Mandatory
        # Get-Command "Send-Request" | Shoul -HaveParameter Unique
        # Get-Command "Send-Request" | Should -HaveParameter Transaction
        # Get-Command "Send-Request" | Should -Not -HaveParameter Login

        BeforeEach {
            Send-Request -Credential $SenderCredential -Session $Session -Function $Function -Unique -Transaction
        }

        it "-Session creates the correct request/control/uniqueid element" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq $Session.endpoint }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $xml = ([xml]$Body).request.operation.authentication
                $xml.sessionid -eq $Session.sessionid
            }
        }

        it "-Function creates the correct requestion/operation/content/function element" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $xml = ([xml]$Body).request.operation.content
                $xml.function -ne $null
            }
        }

        it "-Unique creates the correct request/control/uniqueid element" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $xml = ([xml]$Body).request.control
                $xml.uniqueid -eq 'true'
            }
        }

        it "-Transaction creates the correct request/control/transaction element" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $xml = ([xml]$Body).request.operation
                $xml.GetAttribute('transaction') -eq 'true'
            }
        }

    }

    Context "Response" {

        # arrange
        $Function = "<function controlid='$( New-Guid )'></function>"

        Mock Invoke-WebRequest { 
            $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
            $Content =
                '<?xml version="1.0" encoding="UTF-8"?>
                <response>
                    <control><status>success</status></control>
                    <operation><result><status>success</status></result></operation>
                </response>'
            $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
            $Response
        }

        it "returns the response's Content as Xml" {
            $Actual = Send-Request -Credential $SenderCredential -Session $Session -Function $Function
            $Actual | Should -BeOfType XML
        }
    }

    Context "Exception handling" {

        Mock Invoke-WebRequest { 
            $Response = New-Object System.Net.Http.HttpResponseMessage 401
            $Phrase = 'Response status code does not indicate success: 401 (Unauthorized).'
            Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
        }

        It "generates an unauthorized (401)" {
            { Send-Request -Credential $SenderCredential -Session $Session -Function $Function -ErrorAction Stop } | Should -Throw 'Response status code does not indicate success: 401 (Unauthorized).'
        }

    }

}
