$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "New-Session" -Tag 'integration' {

    # arrange

    # assumes that a credential file exists in PsIntacct\Credential.User.xml
    $UserCredential = Convert-Path "$Parent\Credential.User.xml" | Import-Clixml
    # $Company = $UserCredential.Company 

    # assumes that a credential file exists in PsIntacct\Credential.Sender.xml
    $SenderCredential = Convert-Path "$Parent\Credential.Sender.xml" | Import-Clixml

    Context "Valid credential supplied" {
        It "creates a object with a sessionid and endpoint" {
            # act
            $Actual = New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential

            # assert
            $Actual.Credential | Should -Be $SenderCredential
            $Actual.sessionid | Should -Not -BeNullOrEmpty
            $Actual.endpoint | Should -Not -BeNullOrEmpty
        }
    }

    Context "Invalid Sender credential supplied" {

        $SenderCredential = $null

        It "throws an exception" {
            # act / assert
            { New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -ErrorAction Stop } | Should -Throw "Incorrect Intacct XML Partner ID or password."
        }
    }

    Context "Invalid User credential supplied" {

        $UserCredential = $null

        It "throws an exception" {
            # act / assert
            { New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -ErrorAction Stop } | Should -Throw 'Unauthorized [401]'
        }
    }

}
