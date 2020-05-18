# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-Dimension.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Get-Dimension.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")
. (Join-Path $PublicPath "ConvertTo-ARPaymentXml.ps1")
. (Join-Path $PrivatePath "ConvertTo-ARPaymentDetailXml.ps1")

Describe "New-ARPayment" -Tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command "New-ARPayment"

        Context "Session" {
            $ParameterName='Session'
            it "is a [pscustobject]" {
                Get-Command "New-ARPayment" | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "ARPaymentXml" {
            $ParameterName='ARPaymentXml'
            it "is a [xml]" {
                Get-Command "New-ARPayment" | Should -HaveParameter $ParameterName -Type xml
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }
    } # /context (parameter validation)

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Expected = @{
        Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}
        Payment = [pscustomobject]@{
            UNDEPOSITEDACCOUNTNO='0123456789'
            PAYMENTMETHOD='Cash'
            CUSTOMERID='ABC'
            RECEIPTDATE='02/20/2020'
            CURRENCY='USD'
            ARPYMTDETAILS = @( [pscustomobject]@{RECORDKEY='123'} )
        }
    }

    Context "Required parameters" {

        # arrange    
        Mock Send-Request

        it "calls Send-Request with the expected parameter values" {
            # act
            $Expected.Payment | ConvertTo-ARPaymentXml | New-ARPayment -Session $Expected.Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $Session -eq $Expected.Session -and
                ([xml]$Function).function.create -ne $null
            }
        }

    } # /context

}
