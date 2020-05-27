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
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "ARPaymentXml" {
            $ParameterName='ARPaymentXml'
            it "is a [xml]" {
                $Command | Should -HaveParameter $ParameterName -Type xml
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "ARPaymentXml" {
            $ParameterName='Legacy'
            it "is a [xml]" {
                $Command | Should -HaveParameter $ParameterName -Type switch
            }
        }
    } # /context (parameter validation)

    Context "Default parameter values" {

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

    Context "-Legacy" {

        # arrange
        $Credential = New-MockObject -Type PsCredential

        $Expected = @{
            Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}
            Payment = [pscustomobject]@{
                undepfundsacct='0123456789'
                paymentmethod='Cash'
                paymentamount=100.00
                customerid='ABC'
                datereceived='02/20/2020'
                refid='XXXX'
                arpaymentitem = @( [pscustomobject]@{invoicekey=123; amount=100.00} )
            }
        }

        Mock Send-Request

        it "calls Send-Request with the expected parameter values" {
            # act
            $Expected.Payment | ConvertTo-ARPaymentLegacyXml | New-ARPayment -Session $Expected.Session -Legacy

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $Session -eq $Expected.Session -and
                ([xml]$Function).function.create_arpayment -ne $null
            }
        }

    } # /context

}
