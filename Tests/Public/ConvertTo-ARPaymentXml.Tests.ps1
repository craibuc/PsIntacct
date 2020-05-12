# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARPaymentXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-ARPaymentXml.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "ConvertTo-ARPaymentDetailXml.ps1")
. (Join-Path $PrivatePath "ConvertTo-OnlineCardPaymentXml.ps1")

Describe "ConvertTo-ARPaymentXml" -Tag 'unit' {

    Context "Parameter validation" {

        $Command = Get-Command "ConvertTo-ARPaymentXml"

        $PRBATCH = @{ParameterSetName='PRBATCH';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
        $FINANCIALENTITY = @{ParameterSetName='FINANCIALENTITY';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
        $UNDEPOSITEDACCOUNTNO = @{ParameterSetName='UNDEPOSITEDACCOUNTNO';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}

        @{ParameterName='CUSTOMERID';Type=[string];IsMandatory=$true},
        @{ParameterName='PAYMENTMETHOD';Type=[string];IsMandatory=$true},
        @{ParameterName='RECEIPTDATE';Type=[datetime];IsMandatory=$true},
        @{ParameterName='FINANCIALENTITY';Type=[string];ParameterSets = @($FINANCIALENTITY)},
        @{ParameterName='UNDEPOSITEDACCOUNTNO';Type=[string];ParameterSets = @($UNDEPOSITEDACCOUNTNO)},
        @{ParameterName='PRBATCH';Type=[string];ParameterSets = @($PRBATCH)},
        @{ParameterName='ARPYMTDETAILS';Type=[pscustomobject[]];IsMandatory=$true},
        @{ParameterName='DOCNUMBER';Type=[string];IsMandatory=$false},
        @{ParameterName='DESCRIPTION';Type=[string];IsMandatory=$false},
        @{ParameterName='EXCH_RATE_TYPE_ID';Type=[string];IsMandatory=$false},
        @{ParameterName='EXCHANGE_RATE';Type=[string];IsMandatory=$false},
        @{ParameterName='PAYMENTDATE';Type=[datetime];IsMandatory=$false},
        @{ParameterName='AMOUNTOPAY';Type=[decimal];IsMandatory=$false},
        @{ParameterName='TRX_AMOUNTTOPAY';Type=[decimal];IsMandatory=$false},
        @{ParameterName='WHENPAID';Type=[datetime];IsMandatory=$false},
        @{ParameterName='BASECURR';Type=[string];IsMandatory=$false},
        @{ParameterName='CURRENCY';Type=[string];IsMandatory=$false},
        @{ParameterName='OVERPAYMENTAMOUNT';Type=[decimal];IsMandatory=$false},
        @{ParameterName='OVERPAYMENTLOCATIONID';Type=[string];IsMandatory=$false},
        @{ParameterName='OVERPAYMENTDEPARTMENTID';Type=[string];IsMandatory=$false},
        @{ParameterName='BILLTOPAYNAME';Type=[string];IsMandatory=$false},
        @{ParameterName='ONLINECARDPAYMENT';Type=[pscustomobject];IsMandatory=$false} |
        ForEach-Object {

            $Parameter = $_

            Context $Parameter.ParameterName {

                It "is a [$($Parameter.Type)]" {
                    $Command | Should -HaveParameter $Parameter.ParameterName -Type $Parameter.Type
                }

                if ($Parameter.Aliases) {
                    $Parameter.Aliases | ForEach-Object {
                        It "is has an alias of '$_'" {
                            $Command.Parameters[$Parameter.ParameterName].Aliases | Should -Contain $_
                        }
                    }
                }

                if ($Parameter.ParameterSets) {
                    $_.ParameterSets | ForEach-Object {
                        Context "ParameterSet '$($_.ParameterSetName)'" {
                            It "is $( $_.IsMandatory ? 'a mandatory': 'an optional') member" {
                                $Command.parameters[$Parameter.ParameterName].parametersets[$_.ParameterSetName].IsMandatory | Should -Be $_.IsMandatory
                            }
                            it "supports ValueFromPipelineByPropertyName"{
                                $Command.parameters[$Parameter.ParameterName].parametersets[$_.ParameterSetName].ValueFromPipelineByPropertyName | Should -Be $_.ValueFromPipelineByPropertyName
                            }    
                        }
                    }
                }
                else
                {
                    It "is $( $_.IsMandatory ? 'a mandatory': 'an optional')" {
                        $Command.parameters[$Parameter.ParameterName].Attributes.Mandatory | Should -Be $_.IsMandatory
                    }    
                }
            }
        }

    } # /context (parameter validation)

    Context "Usage" {

        BeforeEach {
            $Payment = [pscustomobject]@{
                PAYMENTMETHOD='Cash'
                CUSTOMERID='ABC'
                RECEIPTDATE='02/20/2020'
                CURRENCY='USD'
                ARPYMTDETAILS = @()
                FINANCIALENTITY = $null
                DOCNUMBER = 'docnumber'
                DESCRIPTION = 'description'
                EXCH_RATE_TYPE_ID = 'exch_rate_type_id'
                EXCHANGE_RATE = 'exchange_rate'
                PAYMENTDATE = '01/01/2020'
                AMOUNTOPAY = 100.00
                TRX_AMOUNTTOPAY = 200.00
                PRBATCH = $null
                WHENPAID = '01/31/2020'
                BASECURR = 'USD'
                UNDEPOSITEDACCOUNTNO = $null
                OVERPAYMENTAMOUNT = 300.00
                OVERPAYMENTLOCATIONID = 'overpaymentlocationid'
                OVERPAYMENTDEPARTMENTID = 'overpaymentdepartmentid'
                BILLTOPAYNAME = 'billtopayname'
                ONLINECARDPAYMENT = [pscustomobject]@{
                    CARDNUM = '0123456789'
                    EXPIRYDATE = '4/1/2020'
                    CARDTYPE = 'AMEX'
                    SECURITYCODE = '0123'
                    USEDEFAULTCARD = $true
                }
            }
            $Detail = [pscustomobject]@{RECORDKEY='123'}
            $Payment.ARPYMTDETAILS += $Detail
        }

        @{ParameterSetName='FINANCIALENTITY'; Field='FINANCIALENTITY'; Value='financialentity'},
        @{ParameterSetName='UNDEPOSITEDACCOUNTNO'; Field='UNDEPOSITEDACCOUNTNO'; Value='undepositedaccountno'},
        @{ParameterSetName='PRBATCH'; Field='PRBATCH'; Value='prbatch'} | 
        ForEach-Object {
            Context $_.ParameterSetName {

                it "returns the expected values" {
                    # arrange
                    $Payment."$($_.Field)" = $_.Value

                    # act
                    $Actual = $Payment | ConvertTo-ARPaymentXml
        
                    # assert
                    $Actual.ARPYMT.CUSTOMERID | Should -Be $Payment.CUSTOMERID
                    $Actual.ARPYMT.PAYMENTMETHOD | Should -Be $Payment.PAYMENTMETHOD
                    $Actual.ARPYMT.RECEIPTDATE | Should -Be $Payment.RECEIPTDATE
                    $Actual.ARPYMT.FINANCIALENTITY | Should -Be $Payment.FINANCIALENTITY
                    $Actual.ARPYMT.UNDEPOSITEDACCOUNTNO | Should -Be $Payment.UNDEPOSITEDACCOUNTNO
                    $Actual.ARPYMT.ARPYMTDETAILS.ARPYMTDETAIL.RECORDKEY | Should -Be $Detail.RECORDKEY
                    $Actual.ARPYMT.DOCNUMBER | Should -Be $Payment.DOCNUMBER
                    $Actual.ARPYMT.DESCRIPTION | Should -Be $Payment.DESCRIPTION
                    $Actual.ARPYMT.EXCH_RATE_TYPE_ID | Should -Be $Payment.EXCH_RATE_TYPE_ID
                    $Actual.ARPYMT.EXCHANGE_RATE | Should -Be $Payment.EXCHANGE_RATE
                    $Actual.ARPYMT.PAYMENTDATE | Should -Be $Payment.PAYMENTDATE
                    $Actual.ARPYMT.AMOUNTOPAY | Should -Be $Payment.AMOUNTOPAY
                    $Actual.ARPYMT.TRX_AMOUNTTOPAY | Should -Be $Payment.TRX_AMOUNTTOPAY
                    $Actual.ARPYMT.PRBATCH | Should -Be $Payment.PRBATCH
                    $Actual.ARPYMT.WHENPAID | Should -Be $Payment.WHENPAID
                    $Actual.ARPYMT.CURRENCY | Should -Be $Payment.CURRENCY
                    $Actual.ARPYMT.BASECURR | Should -Be $Payment.BASECURR
                    $Actual.ARPYMT.OVERPAYMENTAMOUNT | Should -Be $Payment.OVERPAYMENTAMOUNT
                    $Actual.ARPYMT.OVERPAYMENTLOCATIONID | Should -Be $Payment.OVERPAYMENTLOCATIONID
                    $Actual.ARPYMT.OVERPAYMENTDEPARTMENTID | Should -Be $Payment.OVERPAYMENTDEPARTMENTID
                    $Actual.ARPYMT.BILLTOPAYNAME | Should -Be $Payment.BILLTOPAYNAME
                    $Actual.ARPYMT.ONLINECARDPAYMENT.Name | Should -Be 'ONLINECARDPAYMENT'
                }

            } # /context (parameterset)

        }

    } # /context (usage)

}
