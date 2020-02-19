$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/ConvertTo-PlainText.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-Contact" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}

    Context "ByID" {

        # arrange
        $Id = 123
        
        Mock ConvertTo-PlainText {'password'}
        Mock Invoke-WebRequest

        it "creates the expected Xml request" {
            # act
            Get-Contact -Session $Session -Id $Id

            # assert
            Assert-MockCalled ConvertTo-PlainText -Times 1
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq $Session.endpoint }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $ContentType -eq 'application/xml' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $xml = ([xml]$Body).request.operation.content.function
                $xml.ChildNodes[0].ToString() -eq 'read'
                $xml.read.object.ToString() -eq 'CONTACT'
                $xml.read.keys.ToString() -eq $Id
                $xml.read.fields.ToString() -eq '*'
            }
        }

    }

    Context "ByName" {

        # arrange
        $Name = 'Foo'
        
        Mock ConvertTo-PlainText {'password'}
        Mock Invoke-WebRequest

        it "creates the expected Xml request" {
            # act
            Get-Contact -Session $Session -Name $Name

            # assert
            Assert-MockCalled ConvertTo-PlainText -Times 1
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $Uri -eq $Session.endpoint }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { $ContentType -eq 'application/xml' }
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $xml = ([xml]$Body).request.operation.content.function
                $xml.ChildNodes[0].ToString() -eq 'readByName'
                $xml.readByName.object.ToString() -eq 'CONTACT'
                $xml.readByName.keys.ToString() -eq $Name
                $xml.readByName.fields.ToString() -eq '*'
            }
        }

    }

    Context "Success" {

        # arrange
        $Name = 'Foo'

        Mock Invoke-WebRequest {

            [PSCustomObject]@{
                Content = 
                '<?xml version="1.0" encoding="UTF-8"?>
                <response>
                    <control><status>success</status></control>
                    <operation>
                        <result>
                            <status>success</status>
                            <data listtype="CONTACT" count="1">
                                <contact><RECORDNO>22</RECORDNO><CONTACTNAME>Bill Lumbergh</CONTACTNAME></contact>
                            </data>
                        </result>
                    </operation>
                </response>'
            }

        }

        it "returns the expected data" {
            # act
            $Actual = Get-Contact -Session $Session -Name $Name

            # assert
            $Actual.Name | Should -Be 'contact'
            $Actual.RECORDNO | Should -Not -BeNullOrEmpty
            $Actual.CONTACTNAME | Should -Not -BeNullOrEmpty

        }
    }

    Context "Failure" {

        # arrange
        $Name = 'Foo'
        $Description2='lorem ipsum'

        Mock Invoke-WebRequest {

            [PSCustomObject]@{
                Content = 
                "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <control><status>failure</status></control>
                    <errormessage>
                        <error><description2>$Description2</description2></error>
                    </errormessage>
                </response>"
            }

        }

        it "throws an exception with the expected text" {
            # act / assert
            {Get-Contact -Session $Session -Name $Name -ErrorAction Stop } | Should -Throw $Description2
        }
    }
}