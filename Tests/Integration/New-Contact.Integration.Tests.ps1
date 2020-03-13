$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

function Rnd
{
    -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}

Describe "New-Contact" -Tag 'integration' {

    # assumes that a credential file exists in PsIntacct\Credential.User.xml
    $UserCredential = Convert-Path "$Parent\Credential.User.xml" | Import-Clixml

    # assumes that a credential file exists in PsIntacct\Credential.Sender.xml
    $SenderCredential = Convert-Path "$Parent\Credential.Sender.xml" | Import-Clixml

    $Session = New-Session -UserCredential $UserCredential -SenderCredential $SenderCredential

    $PSDefaultParameterValues['*:Session'] = $Session

    Context "-ContactName & -PrintAs supplied" {
        It "creates a contact" { 
            # act
            $Actual = New-Contact -ContactName 'John Doe' -PrintAs 'Doe, John'

            # assert
            $Actual.RECORDNO | Should -Not -BeNullOrEmpty
            $Actual.CUSTOMERID | Should -Not -BeNullOrEmpty
        }    
    }

    Context "-ContactName & -PrintAs supplied via pipeline" {

        $Contacts = @(
            @{ContactName="Last First [$(Rnd)]";PrintAs='Last, First'}
            @{ContactName="Last First [$(Rnd)]";PrintAs='Last, First'}
        )

        It "creates a contact" { 
            # act
            $Actual = $Contacts | New-Contact

            # assert
            $Actual.RECORDNO | Should -Not -BeNullOrEmpty
            $Actual.CUSTOMERID | Should -Not -BeNullOrEmpty
        }    
    }

}
