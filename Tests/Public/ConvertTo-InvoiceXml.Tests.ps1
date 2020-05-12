# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-ARAdjustmentXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "ConvertTo-CustomFieldXml.ps1")

Describe "ConvertTo-InvoiceXml" -Tag 'unit' {

    Context "Parameter validation" {

        $Command = Get-Command "ConvertTo-InvoiceXml"

        Context "Create" {

            $CreateMandatory = @{ParameterSetName='Create';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $CreateOptional = @{ParameterSetName='Create';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}

            @{ParameterName='customerid';Type=[string];ParameterSets = $CreateMandatory},
            @{ParameterName='datecreated';Type=[datetime];ParameterSets = $CreateMandatory},
            @{ParameterName='dateposted';Type=[datetime];ParameterSets = $CreateOptional},
            @{ParameterName='datedue';Type=[datetime];ParameterSets = $CreateMandatory},
            @{ParameterName='termname';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='batchkey';Type=[int];ParameterSets = $CreateOptional},
            @{ParameterName='action';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='invoiceno';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='ponumber';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='description';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='externalid';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='billto';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='shipto';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='basecurr';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='currency';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='exchratedate';Type=[datetime];ParameterSets = $CreateOptional},
            @{ParameterName='exchratetype';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='exchrate';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='nogl';Type=[bool];ParameterSets = $CreateOptional},
            @{ParameterName='supdocid';Type=[string];ParameterSets = $CreateOptional},
            @{ParameterName='customfields';Type=[pscustomobject[]];ParameterSets = $CreateOptional},
            @{ParameterName='invoiceitems';Type=[pscustomobject[]];ParameterSets = $CreateMandatory} |
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

        Context "Update" {

            $UpdateMandatory = @{ParameterSetName='Update';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $UpdateOptional = @{ParameterSetName='Update';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}

            @{ParameterName='key';Type=[int];ParameterSets = $UpdateMandatory},
            @{ParameterName='customerid';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='datecreated';Type=[datetime];ParameterSets = $UpdateOptional},
            @{ParameterName='dateposted';Type=[datetime];ParameterSets = $UpdateOptional},
            @{ParameterName='datedue';Type=[datetime];ParameterSets = $UpdateMandatory},
            @{ParameterName='termname';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='action';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='invoiceno';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='ponumber';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='description';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='payto';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='returnto';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='basecurr';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='currency';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='exchratedate';Type=[datetime];ParameterSets = $UpdateOptional},
            @{ParameterName='exchratetype';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='exchrate';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='supdocid';Type=[string];ParameterSets = $UpdateOptional},
            @{ParameterName='customfields';Type=[pscustomobject[]];ParameterSets = $UpdateOptional},
            @{ParameterName='invoiceitems';Type=[pscustomobject[]];ParameterSets = $UpdateOptional} |
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

        } # /context (update)

        Context "Reverse" {

            $Reverse = @{ParameterSetName='Reverse';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $ReverseOptional = @{ParameterSetName='Reverse';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}

            @{ParameterName='key';Type=[int];ParameterSets = $Reverse},
            @{ParameterName='datereversed';Type=[datetime];ParameterSets = $Reverse},
            @{ParameterName='description';Type=[string];ParameterSets = $ReverseOptional}|
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

        } # /context (reverse)

    } # /context (parameter validation)

    Context "Usage" {

        Context "Create" {

            BeforeEach {
                # arrange
                $Invoice = [pscustomobject]@{
                    customerid='ABC123'
                    datecreated = '02/20/2020'
                    dateposted = '02/20/2020'
                    datedue = '02/20/2020'
                    termname = 'Net 30'
                    batchkey = 111
                    action = 'Draft'
                    invoiceno = 'invoiceno'
                    ponumber = 'ponumber'
                    description = 'lorem ipsum'
                    externalid = 'externalid'
                    billto = 'billto'
                    shipto = 'shipto'
                    basecurr = 'USD'
                    currency = 'USD'
                    exchratedate = '4/1/2020'
                    exchratetype = 'exchratetype'
                    exchrate = 1.0
                    nogl = $true
                    supdocid = 123
                    customfields = @()
                    invoiceitems = @()
                }
                $Invoice.customfields += [pscustomobject]@{customfieldname='something';customfieldvalue=99.99}
                $Invoice.invoiceitems += [pscustomobject]@{glaccountno='10001000';amount=99.99}
            }

            it "returns the expected values" {

                # act
                $Actual = $Invoice | ConvertTo-InvoiceXml
                $DocumentElement = $Actual.DocumentElement

                # assert
                $DocumentElement.Name | Should -Be 'create_invoice'
                $DocumentElement.customerid | Should -Be $Invoice.customerid

                $DocumentElement.datecreated.year | Should -Be ([datetime]$Invoice.datecreated).year.ToString('0000')
                $DocumentElement.datecreated.month | Should -Be ([datetime]$Invoice.datecreated).month.ToString('00')
                $DocumentElement.datecreated.day | Should -Be ([datetime]$Invoice.datecreated).day.ToString('00')

                $DocumentElement.dateposted.year | Should -Be ([datetime]$Invoice.dateposted).year.ToString('0000')
                $DocumentElement.dateposted.month | Should -Be ([datetime]$Invoice.dateposted).month.ToString('00')
                $DocumentElement.dateposted.day | Should -Be ([datetime]$Invoice.dateposted).day.ToString('00')

                $DocumentElement.datedue.year | Should -Be ([datetime]$Invoice.datedue).year.ToString('0000')
                $DocumentElement.datedue.month | Should -Be ([datetime]$Invoice.datedue).month.ToString('00')
                $DocumentElement.datedue.day | Should -Be ([datetime]$Invoice.datedue).day.ToString('00')        

                $DocumentElement.termname | Should -Be $Invoice.termname
                $DocumentElement.batchkey | Should -Be $Invoice.batchkey
                $DocumentElement.action | Should -Be $Invoice.action
                $DocumentElement.invoiceno | Should -Be $Invoice.invoiceno
                $DocumentElement.ponumber | Should -Be $Invoice.ponumber
                $DocumentElement.description | Should -Be $Invoice.description
                $DocumentElement.externalid | Should -Be $Invoice.externalid
                $DocumentElement.billto.contactname | Should -Be $Invoice.billto
                $DocumentElement.shipto.contactname | Should -Be $Invoice.shipto
                $DocumentElement.basecurr | Should -Be $Invoice.basecurr
                $DocumentElement.currency | Should -Be $Invoice.currency

                $DocumentElement.exchratedate.year | Should -Be ([datetime]$Invoice.exchratedate).year.ToString('0000')
                $DocumentElement.exchratedate.month | Should -Be ([datetime]$Invoice.exchratedate).month.ToString('00')
                $DocumentElement.exchratedate.day | Should -Be ([datetime]$Invoice.exchratedate).day.ToString('00')

                $DocumentElement.exchratetype | Should -Be $Invoice.exchratetype
                $DocumentElement.exchrate | Should -Be $Invoice.exchrate
                $DocumentElement.nogl | Should -Be $Invoice.nogl.ToString().ToLower()
                $DocumentElement.supdocid | Should -Be $Invoice.supdocid

                $DocumentElement.customfields.customfield.customfieldname | Should -Be $Invoice.customfields.customfieldname
                $DocumentElement.customfields.customfield.customfieldvalue | Should -Be $Invoice.customfields.customfieldvalue

                $DocumentElement.invoiceitems.lineitem.glaccountno | Should -Be $Invoice.invoiceitems.glaccountno
                $DocumentElement.invoiceitems.lineitem.amount | Should -Be $Invoice.invoiceitems.amount
            }
    
        }

        Context "Update" {

            BeforeEach {
                # arrange
                $Invoice = [pscustomobject]@{
                    key=123
                    customerid='ABC123'
                    datecreated = '02/20/2020'
                    dateposted = '02/20/2020'
                    datedue = '02/20/2020'
                    termname = 'Net 30'
                    action = 'Draft'
                    invoiceno = 'invoiceno'
                    ponumber = 'ponumber'
                    description = 'lorem ipsum'
                    payto = 'payto'
                    returnto = 'returnto'
                    basecurr = 'USD'
                    currency = 'USD'
                    exchratedate = '4/1/2020'
                    exchratetype = 'exchratetype'
                    exchrate = 1.0
                    supdocid = 123
                    customfields = @()
                    invoiceitems = @()
                }
                $Invoice.customfields += [pscustomobject]@{customfieldname='something';customfieldvalue=99.99}
                $Invoice.invoiceitems += [pscustomobject]@{glaccountno='10001000';amount=99.99}

            } # /beforeeach

            it "returns the expected values when using '<PropertyName>'" {
    
                # act
                $Actual = $Invoice | ConvertTo-InvoiceXml
                $DocumentElement = $Actual.DocumentElement

                # assert
                $DocumentElement.Name | Should -Be 'update_invoice'
                $DocumentElement.key | Should -Be $Invoice.key
                $DocumentElement.customerid | Should -Be $Invoice.customerid

                $DocumentElement.datecreated.year | Should -Be ([datetime]$Invoice.datecreated).year.ToString('0000')
                $DocumentElement.datecreated.month | Should -Be ([datetime]$Invoice.datecreated).month.ToString('00')
                $DocumentElement.datecreated.day | Should -Be ([datetime]$Invoice.datecreated).day.ToString('00')

                $DocumentElement.dateposted.year | Should -Be ([datetime]$Invoice.dateposted).year.ToString('0000')
                $DocumentElement.dateposted.month | Should -Be ([datetime]$Invoice.dateposted).month.ToString('00')
                $DocumentElement.dateposted.day | Should -Be ([datetime]$Invoice.dateposted).day.ToString('00')

                $DocumentElement.datedue.year | Should -Be ([datetime]$Invoice.datedue).year.ToString('0000')
                $DocumentElement.datedue.month | Should -Be ([datetime]$Invoice.datedue).month.ToString('00')
                $DocumentElement.datedue.day | Should -Be ([datetime]$Invoice.datedue).day.ToString('00')        

                $DocumentElement.termname | Should -Be $Invoice.termname
                $DocumentElement.action | Should -Be $Invoice.action
                $DocumentElement.invoiceno | Should -Be $Invoice.invoiceno
                $DocumentElement.ponumber | Should -Be $Invoice.ponumber
                $DocumentElement.description | Should -Be $Invoice.description
                $DocumentElement.payto.contactname | Should -Be $Invoice.payto
                $DocumentElement.returnto.contactname | Should -Be $Invoice.returnto
                $DocumentElement.basecurr | Should -Be $Invoice.basecurr
                $DocumentElement.currency | Should -Be $Invoice.currency

                $DocumentElement.exchratedate.year | Should -Be ([datetime]$Invoice.exchratedate).year.ToString('0000')
                $DocumentElement.exchratedate.month | Should -Be ([datetime]$Invoice.exchratedate).month.ToString('00')
                $DocumentElement.exchratedate.day | Should -Be ([datetime]$Invoice.exchratedate).day.ToString('00')

                $DocumentElement.exchratetype | Should -Be $Invoice.exchratetype
                $DocumentElement.exchrate | Should -Be $Invoice.exchrate
                $DocumentElement.supdocid | Should -Be $Invoice.supdocid

                $DocumentElement.customfields.customfield.customfieldname | Should -Be $Invoice.customfields.customfieldname
                $DocumentElement.customfields.customfield.customfieldvalue | Should -Be $Invoice.customfields.customfieldvalue

                $DocumentElement.invoiceitems.lineitem.glaccountno | Should -Be $Invoice.invoiceitems.glaccountno
                $DocumentElement.invoiceitems.lineitem.amount | Should -Be $Invoice.invoiceitems.amount

            }

        }

        Context "Reverse" {
    
            it "returns the expected values" {
                # arrange
                $Invoice = [pscustomobject]@{
                    key=123
                    datereversed = '02/20/2020'
                    description = 'lorem ipsum'
                }

                # act
                $Actual = $Invoice | ConvertTo-InvoiceXml
                $DocumentElement = $Actual.DocumentElement

                # assert
                $DocumentElement.Name | Should -Be 'reverse_invoice'
                $DocumentElement.key | Should -Be $Invoice.key
                $DocumentElement.datereversed.year | Should -Be ([datetime]$Invoice.datereversed).year.ToString('0000')
                $DocumentElement.datereversed.month | Should -Be ([datetime]$Invoice.datereversed).month.ToString('00')
                $DocumentElement.datereversed.day | Should -Be ([datetime]$Invoice.datereversed).day.ToString('00')
                $DocumentElement.description | Should -Be $Invoice.description
            }
    
        }

    }

}
