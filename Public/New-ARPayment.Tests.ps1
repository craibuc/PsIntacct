$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"
. "$Parent/Private/Send-Request.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-ARPayment" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

    $Payment = [pscustomobject]@{
        PAYMENTMETHOD='Cash'
        CUSTOMERID='ABC'
        RECEIPTDATE='02/20/2020'
        CURRENCY='USD'
    }

    Context "Required parameters" {

        # arrange    
        Mock Send-Request

        it "has 5, mandatory parameters" {

            Get-Command "New-ARPayment" | Should -HaveParameter Session -Mandatory
            Get-Command "New-ARPayment" | Should -HaveParameter PaymentMethod -Mandatory
            Get-Command "New-ARPayment" | Should -HaveParameter CustomerId -Mandatory
            Get-Command "New-ARPayment" | Should -HaveParameter ReceiptDate -Mandatory
            Get-Command "New-ARPayment" | Should -HaveParameter Currency -Mandatory

        }

        it "calls Send-Request with the expected parameter values" {
            # act
            $Payment | New-ARPayment -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $create = ([xml]$Function).function.create
                $create.ARPYMT.PAYMENTMETHOD -eq $Payment.PAYMENTMETHOD -and 
                $create.ARPYMT.CUSTOMERID -eq $Payment.CUSTOMERID -and 
                $create.ARPYMT.RECEIPTDATE -eq $Payment.RECEIPTDATE -and
                $create.ARPYMT.CURRENCY -eq $Payment.CURRENCY -and 
                $create.ARPYMT.FINANCIALENTITY -eq '' -and 
                $create.ARPYMT.DOCNUMBER -eq '' -and 
                $create.ARPYMT.DESCRIPTION -eq '' -and 
                $create.ARPYMT.EXCH_RATE_TYPE_ID -eq '' -and 
                $create.ARPYMT.EXCHANGE_RATE -eq '' -and
                $create.ARPYMT.PAYMENTDATE -eq '' -and
                $create.ARPYMT.AMOUNTOPAY -eq 0 -and
                $create.ARPYMT.TRX_AMOUNTTOPAY -eq 0 -and
                $create.ARPYMT.PRBATCH -eq '' -and
                $create.ARPYMT.WHENPAID -eq '' -and
                $create.ARPYMT.BASECURR -eq '' # -and
                # $create.ARPYMT.OVERPAYMENTAMOUNT -eq '' -and
                # $create.ARPYMT.OVERPAYMENTLOCATIONID -eq '' -and
                # $create.ARPYMT.OVERPAYMENTDEPARTMENTID -eq '' -and
                # $create.ARPYMT.BILLTOPAYNAME -eq '' -and
            }
        }

    } # /context

    Context "Optional parameters" {

        # arrange
        Mock Send-Request

        $Payment | Add-Member -MemberType NoteProperty -Name 'DESCRIPTION' -Value 'lorem ipsum'
        $Payment | Add-Member -MemberType NoteProperty -Name 'DOCNUMBER' -Value 'INV-007'
        $Payment | Add-Member -MemberType NoteProperty -Name 'FinancialEntity' -Value 'Acme'
        $Payment | Add-Member -MemberType NoteProperty -Name 'ExchangeRateTypeId' -Value 'Intacct Daily Rate'
        $Payment | Add-Member -MemberType NoteProperty -Name 'ExchangeRate' -Value '0.98'
        $Payment | Add-Member -MemberType NoteProperty -Name 'PaymentDate' -Value '02/20/2020'
        $Payment | Add-Member -MemberType NoteProperty -Name 'PaymentAmount' -Value 1000.00
        $Payment | Add-Member -MemberType NoteProperty -Name 'TxPaymentAmount' -Value 1000.00
        $Payment | Add-Member -MemberType NoteProperty -Name 'PrBatch' -Value '100'
        $Payment | Add-Member -MemberType NoteProperty -Name 'InvoicePaidDate' -Value '02/20/2020'
        $Payment | Add-Member -MemberType NoteProperty -Name 'BaseCurrency' -Value 'USD'

        it "calls Send-Request with the expected parameter values" {
            # act
            $Payment | New-ARPayment -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $create = ([xml]$Function).function.create
                $create.ARPYMT.DESCRIPTION -eq $Payment.DESCRIPTION -and 
                $create.ARPYMT.DOCNUMBER -eq $Payment.DOCNUMBER -and 
                $create.ARPYMT.FINANCIALENTITY -eq $Payment.FINANCIALENTITY -and 
                $create.ARPYMT.EXCH_RATE_TYPE_ID -eq $Payment.ExchangeRateTypeId -and 
                $create.ARPYMT.EXCHANGE_RATE -eq $Payment.ExchangeRate -and
                $create.ARPYMT.PAYMENTDATE -eq $Payment.PaymentDate -and
                $create.ARPYMT.AMOUNTOPAY -eq $Payment.PaymentAmount -and
                $create.ARPYMT.TRX_AMOUNTTOPAY -eq $Payment.TxPaymentAmount -and
                $create.ARPYMT.PRBATCH -eq $Payment.PrBatch -and
                $create.ARPYMT.WHENPAID -eq $Payment.InvoicePaidDate -and
                $create.ARPYMT.BASECURR -eq $Payment.BaseCurrency # -and
                $create.ARPYMT.UNDEPOSITEDACCOUNTNO -eq $Payment.BaseCurrency # -and
                # $create.ARPYMT.OVERPAYMENTAMOUNT -eq $Payment. -and
                # $create.ARPYMT.OVERPAYMENTLOCATIONID -eq $Payment. -and
                # $create.ARPYMT.OVERPAYMENTDEPARTMENTID -eq $Payment. -and
                # $create.ARPYMT.BILLTOPAYNAME -eq $Payment. -and
            }
        }

    } # /context

}
