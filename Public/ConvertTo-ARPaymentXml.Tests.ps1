$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-ARPaymentXml" -Tag 'unit' {

    $Payment = [pscustomobject]@{
        PAYMENTMETHOD='Cash'
        CUSTOMERID='ABC'
        RECEIPTDATE='02/20/2020'
        CURRENCY='USD'
        ARPYMTDETAILS = @()
    }
    $Detail = [pscustomobject]@{RECORDKEY='123'}
    $Payment.ARPYMTDETAILS += $Detail

    Context "Required fields" {

        it "has 4, mandatory parameters" {
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter PAYMENTMETHOD -Mandatory
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter CUSTOMERID -Mandatory
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter RECEIPTDATE -Mandatory -Type datetime
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter ARPYMTDETAILS -Mandatory
        }

        it "returns the expected values" {
            # act
            $Actual = $Payment | ConvertTo-ARPaymentXml

            # assert
            $Actual.ARPYMT.PAYMENTMETHOD | Should -Be $Payment.PAYMENTMETHOD
            $Actual.ARPYMT.CUSTOMERID | Should -Be $Payment.CUSTOMERID
            $Actual.ARPYMT.RECEIPTDATE | Should -Be $Payment.RECEIPTDATE
            $Actual.ARPYMT.CURRENCY | Should -Be $Payment.CURRENCY
            $Actual.ARPYMT.ARPYMTDETAILS.ARPYMTDETAIL.RECORDKEY | Should -Be $Detail.RECORDKEY
        }

    }

    Context "Optional fields" {

        it "has 17, optional parameters" {
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter CURRENCY
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter FINANCIALENTITY
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter DOCNUMBER
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter DESCRIPTION
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter EXCH_RATE_TYPE_ID
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter EXCHANGE_RATE
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter PAYMENTDATE -Type datetime
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter AMOUNTOPAY -Type decimal
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter TRX_AMOUNTTOPAY -Type decimal
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter PRBATCH
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter WHENPAID -Type datetime
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter BASECURR
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter UNDEPOSITEDACCOUNTNO
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter OVERPAYMENTAMOUNT -Type decimal
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter OVERPAYMENTLOCATIONID
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter OVERPAYMENTDEPARTMENTID
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter BILLTOPAYNAME
            Get-Command "ConvertTo-ARPaymentXml" | Should -HaveParameter ONLINECARDPAYMENT
        }

        $Payment | Add-Member -MemberType NoteProperty -Name 'FINANCIALENTITY' -Value 'financialentity'
        $Payment | Add-Member -MemberType NoteProperty -Name 'DOCNUMBER' -Value 'docnumber'
        $Payment | Add-Member -MemberType NoteProperty -Name 'DESCRIPTION' -Value 'description'
        $Payment | Add-Member -MemberType NoteProperty -Name 'EXCH_RATE_TYPE_ID' -Value 'exch_rate_type_id'
        $Payment | Add-Member -MemberType NoteProperty -Name 'EXCHANGE_RATE' -Value 'exchange_rate'
        $Payment | Add-Member -MemberType NoteProperty -Name 'PAYMENTDATE' -Value '01/01/2020'
        $Payment | Add-Member -MemberType NoteProperty -Name 'AMOUNTOPAY' -Value 100.00
        $Payment | Add-Member -MemberType NoteProperty -Name 'TRX_AMOUNTTOPAY' -Value 200.00
        $Payment | Add-Member -MemberType NoteProperty -Name 'PRBATCH' -Value 'prbatch'
        $Payment | Add-Member -MemberType NoteProperty -Name 'WHENPAID' -Value '01/31/2020'
        $Payment | Add-Member -MemberType NoteProperty -Name 'BASECURR' -Value 'USD'
        $Payment | Add-Member -MemberType NoteProperty -Name 'UNDEPOSITEDACCOUNTNO' -Value 'undepositedaccountno'
        $Payment | Add-Member -MemberType NoteProperty -Name 'OVERPAYMENTAMOUNT' -Value 300.00
        $Payment | Add-Member -MemberType NoteProperty -Name 'OVERPAYMENTLOCATIONID' -Value 'overpaymentlocationid'
        $Payment | Add-Member -MemberType NoteProperty -Name 'OVERPAYMENTDEPARTMENTID' -Value 'overpaymentdepartmentid'
        $Payment | Add-Member -MemberType NoteProperty -Name 'BILLTOPAYNAME' -Value 'billtopayname'
        $Payment | Add-Member -MemberType NoteProperty -Name 'ONLINECARDPAYMENT' -Value 'onlinecardpayment'

        it "returns the expected values" {
            # act
            $Actual = $Payment | ConvertTo-ARPaymentXml

            # assert
            $Actual.ARPYMT.FINANCIALENTITY | Should -Be $Payment.FINANCIALENTITY
            $Actual.ARPYMT.DOCNUMBER | Should -Be $Payment.DOCNUMBER
            $Actual.ARPYMT.DESCRIPTION | Should -Be $Payment.DESCRIPTION
            $Actual.ARPYMT.EXCH_RATE_TYPE_ID | Should -Be $Payment.EXCH_RATE_TYPE_ID
            $Actual.ARPYMT.EXCHANGE_RATE | Should -Be $Payment.EXCHANGE_RATE
            $Actual.ARPYMT.PAYMENTDATE | Should -Be $Payment.PAYMENTDATE
            $Actual.ARPYMT.AMOUNTOPAY | Should -Be $Payment.AMOUNTOPAY
            $Actual.ARPYMT.TRX_AMOUNTTOPAY | Should -Be $Payment.TRX_AMOUNTTOPAY
            $Actual.ARPYMT.PRBATCH | Should -Be $Payment.PRBATCH
            $Actual.ARPYMT.WHENPAID | Should -Be $Payment.WHENPAID
            $Actual.ARPYMT.BASECURR | Should -Be $Payment.BASECURR
            $Actual.ARPYMT.UNDEPOSITEDACCOUNTNO | Should -Be $Payment.UNDEPOSITEDACCOUNTNO
            $Actual.ARPYMT.OVERPAYMENTAMOUNT | Should -Be $Payment.OVERPAYMENTAMOUNT
            $Actual.ARPYMT.OVERPAYMENTLOCATIONID | Should -Be $Payment.OVERPAYMENTLOCATIONID
            $Actual.ARPYMT.OVERPAYMENTDEPARTMENTID | Should -Be $Payment.OVERPAYMENTDEPARTMENTID
            $Actual.ARPYMT.BILLTOPAYNAME | Should -Be $Payment.BILLTOPAYNAME
            $Actual.ARPYMT.ONLINECARDPAYMENT | Should -Be $Payment.ONLINECARDPAYMENT
        }

    }

}
