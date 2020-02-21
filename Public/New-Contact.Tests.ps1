$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-Contact" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

    $Contact = [pscustomobject]@{
        ContactName='Bill Lumbergh'
        PrintAs='Lumbergh, Bill'
    }

    Context "Required fields" {

        # arrange    
        Mock ConvertTo-PlainText {'password'}
        Mock Invoke-WebRequest

        it "creates the expected Xml request" {
            # act
            $Contact | New-Contact -Session $Session

            # assert
            Assert-MockCalled ConvertTo-PlainText -Times 1
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq $Session.endpoint }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $ContentType -eq 'application/xml' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $xml = ([xml]$Body).request.operation.content.function
                $xml.create.CONTACT.CONTACTNAME -eq $Contact.ContactName -and 
                $xml.create.CONTACT.PRINTAS -eq $Contact.PrintAs -and 
                $xml.create.CONTACT.COMPANYNAME -eq '' -and 
                $xml.create.CONTACT.TAXABLE -eq $true -and # defaults to $true
                $xml.create.CONTACT.TAXGROUP -eq '' -and
                # $xml.create.CONTACT.PREFIX -eq '' -and
                $xml.create.CONTACT.FIRSTNAME -eq '' -and
                $xml.create.CONTACT.INITIAL -eq '' -and
                $xml.create.CONTACT.LASTNAME -eq '' -and
                $xml.create.CONTACT.PHONE1 -eq '' -and
                $xml.create.CONTACT.PHONE2 -eq '' -and
                $xml.create.CONTACT.CELLPHONE -eq '' -and
                $xml.create.CONTACT.PAGER -eq '' -and
                $xml.create.CONTACT.FAX -eq '' -and
                $xml.create.CONTACT.EMAIL1 -eq '' -and
                $xml.create.CONTACT.EMAIL2 -eq '' -and
                $xml.create.CONTACT.URL1 -eq '' -and
                $xml.create.CONTACT.URL2 -eq '' -and
                $xml.create.CONTACT.Status -eq 'active' # defaults to active
            }
        }

    }

    Context "Required fields" {

        # arrange
        $Contact | Add-Member -MemberType NoteProperty -Name 'CompanyName' -Value 'Acme, Inc.'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Taxable' -Value $true
        $Contact | Add-Member -MemberType NoteProperty -Name 'TaxGroup' -Value 'Billionaires'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Prefix' -Value 'Mr.'
        $Contact | Add-Member -MemberType NoteProperty -Name 'FirstName' -Value 'John'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Initial' -Value 'Q.'
        $Contact | Add-Member -MemberType NoteProperty -Name 'LastName' -Value 'Public'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Phone1' -Value '800-555-1212'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Phone2' -Value '800-555-1212'
        $Contact | Add-Member -MemberType NoteProperty -Name 'CellPhone' -Value '800-555-1212'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Pager' -Value '800-555-1212'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Fax' -Value '800-555-1212'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Email1' -Value 'john.q.public@domain.tld'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Email2' -Value 'john.q.public@domain.tld'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Url1' -Value 'https://domain.tld/'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Url2' -Value 'https://domain.tld/'
        $Contact | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'active'

        Mock ConvertTo-PlainText {'password'}
        Mock Invoke-WebRequest

        it "creates the expected Xml request" {
            # act
            $Contact | New-Contact -Session $Session

            # assert
            Assert-MockCalled ConvertTo-PlainText -Times 1
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq $Session.endpoint }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $ContentType -eq 'application/xml' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $xml = ([xml]$Body).request.operation.content.function
                $xml.create.CONTACT.COMPANYNAME -eq $Contact.CompanyName -and
                $xml.create.CONTACT.TAXABLE -eq $Contact.Taxable -and
                $xml.create.CONTACT.TAXGROUP -eq $Contact.TaxGroup -and
                # $xml.create.CONTACT.PREFIX -eq $Contact.Prefix #-and # want PREFIX element, not XmlElement.Prefix property
                $xml.create.CONTACT.FIRSTNAME -eq $Contact.FirstName -and
                $xml.create.CONTACT.INITIAL -eq $Contact.Initial -and
                $xml.create.CONTACT.LASTNAME -eq $Contact.LastName -and
                $xml.create.CONTACT.PHONE1 -eq $Contact.Phone1 -and
                $xml.create.CONTACT.PHONE2 -eq $Contact.Phone2 -and
                $xml.create.CONTACT.CELLPHONE -eq $Contact.CellPhone -and
                $xml.create.CONTACT.PAGER -eq $Contact.Pager -and
                $xml.create.CONTACT.FAX -eq $Contact.Fax -and
                $xml.create.CONTACT.EMAIL1 -eq $Contact.Email1 -and
                $xml.create.CONTACT.EMAIL2 -eq $Contact.Email2 -and
                $xml.create.CONTACT.URL1 -eq $Contact.Url1 -and
                $xml.create.CONTACT.URL2 -eq $Contact.Url2 -and
                $xml.create.CONTACT.Status -eq $Contact.Status #-and

            }
        }

    }

    # Context "Success" {

    #     # arrange
    #     $Name = 'Foo'

    #     Mock Invoke-WebRequest {

    #         [PSCustomObject]@{
    #             Content = 
    #             '<?xml version="1.0" encoding="UTF-8"?>
    #             <response>
    #                 <control><status>success</status></control>
    #                 <operation>
    #                     <result>
    #                         <status>success</status>
    #                         <data listtype="CONTACT" count="1">
    #                             <contact><RECORDNO>22</RECORDNO><CONTACTNAME>Bill Lumbergh</CONTACTNAME></contact>
    #                         </data>
    #                     </result>
    #                 </operation>
    #             </response>'
    #         }

    #     }

    #     it "returns the expected data" {
    #         # act
    #         $Actual = Get-Contact -Session $Session -Name $Name

    #         # assert
    #         $Actual.Name | Should -Be 'contact'
    #         $Actual.RECORDNO | Should -Not -BeNullOrEmpty
    #         $Actual.CONTACTNAME | Should -Not -BeNullOrEmpty

    #     }
    # }

}