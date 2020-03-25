$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
Import-Module "$Parent\PsIntacct.psm1" -Force #-Verbose

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "New-StatisticalAccount" -Tag 'integration' {

    # arrange

    # assumes that a credential file exists in PsIntacct\Credential.User.xml
    $UserCredential = Convert-Path "$Parent\Credential.User.xml" | Import-Clixml
    $CompanyId = $UserCredential.Company 

    # assumes that a credential file exists in PsIntacct\Credential.Sender.xml
    $SenderCredential = Convert-Path "$Parent\Credential.Sender.xml" | Import-Clixml

    $Session = New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId
    
    Write-Host $Session.Credential.UserName
    Write-Host $Session.sessionid
    Write-Host $Session.endpoint

    $data = @()
    $Data += [PSCustomObject]@{
        ACCOUNTNO=8028
        TITLE='8028'
    }
    $Data += [PSCustomObject]@{
        ACCOUNTNO=8029
        TITLE='8029'
    }

    $Results = $Data | New-StatisticalAccount -Session $Session
    $Results

}