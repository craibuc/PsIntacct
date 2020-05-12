$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
