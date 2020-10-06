# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Private
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-APBill.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# dependencies
. (Join-Path $PrivatePath "ConvertTo-APBillItem.ps1")

# . /PsIntacct/PsIntacct/Public/ConvertTo-APBill.ps1
. (Join-Path $PublicPath $sut)

Describe "ConvertTo-APBill" -tag 'Unit' {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'ConvertTo-APBill'
        }
        
        $Parameters = @(
            @{Name='WHENCREATED';Type=[datetime];ValueFromPipelineByPropertyName=$true;IsMandatory=$true}
            @{Name='WHENPOSTED';Type=[datetime];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='VENDORID';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$true}
            @{Name='BILLTOPAYTOCONTACTNAME';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='SHIPTORETURNTOCONTACTNAME';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='RECORDID';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='DOCNUMBER';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='DESCRIPTION';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='TERMNAME';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='RECPAYMENTDATE';Type=[datetime];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='SUPDOCID';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='WHENDUE';Type=[datetime];ValueFromPipelineByPropertyName=$true;IsMandatory=$true}
            @{Name='PAYMENTPRIORITY';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='ONHOLD';Type=[bool];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='PRBATCH';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='CURRENCY';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='BASECURR';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='EXCH_RATE_DATE';Type=[datetime];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='EXCH_RATE_TYPE_ID';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='EXCHANGE_RATE';Type=[decimal];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='INCLUSIVETAX';Type=[bool];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='ACTION';Type=[string];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
            @{Name='APBILLITEM';Type=[pscustomobject[]];ValueFromPipelineByPropertyName=$true;IsMandatory=$true}
            @{Name='CUSTOMFIELDS';Type=[pscustomobject];ValueFromPipelineByPropertyName=$true;IsMandatory=$false}
        )

        It "<Name> is a [<Type>]" -TestCases $Parameters {
            param($Name,$Type)
            $Command | Should -HaveParameter $Name -Type $Type
        }

        it '<Name> mandatory is <Mandatory>' -TestCases $Parameters {
            param($Name, $IsMandatory)
          
            if ($IsMandatory) { $Command | Should -HaveParameter $Name -Mandatory }
            else { $Command | Should -HaveParameter $Name -Not -Mandatory }
        }

        it '<Name> accepts value from the pipeline is <ValueFromPipelineByPropertyName>' -TestCases $Parameters {
            param($Name, $ValueFromPipelineByPropertyName)
          
            $Command.parameters[$Name].Attributes.ValueFromPipelineByPropertyName | Should -Be $ValueFromPipelineByPropertyName
        }

    } # /parameter validation

    Context "Usage" {

        BeforeAll {
            # arrange
            $APBILLITEM = @(
                [pscustomobject]@{ACCOUNTNO='1'}
                [pscustomobject]@{ACCOUNTNO='2'}
            )

            $Expected = @{
                WHENCREATED='10/06/2020'
                WHENPOSTED='10/07/2020'
                VENDORID='VENDORID'
                BILLTOPAYTOCONTACTNAME='BILLTOPAYTOCONTACTNAME'
                SHIPTORETURNTOCONTACTNAME='SHIPTORETURNTOCONTACTNAME'
                RECORDID='RECORDID'
                DOCNUMBER='DOCNUMBER'
                DESCRIPTION='DESCRIPTION'
                TERMNAME='Net 30'
                RECPAYMENTDATE='10/08/2020'
                SUPDOCID='SUPDOCID'
                WHENDUE='10/09/2020'
                PAYMENTPRIORITY='urgent'
                ONHOLD=$true
                PRBATCH='PRBATCH'
                CURRENCY='USD'
                BASECURR='USD'
                EXCH_RATE_DATE='10/10/2020'
                EXCH_RATE_TYPE_ID='EXCH_RATE_TYPE_ID'
                EXCHANGE_RATE=100.00
                INCLUSIVETAX=$true
                ACTION='Draft'
                APBILLITEM=$APBILLITEM
                CUSTOMFIELDS=[pscustomobject]@{FOO='BAR'}
            }
        }

        It "returns the expected graph" {

            # act
            $Actual = [pscustomobject]$Expected | ConvertTo-APBill

            # assert
            $Actual.APBILL.WHENCREATED | Should -Be $Expected.WHENCREATED
            $Actual.APBILL.WHENPOSTED | Should -Be $Expected.WHENPOSTED
            $Actual.APBILL.VENDORID| Should -Be $Expected.VENDORID
            $Actual.APBILL.BILLTOPAYTOCONTACTNAME | Should -Be $Expected.BILLTOPAYTOCONTACTNAME
            $Actual.APBILL.SHIPTORETURNTOCONTACTNAME | Should -Be $Expected.SHIPTORETURNTOCONTACTNAME
            $Actual.APBILL.RECORDID | Should -Be $Expected.RECORDID
            $Actual.APBILL.DOCNUMBER | Should -Be $Expected.DOCNUMBER
            $Actual.APBILL.DESCRIPTION | Should -Be $Expected.DESCRIPTION
            $Actual.APBILL.TERMNAME | Should -Be $Expected.TERMNAME
            $Actual.APBILL.RECPAYMENTDATE | Should -Be $Expected.RECPAYMENTDATE
            $Actual.APBILL.SUPDOCID | Should -Be $Expected.SUPDOCID
            $Actual.APBILL.WHENDUE | Should -Be $Expected.WHENDUE
            $Actual.APBILL.PAYMENTPRIORITY | Should -Be $Expected.PAYMENTPRIORITY
            $Actual.APBILL.ONHOLD | Should -Be $Expected.ONHOLD
            $Actual.APBILL.PRBATCH | Should -Be $Expected.PRBATCH
            $Actual.APBILL.CURRENCY | Should -Be $Expected.CURRENCY
            $Actual.APBILL.BASECURR | Should -Be $Expected.BASECURR
            $Actual.APBILL.EXCH_RATE_DATE | Should -Be $Expected.EXCH_RATE_DATE
            $Actual.APBILL.EXCH_RATE_TYPE_ID | Should -Be $Expected.EXCH_RATE_TYPE_ID
            $Actual.APBILL.EXCHANGE_RATE | Should -Be $Expected.EXCHANGE_RATE
            $Actual.APBILL.INCLUSIVETAX | Should -Be $Expected.INCLUSIVETAX
            $Actual.APBILL.ACTION | Should -Be $Expected.ACTION
            $Actual.APBILL.APBILLITEMS.APBILLITEM[0].ACCOUNTNO | Should -Be $Expected.APBILLITEM[0].ACCOUNTNO
            $Actual.APBILL.APBILLITEMS.APBILLITEM[1].ACCOUNTNO | Should -Be $Expected.APBILLITEM[1].ACCOUNTNO

            foreach ($property in $Expected.CUSTOMFIELDS.PSObject.Properties) {
                Write-Debug "$($property.Name): $($property.Value)"
                $Actual.APBILL[$property.Name].'#text' | Should -Be $property.Value
            }
        }

    }

}
