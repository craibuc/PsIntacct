$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Invoice" -Tag 'integration' {

    # assumes that a credential file exists in PsIntacct\Credential.User.xml
    $UserCredential = Convert-Path "$Parent\Credential.User.xml" | Import-Clixml

    # assumes that a credential file exists in PsIntacct\Credential.Sender.xml
    $SenderCredential = Convert-Path "$Parent\Credential.Sender.xml" | Import-Clixml

    $Session = New-Session -UserCredential $UserCredential -SenderCredential $SenderCredential

    $PSDefaultParameterValues['*:Session'] = $Session

    Context "-Id provided" {

        $Id = 1320

        It "returns the specified invoice" {
            # act
            $Actual = Get-Invoice -Id $Id

            # assert
            $Actual.RECORDNO | Should -Be $Id
        }    
    }

    Context "-Number provided" {

        $Number = 'INV-000722'

        It "returns the specified invoice" {
            # act
            $Actual = Get-Invoice -Number $Number

            # assert
            $Actual.RECORDID | Should -Be $Number
        }    
    }

}
