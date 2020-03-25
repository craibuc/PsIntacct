$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-ARPaymentLegacyXml" -Tag 'unit' {

    # arrange
    $Payment = [pscustomobject]@{
        customerid=6
        paymentamount=100.00
    }

    Context "Required fields" {

        it "has 2, mandatory parameters" {
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter customerid -Mandatory -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter paymentamount -Mandatory -Type decimal
        }

        it "returns the expected values" {
            # act
            $Actual = $Payment | ConvertTo-ARPaymentLegacyXml -Verb 'create'

            # assert
            $Actual.create_arpayment.customerid | Should -Be $Payment.customerid
            $Actual.create_arpayment.paymentamount | Should -Be $Payment.paymentamount
        }

    }

    Context "Optional fields" {

        it "has 2, mandatory parameters" {
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter translatedamount -Type decimal
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter batchkey -Type int
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter bankaccountid -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter undepfundsacct -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter refid -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter overpaylocid -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter overpaydeptid -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter datereceived -Type datetime
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter paymentmethod -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter basecurr -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter currency -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter exchratedate -Type datetime
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter exchratetype -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter exchrate -Type decimal
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter cctype -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter authcode -Type string
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter arpaymentitem -Type pscustomobject[]
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter onlinecardpayment -Type pscustomobject
            Get-Command "ConvertTo-ARPaymentLegacyXml" | Should -HaveParameter onlineachpayment -Type pscustomobject
        }

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
        # $Payment | Add-Member -MemberType NoteProperty -Name 'arpaymentitem' -Value 111
        # $Payment | Add-Member -MemberType NoteProperty -Name 'onlinecardpayment' -Value 111
        # $Payment | Add-Member -MemberType NoteProperty -Name 'onlineachpayment' -Value 111

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
