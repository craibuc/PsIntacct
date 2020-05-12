# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Remove-Object.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Remove-Object.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

Describe "Remove-Object" {

    Context "Parameter validation" {
        $Command = Get-Command 'Remove-Object'

        Context "Session" {
            $ParameterName = 'Session'

            It "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "Object" {
            $ParameterName = 'Object'

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "supports values from the pipeline by name" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

        Context "Id" {
            $ParameterName = 'Id'

            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "supports values from the pipeline by name" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
            It "has an alias of RECORDNO" {
                $Command.Parameters[$ParameterName].Aliases | Should -Contain 'RECORDNO'
            }
        }

        Context "WhatIf" {
            it "supports ShouldProcess" {
            }
        }

    }

    Context "Success" {

        # arrange
        $Credential = New-MockObject -Type PsCredential
        $Session = [PsCustomObject]@{Credential=$Credential;sessionid='0123456789';endpoint='https://xx.yy.cc'}

        $CUSTOMER = [pscustomobject]@{
            OBJECT = 'CUSTOMER'
            RECORDNO = 123
        }

        Mock Send-Request {
            $Content = 
            "<response>
                <control/>
                <operation>
                    <authentication/>
                    <result>
                        <status>success</status>
                        <function>delete</function>
                        <controlid>ebd8d1ec-594b-455d-ae9e-53b62665e201</controlid>
                    </result>
                </operation>
            </response>"
            [xml]$Content
        } # /mock

        BeforeEach {
            # act
            $Actual = $CUSTOMER | Remove-Object -Session $Session
        }

        it "calls Send-Request with the correct values" {
            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $xml = [xml]$Function
                $xml.function.delete.object -eq $CUSTOMER.Object -and
                $xml.function.delete.keys -eq $CUSTOMER.RECORDNO
            }
        }

        it "returns a status of 'success" {
            # assert
            $Actual.status | Should -Be 'success'
        }

        it "returns a function of 'delete'" {
            # assert
            $Actual.function | Should -Be 'delete'
        }
        it "returns a controlid" {
            # assert
            $Actual.controlid | Should -Not -BeNullOrEmpty
        }

    } # /Context

    Context "Failure - Invalid Object" {

        # arrange
        $Credential = New-MockObject -Type PsCredential
        $Session = [PsCustomObject]@{Credential=$Credential;sessionid='0123456789';endpoint='https://xx.yy.cc'}

        $CUSTOMER = [pscustomobject]@{
            OBJECT = 'INVALID'
            RECORDNO = 1234
        }

        Mock Send-Request {
            $Content = 
            "<response>
            <control/>
            <operation>
                <authentication/>
                <result>
                    <status>failure</status>
                    <function>delete</function>
                    <controlid>6c8272ad-83f0-413c-b3c9-bb724128d53c</controlid>
                    <errormessage>
                        <error>
                            <errorno>WS</errorno>
                            <description></description>
                            <description2>Object definition $( $CUSTOMER.OBJECT ) not found</description2>
                            <correction></correction>
                        </error>
                    </errormessage>
                </result>
            </operation>
        </response>"
            [xml]$Content
        } # /Mock

        it "generates a non-terminating error" {

            # assert
            { $CUSTOMER | Remove-Object -Session $Session -ErrorAction Stop } | Should -Throw "Object definition $( $CUSTOMER.OBJECT ) not found"
        }

    } # /Context

    Context "Failure - Invalid Id" {

        # arrange
        $Credential = New-MockObject -Type PsCredential
        $Session = [PsCustomObject]@{Credential=$Credential;sessionid='0123456789';endpoint='https://xx.yy.cc'}

        $CUSTOMER = [pscustomobject]@{
            OBJECT = 'CUSTOMER'
            RECORDNO = 99999
        }

        Mock Send-Request {
            $Content = 
            "<response>
                <control/>
                <operation>
                    <authentication/>
                    <result>
                        <status>failure</status>
                        <function>delete</function>
                        <controlid>e56a44dd-f252-4c25-8df9-6e151146f374</controlid>
                        <errormessage>
                            <error>
                                <errorno>BL01001973</errorno>
                                <description></description>
                                <description2>Cannot find customer with key &#039;$( $CUSTOMER.RECORDNO )&#039; to delete.</description2>
                                <correction></correction>
                            </error>
                        </errormessage>
                    </result>
                </operation>
            </response>"
            [xml]$Content
        } # /Mock

        it "generates a non-terminating error" {

            # assert
            { $CUSTOMER | Remove-Object -Session $Session -ErrorAction Stop } | Should -Throw "Cannot find customer with key '$( $CUSTOMER.RECORDNO )' to delete."
        }

    } # /Context

}
