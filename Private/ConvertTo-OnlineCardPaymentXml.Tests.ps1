$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-OnlineCardPaymentXml" {

    Context "Parameter validation" {
        $Command = Get-Command "ConvertTo-OnlineCardPaymentXml"

        Context "cardnum" {
            $ParameterName = 'cardnum'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "expirydate" {
            $ParameterName = 'expirydate'
            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "cardtype" {
            $ParameterName = 'cardtype'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "securitycode" {
            $ParameterName = 'securitycode'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "usedefaultcard" {
            $ParameterName = 'usedefaultcard'
            It "is a [bool]" {
                $Command | Should -HaveParameter $ParameterName -Type bool
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

    }

    Context "Usage" {
        # arrange
        $OnlineCardPayment = [pscustomobject]@{
            cardnum = '0123456789'
            expirydate = '4/1/2020'
            cardtype = 'AMEX'
            securitycode = '0123'
            usedefaultcard = $true
        }
    
        it "returns the expected values" {
            # act
            $Actual = $OnlineCardPayment | ConvertTo-OnlineCardPaymentXml
    
            # assert
            $Actual.onlinecardpayment.cardnum | Should -Be $OnlineCardPayment.cardnum
            $Actual.onlinecardpayment.expirydate | Should -Be ([datetime]$OnlineCardPayment.expirydate).ToString('MM/dd/yyyy')
            $Actual.onlinecardpayment.cardtype | Should -Be $OnlineCardPayment.cardtype
            $Actual.onlinecardpayment.securitycode | Should -Be $OnlineCardPayment.securitycode
            $Actual.onlinecardpayment.usedefaultcard | Should -Be $OnlineCardPayment.usedefaultcard.ToString().ToLower()
        }
    }

}
