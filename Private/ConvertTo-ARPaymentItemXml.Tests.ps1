$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-ARPaymentItemXml" {

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
}
