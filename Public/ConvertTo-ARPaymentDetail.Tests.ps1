$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-ARPaymentDetail" {

    $Detail = [pscustomobject]@{
        RECORDKEY=123
    }

    Context "Required fields" {

        it "has 1, mandatory parameters" {
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter RECORDKEY -Mandatory
        }

        it "returns the expected values" {
            # act
            [xml]$Actual = $Detail | ConvertTo-ARPaymentDetail

            # assert
            $Actual.ARPYMTDETAIL.RECORDKEY | Should -Be $Detail.RECORDKEY
        }

    }

    Context "Optional fields" {

        it "has 19, mandatory parameters" {
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter ENTRYKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter POSADJKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter POSADJENTRYKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter TRX_PAYMENTAMOUNT
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter ADJUSTMENTKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter ADJUSTMENTENTRYKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter TRX_ADJUSTMENTAMOUNT
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter INLINEKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter INLINEENTRYKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter TRX_INLINEAMOUNT
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter ADVANCEKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter ADVANCEENTRYKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter TRX_POSTEDADVANCEAMOUNT
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter OVERPAYMENTKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter OVERPAYMENTENTRYKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter TRX_POSTEDOVERPAYMENTAMOUNT
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter NEGATIVEINVOICEKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter NEGATIVEINVOICEENTRYKEY
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter TRX_NEGATIVEINVOICEAMOUNT
            Get-Command "ConvertTo-ARPaymentDetail" | Should -HaveParameter DISCOUNTDATE
        }
    
        $Detail | Add-Member -MemberType NoteProperty -Name 'ENTRYKEY' -Value 111
        $Detail | Add-Member -MemberType NoteProperty -Name 'POSADJKEY' -Value 222
        $Detail | Add-Member -MemberType NoteProperty -Name 'POSADJENTRYKEY' -Value 333
        $Detail | Add-Member -MemberType NoteProperty -Name 'TRX_PAYMENTAMOUNT' -Value 111.11
        $Detail | Add-Member -MemberType NoteProperty -Name 'ADJUSTMENTKEY' -Value 444
        $Detail | Add-Member -MemberType NoteProperty -Name 'ADJUSTMENTENTRYKEY' -Value 555
        $Detail | Add-Member -MemberType NoteProperty -Name 'TRX_ADJUSTMENTAMOUNT' -Value 222.22
        $Detail | Add-Member -MemberType NoteProperty -Name 'INLINEKEY' -Value 666
        $Detail | Add-Member -MemberType NoteProperty -Name 'INLINEENTRYKEY' -Value 777
        $Detail | Add-Member -MemberType NoteProperty -Name 'TRX_INLINEAMOUNT' -Value 333.33
        $Detail | Add-Member -MemberType NoteProperty -Name 'ADVANCEKEY' -Value 888
        $Detail | Add-Member -MemberType NoteProperty -Name 'ADVANCEENTRYKEY' -Value 999
        $Detail | Add-Member -MemberType NoteProperty -Name 'TRX_POSTEDADVANCEAMOUNT' -Value 444.44
        $Detail | Add-Member -MemberType NoteProperty -Name 'OVERPAYMENTKEY' -Value 100
        $Detail | Add-Member -MemberType NoteProperty -Name 'OVERPAYMENTENTRYKEY' -Value 200
        $Detail | Add-Member -MemberType NoteProperty -Name 'TRX_POSTEDOVERPAYMENTAMOUNT' -Value 555.55
        $Detail | Add-Member -MemberType NoteProperty -Name 'NEGATIVEINVOICEKEY' -Value 300
        $Detail | Add-Member -MemberType NoteProperty -Name 'NEGATIVEINVOICEENTRYKEY' -Value 400
        $Detail | Add-Member -MemberType NoteProperty -Name 'TRX_NEGATIVEINVOICEAMOUNT' -Value 666.66
        $Detail | Add-Member -MemberType NoteProperty -Name 'DISCOUNTDATE' -Value '02/20/2020'

        it "returns the expected values" {
            # act
            [xml]$Actual = $Detail | ConvertTo-ARPaymentDetail

            # assert
            $Actual.ARPYMTDETAIL.RECORDKEY | Should -Be $Detail.RECORDKEY
        }

    }

}
