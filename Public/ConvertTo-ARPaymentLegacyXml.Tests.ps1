$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-ARPaymentLegacyXml" -Tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command "ConvertTo-ARPaymentLegacyXml"

        Context "verb" {
            $ParameterName = 'verb'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            it "has a list of valid values"{
                $Command.Parameters[$ParameterName].attributes.ValidValues | Should -Be @('create','apply','reverse')
            }

        }

        Context "customerid" {
            $ParameterName = 'customerid'
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "paymentamount" {
            $ParameterName = 'paymentamount'
            It "is a [decimal]" {
                $Command | Should -HaveParameter $ParameterName -Type decimal
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "translatedamount" {
            $ParameterName = 'translatedamount'
            It "is a [decimal]" {
                $Command | Should -HaveParameter $ParameterName -Type decimal
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "batchkey" {
            $ParameterName = 'batchkey'
            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "bankaccountid" {
            $ParameterName = 'bankaccountid'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "has an alias of 'FINANCIALENTITY'" {
                $Command.Parameters[$ParameterName].Aliases | Should -Contain 'FINANCIALENTITY'
            }
        }

        Context "undepfundsacct" {
            $ParameterName = 'undepfundsacct'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "has an alias of 'UNDEPOSITEDACCOUNTNO'" {
                $Command.Parameters[$ParameterName].Aliases | Should -Contain 'UNDEPOSITEDACCOUNTNO'
            }
        }

        Context "refid" {
            $ParameterName = 'refid'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "has an alias of 'DOCNUMBER'" {
                $Command.Parameters[$ParameterName].Aliases | Should -Contain 'DOCNUMBER'
            }
        }

        Context "overpaylocid" {
            $ParameterName = 'overpaylocid'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "overpaydeptid" {
            $ParameterName = 'overpaydeptid'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "datereceived" {
            $ParameterName = 'datereceived'
            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "has an alias of 'RECEIPTDATE'" {
                $Command.Parameters[$ParameterName].Aliases | Should -Contain 'RECEIPTDATE'
            }
        }

        Context "paymentmethod" {
            $ParameterName = 'paymentmethod'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "basecurr" {
            $ParameterName = 'basecurr'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "currency" {
            $ParameterName = 'currency'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "exchratedate" {
            $ParameterName = 'exchratedate'
            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "exchratetype" {
            $ParameterName = 'exchratetype'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "exchrate" {
            $ParameterName = 'exchrate'
            It "is a [decimal]" {
                $Command | Should -HaveParameter $ParameterName -Type decimal
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "cctype" {
            $ParameterName = 'cctype'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "authcode" {
            $ParameterName = 'authcode'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "arpaymentitem" {
            $ParameterName = 'arpaymentitem'
            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject[]
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "has an alias of 'ARPYMTDETAILS'" {
                $Command.Parameters[$ParameterName].Aliases | Should -Contain 'ARPYMTDETAILS'
            }
        }

        Context "onlinecardpayment" {
            $ParameterName = 'onlinecardpayment'
            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "onlineachpayment" {
            $ParameterName = 'onlineachpayment'
            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

    }

    # arrange
    $Payment = [pscustomobject]@{
        customerid=6
        paymentamount=100.00
    }

    Context "Required fields" {

        it "returns the expected values" {
            # act
            $Actual = $Payment | ConvertTo-ARPaymentLegacyXml -Verb 'create'

            # assert
            $Actual.create_arpayment.customerid | Should -Be $Payment.customerid
            $Actual.create_arpayment.paymentamount | Should -Be $Payment.paymentamount
        }

    }

    Context "Optional fields" {

        $Payment | Add-Member -MemberType NoteProperty -Name 'translatedamount' -Value 200.00
        $Payment | Add-Member -MemberType NoteProperty -Name 'batchkey' -Value 100
        $Payment | Add-Member -MemberType NoteProperty -Name 'bankaccountid' -Value 'abc'
        $Payment | Add-Member -MemberType NoteProperty -Name 'undepfundsacct' -Value 'def'
        $Payment | Add-Member -MemberType NoteProperty -Name 'refid' -Value '123'
        $Payment | Add-Member -MemberType NoteProperty -Name 'overpaylocid' -Value '345'
        $Payment | Add-Member -MemberType NoteProperty -Name 'overpaydeptid' -Value '456'
        $Payment | Add-Member -MemberType NoteProperty -Name 'datereceived' -Value '03/23/2020'
        $Payment | Add-Member -MemberType NoteProperty -Name 'paymentmethod' -Value 'foo'
        $Payment | Add-Member -MemberType NoteProperty -Name 'basecurr' -Value 'usd'
        $Payment | Add-Member -MemberType NoteProperty -Name 'currency' -Value 'usd'
        $Payment | Add-Member -MemberType NoteProperty -Name 'exchratedate' -Value '03/23/2020'
        $Payment | Add-Member -MemberType NoteProperty -Name 'exchratetype' -Value 'foo'
        $Payment | Add-Member -MemberType NoteProperty -Name 'exchrate' -Value 1.0
        $Payment | Add-Member -MemberType NoteProperty -Name 'cctype' -Value 'abc'
        $Payment | Add-Member -MemberType NoteProperty -Name 'authcode' -Value 'abc123'
        $Payment | Add-Member -MemberType NoteProperty -Name 'arpaymentitem' -Value 111
        $Payment | Add-Member -MemberType NoteProperty -Name 'onlinecardpayment' -Value 111
        $Payment | Add-Member -MemberType NoteProperty -Name 'onlineachpayment' -Value 111

        it "returns the expected values" {
            # act
            $Actual = $Payment | ConvertTo-ARPaymentLegacyXml -Verb 'create'

            # assert
            $Actual.create_arpayment.translatedamount | Should -Be $Payment.translatedamount
            $Actual.create_arpayment.batchkey | Should -Be $Payment.batchkey
            $Actual.create_arpayment.bankaccountid | Should -Be $Payment.bankaccountid
            $Actual.create_arpayment.undepfundsacct | Should -Be $Payment.undepfundsacct
            $Actual.create_arpayment.refid | Should -Be $Payment.refid
            $Actual.create_arpayment.overpaylocid | Should -Be $Payment.overpaylocid
            $Actual.create_arpayment.overpaydeptid | Should -Be $Payment.overpaydeptid
            $Actual.create_arpayment.datereceived.year | Should -Be ([datetime]$Payment.datereceived).ToString('yyyy')
            $Actual.create_arpayment.datereceived.month | Should -Be ([datetime]$Payment.datereceived).ToString('MM')
            $Actual.create_arpayment.datereceived.day | Should -Be ([datetime]$Payment.datereceived).ToString('dd')
            $Actual.create_arpayment.paymentmethod | Should -Be $Payment.paymentmethod
            $Actual.create_arpayment.basecurr | Should -Be $Payment.basecurr
            $Actual.create_arpayment.currency | Should -Be $Payment.currency
            $Actual.create_arpayment.exchratedate.year | Should -Be ([datetime]$Payment.exchratedate).ToString('yyyy')
            $Actual.create_arpayment.exchratedate.month | Should -Be ([datetime]$Payment.exchratedate).ToString('MM')
            $Actual.create_arpayment.exchratedate.day | Should -Be ([datetime]$Payment.exchratedate).ToString('dd')
            $Actual.create_arpayment.exchratetype | Should -Be $Payment.exchratetype
            $Actual.create_arpayment.exchrate | Should -Be $Payment.exchrate
            $Actual.create_arpayment.cctype | Should -Be $Payment.cctype
            $Actual.create_arpayment.authcode | Should -Be $Payment.authcode
            $Actual.create_arpayment.arpaymentitem | Should -Be $Payment.arpaymentitem
            $Actual.create_arpayment.onlinecardpayment | Should -Be $Payment.onlinecardpayment
            $Actual.create_arpayment.onlineachpayment | Should -Be $Payment.onlineachpayment
        }

    }

}
