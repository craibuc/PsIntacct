$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
# $Parent = Split-Path -Parent $here
# . "$Parent/Private/ConvertTo-CustomFieldXml.ps1"
# . "$Parent/Private/ConvertTo-InvoiceItemXml.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-InvoiceXml" -Tag 'unit' {

    Context "Parameter validation" {

        $Command = Get-Command "ConvertTo-InvoiceXml"

        Context "Create" {

            $DueDate = @{ParameterSetName='Create.datedue';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $TermName = @{ParameterSetName='Create.termname';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}

            $DueDateOptional = @{ParameterSetName='Create.datedue';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            $TermNameOptional = @{ParameterSetName='Create.termname';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}

            @{ParameterName='customerid';Type=[string];ParameterSets = $DueDate,$TermName},
            @{ParameterName='datecreated';Type=[datetime];ParameterSets = $DueDate,$TermName},
            @{ParameterName='dateposted';Type=[datetime];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='datedue';Type=[datetime];ParameterSets = $DueDate},
            @{ParameterName='termname';Type=[string];ParameterSets = $TermName},
            @{ParameterName='batchkey';Type=[int];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='action';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='invoiceno';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='ponumber';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='description';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='externalid';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='billto';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='shipto';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='basecurr';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='currency';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='exchratedate';Type=[datetime];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='exchratetype';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='exchrate';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='nogl';Type=[bool];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='supdocid';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='customfields';Type=[pscustomobject[]];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='invoiceitems';Type=[pscustomobject[]];ParameterSets = $DueDate,$TermName} |
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

            $DueDate = @{ParameterSetName='Update.datedue';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}
            $TermName = @{ParameterSetName='Update.termname';IsMandatory=$true;ValueFromPipelineByPropertyName=$true}

            $DueDateOptional = @{ParameterSetName='Update.datedue';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}
            $TermNameOptional = @{ParameterSetName='Update.termname';IsMandatory=$false;ValueFromPipelineByPropertyName=$true}

            @{ParameterName='key';Type=[int];ParameterSets = $DueDate,$TermName},
            @{ParameterName='customerid';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='datecreated';Type=[datetime];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='dateposted';Type=[datetime];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='datedue';Type=[datetime];ParameterSets = $DueDate},
            @{ParameterName='termname';Type=[string];ParameterSets = $TermName},
            @{ParameterName='action';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='invoiceno';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='ponumber';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='description';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='payto';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='returnto';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='basecurr';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='currency';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='exchratedate';Type=[datetime];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='exchratetype';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='exchrate';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='supdocid';Type=[string];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='customfields';Type=[pscustomobject[]];ParameterSets = $DueDateOptional,$TermNameOptional},
            @{ParameterName='invoiceitems';Type=[pscustomobject[]];ParameterSets = $DueDateOptional,$TermNameOptional} |
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

            $TestCases = @(
                @{PropertyName='datedue';PropertyValue='02/20/2020'}
                @{PropertyName='termname';PropertyValue='Net 30'}
            )

            it "returns the expected values when using '<PropertyName>'" -TestCases $TestCases {
                param($PropertyName, $PropertyValue, $PropertyType)

                # arrange
                $Invoice | Add-Member -NotePropertyName $PropertyName -NotePropertyValue $PropertyValue

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

                switch ($PropertyName)
                {
                    'datedue'
                    {
                        $DocumentElement.datedue.year | Should -Be ([datetime]$Invoice.datedue).year.ToString('0000')
                        $DocumentElement.datedue.month | Should -Be ([datetime]$Invoice.datedue).month.ToString('00')
                        $DocumentElement.datedue.day | Should -Be ([datetime]$Invoice.datedue).day.ToString('00')
        
                    }
                    'termname'
                    {
                        $DocumentElement.termname | Should -Be $Invoice.termname
                    }
                }

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

            $TestCases = @(
                @{PropertyName='datedue';PropertyValue='02/20/2020'}
                @{PropertyName='termname';PropertyValue='Net 30'}
            )

            it "returns the expected values when using '<PropertyName>'" -TestCases $TestCases {
                param($PropertyName, $PropertyValue, $PropertyType)

                # arrange
                $Invoice | Add-Member -NotePropertyName $PropertyName -NotePropertyValue $PropertyValue

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

                switch ($PropertyName)
                {
                    'datedue'
                    {
                        $DocumentElement.datedue.year | Should -Be ([datetime]$Invoice.datedue).year.ToString('0000')
                        $DocumentElement.datedue.month | Should -Be ([datetime]$Invoice.datedue).month.ToString('00')
                        $DocumentElement.datedue.day | Should -Be ([datetime]$Invoice.datedue).day.ToString('00')
        
                    }
                    'termname'
                    {
                        $DocumentElement.termname | Should -Be $Invoice.termname
                    }
                }

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
