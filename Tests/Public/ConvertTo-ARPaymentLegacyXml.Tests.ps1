# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARPaymentLegacyXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/ConvertTo-ARPaymentLegacyXml.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "ConvertTo-ARPaymentItemXml.ps1")
. (Join-Path $PrivatePath "ConvertTo-OnlineCardPaymentXml.ps1")
. (Join-Path $PrivatePath "ConvertTo-OnlineAchPaymentXml.ps1")

Describe "ConvertTo-ARPaymentLegacyXml" -Tag 'unit' {

    Context "Parameter validation" {

        $Command = Get-Command "ConvertTo-ARPaymentLegacyXml"

        Context "Create" {

            $CreateBatchKey = @{ParameterSetName='Create.batchkey';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $CreateBankAccountId = @{ParameterSetName='Create.bankaccountid';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $CreateUndepositedFunds = @{ParameterSetName='Create.undepfundsacct';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $ParameterSetCreateMandatory = @($CreateBatchKey,$CreateBankAccountId,$CreateUndepositedFunds)

            $CreateBatchKeyOptional = @{ParameterSetName='Create.batchkey';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            $CreateBankAccountIdOptional = @{ParameterSetName='Create.bankaccountid';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            $CreateUndepositedFundsOptional = @{ParameterSetName='Create.undepfundsacct';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            $ParameterSetCreateOptional = @($CreateBatchKeyOptional,$CreateBankAccountIdOptional,$CreateUndepositedFundsOptional)

            @{ParameterName='customerid';Type=[string];Aliases=$null;ParameterSets = $ParameterSetCreateMandatory},
            @{ParameterName='paymentamount';Type=[decimal];ParameterSets = $ParameterSetCreateMandatory},
            @{ParameterName='bankaccountid';Type=[string];Aliases=@('FINANCIALENTITY'); ParameterSets=$CreateBankAccountId},
            @{ParameterName='undepfundsacct';Type=[string];Aliases=@('UNDEPOSITEDACCOUNTNO'); ParameterSets=$CreateUndepositedFunds},
            @{ParameterName='refid';Type=[string];Aliases=@('DOCNUMBER'); ParameterSets=$ParameterSetCreateOptional},
            @{ParameterName='overpaylocid';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='overpaydeptid';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='datereceived';Type=[datetime];Aliases=@('RECEIPTDATE');ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='paymentmethod';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='basecurr';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='currency';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='exchratedate';Type=[datetime];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='exchratetype';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='exchrate';Type=[decimal];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='cctype';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='authcode';Type=[string];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='arpaymentitem';Type=[pscustomobject[]];Aliases=@('ARPYMTDETAILS');ParameterSets = $ParameterSetCreateMandatory},
            @{ParameterName='onlinecardpayment';Type=[pscustomobject];ParameterSets = $ParameterSetCreateOptional},
            @{ParameterName='onlineachpayment';Type=[pscustomobject];ParameterSets = $ParameterSetCreateOptional} |
            ForEach-Object {
                Context $_.ParameterName {
                    $Parameter = $_
    
                    It "is a [$($_.Type)]" {
                        $Command | Should -HaveParameter $_.ParameterName -Type $_.Type
                    }
    
                    if ($Parameter.Aliases) {
                        $Parameter.Aliases | ForEach-Object {
                            It "is has an alias of '$_'" {
                                $Command.Parameters[$Parameter.ParameterName].Aliases | Should -Contain $_
                            }
                        }
                    }
    
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
            }

        } # /context (create)

        Context "Apply" {

            $ParameterSetApplyMandatory = @{ParameterSetName='Apply';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $ParameterSetApplyOptional = @{ParameterSetName='Apply';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}

            @{ParameterName='arpaymentkey';Type=[int];Aliases=$null;ParameterSets=$ParameterSetApplyMandatory},
            @{ParameterName='paymentdate';Type=[datetime];Aliases=$null;ParameterSets=$ParameterSetApplyMandatory},
            @{ParameterName='memo';Type=[string];Aliases=$null;ParameterSets=$ParameterSetApplyOptional},
            @{ParameterName='overpaylocid';Type=[string];Aliases=$null;ParameterSets=$ParameterSetApplyOptional},
            @{ParameterName='overpaydeptid';Type=[string];Aliases=$null;ParameterSets=$ParameterSetApplyOptional},
            @{ParameterName='arpaymentitem';Type=[pscustomobject[]];Aliases=@('ARPYMTDETAILS');ParameterSets=$ParameterSetApplyMandatory} |
            ForEach-Object {
                Context $_.ParameterName {
                    $Parameter = $_
    
                    It "is a [$($_.Type)]" {
                        $Command | Should -HaveParameter $_.ParameterName -Type $_.Type
                    }
    
                    if ($Parameter.Aliases) {
                        $Parameter.Aliases | ForEach-Object {
                            It "is has an alias of '$_'" {
                                $Command.Parameters[$Parameter.ParameterName].Aliases | Should -Contain $_
                            }
                        }
                    }
    
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
            }

        } # /context (apply)

    } # /context (parameter validation)

    Context "Usage" {

        Context "Create" {

            it "returns the expected values" {
                # arrange
                $Payment = [pscustomobject]@{
                    customerid = 6
                    paymentamount = 100.00
                    translatedamount = 200.00
                    # batchkey = 100
                    # bankaccountid = 'abc'
                    undepfundsacct = 'def'
                    refid = '123'
                    overpaylocid = '345'
                    overpaydeptid = '456'
                    datereceived = '03/23/2020'
                    paymentmethod = 'Cash'
                    basecurr = 'usd'
                    currency = 'usd'
                    exchratedate = '03/23/2020'
                    exchratetype = 'foo'
                    exchrate = 1.0
                    cctype = 'abc'
                    authcode = 'abc123'
                    arpaymentitem = [pscustomobject]@{invoicekey=123;amount=99.99}
                    onlinecardpayment = [pscustomobject]@{cardnum='0123456789';expirydate='4/1/2020';cardtype='amex';securitycode='0000';usedefaultcard=$true}
                    onlineachpayment = [pscustomobject]@{bankname='Acme';accounttype='savings';accountnumber='0123456789';routingnumber='0123456789';accountholder='wile e coyote';usedefaultcard=$true}
                }

                # act
                $Actual = $Payment | ConvertTo-ARPaymentLegacyXml
                $DocumentElement = $Actual.DocumentElement

                # assert
                $DocumentElement.Name | Should -Be 'create_arpayment'
                $DocumentElement.customerid | Should -Be $Payment.customerid
                $DocumentElement.paymentamount | Should -Be $Payment.paymentamount
                $DocumentElement.translatedamount | Should -Be $Payment.translatedamount
                $DocumentElement.batchkey | Should -Be $Payment.batchkey
                $DocumentElement.bankaccountid | Should -Be $Payment.bankaccountid
                $DocumentElement.undepfundsacct | Should -Be $Payment.undepfundsacct
                $DocumentElement.refid | Should -Be $Payment.refid
                $DocumentElement.overpaylocid | Should -Be $Payment.overpaylocid
                $DocumentElement.overpaydeptid | Should -Be $Payment.overpaydeptid
                $DocumentElement.datereceived.year | Should -Be ([datetime]$Payment.datereceived).ToString('yyyy')
                $DocumentElement.datereceived.month | Should -Be ([datetime]$Payment.datereceived).ToString('MM')
                $DocumentElement.datereceived.day | Should -Be ([datetime]$Payment.datereceived).ToString('dd')
                $DocumentElement.paymentmethod | Should -Be $Payment.paymentmethod
                $DocumentElement.basecurr | Should -Be $Payment.basecurr
                $DocumentElement.currency | Should -Be $Payment.currency
                $DocumentElement.exchratedate.year | Should -Be ([datetime]$Payment.exchratedate).ToString('yyyy')
                $DocumentElement.exchratedate.month | Should -Be ([datetime]$Payment.exchratedate).ToString('MM')
                $DocumentElement.exchratedate.day | Should -Be ([datetime]$Payment.exchratedate).ToString('dd')
                $DocumentElement.exchratetype | Should -Be $Payment.exchratetype
                $DocumentElement.exchrate | Should -Be $Payment.exchrate
                $DocumentElement.cctype | Should -Be $Payment.cctype
                $DocumentElement.authcode | Should -Be $Payment.authcode

                $DocumentElement.arpaymentitem.invoicekey | Should -Be $Payment.arpaymentitem.invoicekey
                $DocumentElement.arpaymentitem.amount | Should -Be $Payment.arpaymentitem.amount

                $DocumentElement.onlinecardpayment.cardnum | Should -Be $Payment.onlinecardpayment.cardnum
                $DocumentElement.onlinecardpayment.expirydate | Should -Be ([datetime]$Payment.onlinecardpayment.expirydate).ToString('MM/dd/yyyy')
                $DocumentElement.onlinecardpayment.cardtype | Should -Be $Payment.onlinecardpayment.cardtype
                $DocumentElement.onlinecardpayment.securitycode | Should -Be $Payment.onlinecardpayment.securitycode
                $DocumentElement.onlinecardpayment.usedefaultcard | Should -Be $Payment.onlinecardpayment.usedefaultcard.ToString().ToLower()

                $DocumentElement.onlineachpayment.bankname | Should -Be $Payment.onlineachpayment.bankname
                $DocumentElement.onlineachpayment.accounttype | Should -Be $Payment.onlineachpayment.accounttype
                $DocumentElement.onlineachpayment.accountnumber | Should -Be $Payment.onlineachpayment.accountnumber
                $DocumentElement.onlineachpayment.routingnumber | Should -Be $Payment.onlineachpayment.routingnumber
                $DocumentElement.onlineachpayment.accountholder | Should -Be $Payment.onlineachpayment.accountholder
                $DocumentElement.onlineachpayment.usedefaultcard | Should -Be $Payment.onlineachpayment.usedefaultcard.ToString().ToLower()
            }

        } # /context (create)

        Context "Apply" {
            
            # arrange
            $Payment = [pscustomobject]@{
                arpaymentkey = 6
                paymentdate = '4/1/2020'
                memo = 'lorem ipsum'
                overpaylocid = '345'
                overpaydeptid = '678'
                arpaymentitem = [pscustomobject]@{invoicekey=123;amount=99.99}
            }
        
            it "returns the expected values" {
                # act
                $Actual = $Payment | ConvertTo-ARPaymentLegacyXml
                $DocumentElement = $Actual.DocumentElement
    
                # assert
                $DocumentElement.Name | Should -Be 'apply_arpayment'
                $DocumentElement.arpaymentkey | Should -Be $Payment.arpaymentkey
                $DocumentElement.paymentdate.year | Should -Be ([datetime]$Payment.paymentdate).ToString('yyyy')
                $DocumentElement.paymentdate.month | Should -Be ([datetime]$Payment.paymentdate).ToString('MM')
                $DocumentElement.paymentdate.day | Should -Be ([datetime]$Payment.paymentdate).ToString('dd')
                $DocumentElement.memo | Should -Be $Payment.memo
                $DocumentElement.overpaylocid | Should -Be $Payment.overpaylocid
                $DocumentElement.overpaydeptid | Should -Be $Payment.overpaydeptid    
                $DocumentElement.arpaymentitems.arpaymentitem.invoicekey | Should -Be $Payment.arpaymentitem.invoicekey
                $DocumentElement.arpaymentitems.arpaymentitem.amount | Should -Be $Payment.arpaymentitem.amount
            }

        } # /context (apply)

    } # /context (usage)

}
