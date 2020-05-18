# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# New-Invoice.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/New-Invoice.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

Describe "New-Invoice" -tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command 'New-Invoice'

        Context "Session" {
            $ParameterName='Session'
            it "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }
        Context "InvoiceXml" {
            $ParameterName='InvoiceXml'
            it "is [xml]" {
                $Command | Should -HaveParameter $ParameterName -Type xml
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }
    }

    Context "Usage" {

        # arrange
        $Credential = New-MockObject -Type PsCredential

        $Expected = @{
            Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}
            Invoice = [pscustomobject]@{
                customerid='CUSTOMER1'
                datecreated= '06/30/2015'
                datedue= '07/31/2015'
                termname='Net 30'
                InvoiceItems=@([pscustomobject]@{
                    glaccountno='93590253'
                    amount=76343.43
                })
            }
        }

        Mock Send-Request

        it "calls Send-Request with the expected parameter values" {
            # act
            $Expected.Invoice | ConvertTo-InvoiceXml | New-Invoice -Session $Expected.Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $Session -eq $Expected.Session
            }

        }

    } # /context

}