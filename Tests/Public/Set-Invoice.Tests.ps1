# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Set-Invoice.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Set-Invoice.ps1
. (Join-Path $PublicPath $sut)

Describe "Set-Invoice" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

    $Invoice = [pscustomobject]@{
        CustomerId='CUSTOMER1'
        DateCreated= '06/30/2015'
        # InvoiceItems=@()
    }
    
    Context "Parameter validation" {

        it "has 2, mandatory parameters" {
            Get-Command "Set-Invoice" | Should -HaveParameter Session -Mandatory
            Get-Command "Set-Invoice" | Should -HaveParameter InvoiceXml -Mandatory -Type xml
        }

    }

}
