$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-MailingAddressXml" -Tag 'unit' {

    $Address = [pscustomobject]@{
        ADDRESS1='Address One'
        ADDRESS2='Address Two'
        CITY='Minneapolis'
        STATE='MN'
        ZIP='12345'
        COUNTRYCODE='US'
    }

    Context "Optional fields" {

        it "has 5 parameters" {
            Get-Command "ConvertTo-MailingAddressXml" | Should -HaveParameter ADDRESS1
            Get-Command "ConvertTo-MailingAddressXml" | Should -HaveParameter ADDRESS2
            Get-Command "ConvertTo-MailingAddressXml" | Should -HaveParameter CITY
            Get-Command "ConvertTo-MailingAddressXml" | Should -HaveParameter STATE
            Get-Command "ConvertTo-MailingAddressXml" | Should -HaveParameter ZIP
            Get-Command "ConvertTo-MailingAddressXml" | Should -HaveParameter COUNTRYCODE
        }
    
        it "returns the expected values" {
            # act
            [xml]$Actual = $Address | ConvertTo-MailingAddressXml

            # assert
            $Actual.MAILADDRESS.ADDRESS1 | Should -Be $Address.ADDRESS1
            $Actual.MAILADDRESS.ADDRESS2 | Should -Be $Address.ADDRESS2
            $Actual.MAILADDRESS.CITY | Should -Be $Address.CITY
            $Actual.MAILADDRESS.STATE | Should -Be $Address.STATE
            $Actual.MAILADDRESS.ZIP | Should -Be $Address.ZIP
            $Actual.MAILADDRESS.COUNTRYCODE | Should -Be $Address.COUNTRYCODE
        }

    } # /context

}
