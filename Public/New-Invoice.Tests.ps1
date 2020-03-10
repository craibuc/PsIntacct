$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-Invoice" -tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

    $Invoice = [pscustomobject]@{
        CustomerId='CUSTOMER1'
        DateCreated= '06/30/2015'
        # InvoiceItems=@()
    }
    
    Context "Required fields" {

        # arrange    
        Mock Send-Request

        it "has 3, mandatory parameters" {

            Get-Command "New-Invoice" | Should -HaveParameter Session -Mandatory
            Get-Command "New-Invoice" | Should -HaveParameter CustomerId -Mandatory
            Get-Command "New-Invoice" | Should -HaveParameter DateCreated -Mandatory
            # Get-Command "New-Invoice" | Should -HaveParameter InvoiceItems -Mandatory

        }

        it "calls Send-Request with the expected parameter values" {
            # act
            $Invoice | New-Invoice -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter { [xml]$Function }
            Assert-MockCalled Send-Request -ParameterFilter {
                $create = ([xml]$Function).function.create_invoice
                $create.customerid -eq $Invoice.CustomerId -and 
                $create.datecreated.year -eq ([datetime]$Invoice.DateCreated).ToString('yyyy') -and 
                $create.datecreated.month -eq ([datetime]$Invoice.DateCreated).ToString('MM') -and 
                $create.datecreated.day -eq ([datetime]$Invoice.DateCreated).ToString('dd') # -and 
            #     # $create.invoiceitems -eq $Invoice.InvoiceItems -and
            }

        }

    } # /context

    Context "Optional parameters" {

        # arrange
        Mock Send-Request

        $Invoice | Add-Member -MemberType NoteProperty -Name 'DatePosted' -Value '06/30/2015'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'DateDue' -Value '09/24/2020'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'Terms' -Value 'N30'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'BatchKey' -Value '20323'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'Action' -Value 'Submit'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'InvoiceNo' -Value '234'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'PoNumber' -Value '234235'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'Description' -Value 'Some description'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'ExternalId' -Value '20394'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'BillTo' -Value '28952'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'ShipTo' -Value '289533'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'BaseCurrency' -Value 'USD'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'Currency' -Value 'USD'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'ExchangeRateDate' -Value '06/30/2015'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'ExchangeRateType' -Value 'Intacct Daily Rate'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'ExchangeRate' -Value '0.98'
        $Invoice | Add-Member -MemberType NoteProperty -Name 'NoGL' -Value $true
        $Invoice | Add-Member -MemberType NoteProperty -Name 'DocumentId' -Value '6942'

        $CustomField = @{customfield1='customvalue1';customfield2='customvalue2'}
        $Invoice | Add-Member -MemberType NoteProperty -Name 'CustomField' -Value $CustomField

        it "calls Send-Request with the expected parameter values" {
            # act
            $Invoice | New-Invoice -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter { [xml]$Function }

            Assert-MockCalled Send-Request -ParameterFilter {
                $create = ([xml]$Function).function.create_invoice

                $create.dateposted.year -eq ([datetime]$Invoice.DatePosted).ToString('yyyy') -and
                $create.dateposted.month -eq ([datetime]$Invoice.DatePosted).ToString('MM') -and 
                $create.dateposted.day -eq ([datetime]$Invoice.DatePosted).ToString('dd') -and 

                $create.datedue.year -eq ([datetime]$Invoice.DateDue).ToString('yyyy') -and
                $create.datedue.month -eq ([datetime]$Invoice.DateDue).ToString('MM') -and 
                $create.datedue.day -eq ([datetime]$Invoice.DateDue).ToString('dd') -and 

                $create.termname -eq $Invoice.Terms -and 
                $create.batchkey -eq $Invoice.BatchKey -and 
                $create.action -eq $Invoice.action -and 
                $create.invoiceno -eq $Invoice.InvoiceNo -and 
                $create.ponumber -eq $Invoice.PoNumber -and 
                $create.description -eq $Invoice.Description -and 
                $create.externalid -eq $Invoice.ExternalId -and 

                $create.billto.contactname -eq $Invoice.BillTo -and 
                $create.shipto.contactname -eq $Invoice.ShipTo -and 

                $create.basecurr -eq $Invoice.BaseCurrency -and 
                $create.currency -eq $Invoice.Currency -and 

                $create.exchratedate.year -eq ([datetime]$Invoice.ExchangeRateDate).ToString('yyyy') -and
                $create.exchratedate.month -eq ([datetime]$Invoice.ExchangeRateDate).ToString('MM') -and 
                $create.exchratedate.day -eq ([datetime]$Invoice.ExchangeRateDate).ToString('dd') -and 

                $create.exchratetype -eq $Invoice.ExchangeRateType -and 
                $create.exchrate -eq $Invoice.ExchangeRate -and 

                $create.nogl -eq $Invoice.NoGL -and 
                $create.supdocid -eq $Invoice.DocumentId -and 
                
                $create.customfields.customfield[0].customfieldvalue -eq $CustomField.customfield1 -and 
                $create.customfields.customfield[1].customfieldvalue -eq $CustomField.customfield2 # -and 
                
            } # /assert

        } # /it
    } # /context

}