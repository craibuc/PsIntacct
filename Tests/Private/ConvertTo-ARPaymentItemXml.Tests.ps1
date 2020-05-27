# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARPaymentItemXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Private/ConvertTo-ARPaymentItemXml.ps1
. (Join-Path $PrivatePath $sut)

Describe "ConvertTo-ARPaymentItemXml" -tag 'Unit' {

    Context "Parameter validation" {
        $Command = Get-Command "ConvertTo-ARPaymentItemXml"

        Context "invoicekey" {
            $ParameterName = 'invoicekey'
            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "amount" {
            $ParameterName = 'amount'
            It "is a [decimal]" {
                $Command | Should -HaveParameter $ParameterName -Type decimal
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

    }

    Context "Usage" {
        # arrange
        $PaymentItem = [pscustomobject]@{
            invoicekey=123
            amount=123.45
        }
    
        it "returns the expected values" {
            # act
            $Actual = $PaymentItem | ConvertTo-ARPaymentItemXml
    
            # assert
            $Actual.arpaymentitems.arpaymentitem.invoicekey | Should -Be $PaymentItem.invoicekey
            $Actual.arpaymentitems.arpaymentitem.amount | Should -Be $PaymentItem.amount
        }
    }

    Context "Multiple PaymentItems" {
        # arrange
        $PaymentItem = [pscustomobject]@{
            invoicekey=100
            amount=100.00
        },
        [pscustomobject]@{
            invoicekey=200
            amount=200.00
        }
    
        it "returns the expected values" {
            # act
            $Actual = $PaymentItem | ConvertTo-ARPaymentItemXml
    
            # assert
            $Actual.arpaymentitems.arpaymentitem[0].invoicekey | Should -Be $PaymentItem[0].invoicekey
            $Actual.arpaymentitems.arpaymentitem[0].amount | Should -Be $PaymentItem[0].amount

            $Actual.arpaymentitems.arpaymentitem[1].invoicekey | Should -Be $PaymentItem[1].invoicekey
            $Actual.arpaymentitems.arpaymentitem[1].amount | Should -Be $PaymentItem[1].amount

        }
    }

}
