# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# New-StatisticalAccount.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/New-StatisticalAccount.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

Describe "New-StatisticalAccount" -tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://x.y.z'}

    Context "General" {

        it "has 3, mandatory parameters" {
            Get-Command "New-StatisticalAccount" | Should -HaveParameter Session -Mandatory
            Get-Command "New-StatisticalAccount" | Should -HaveParameter ACCOUNTNO -Mandatory
            Get-Command "New-StatisticalAccount" | Should -HaveParameter TITLE -Mandatory
        }

    }

    BeforeEach {
        $Data = [pscustomobject]@{
            ACCOUNTNO=9000
            TITLE='Headcount'
        }    
    }

    Context "Mandatory parameters" {

        it "calls Send-Request with the expected parameter values" {

            # arrange
            Mock Send-Request

            # act
            $Data | New-StatisticalAccount -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $element = ([xml]$Function).function.create.STATACCOUNT
                $element.ACCOUNTNO -eq $Data.ACCOUNTNO -and 
                $element.TITLE -eq $Data.TITLE -and 
                # optional
                $element.CATEGORY -eq $null -and 
                $element.ACCOUNTTYPE -eq 'forperiod' -and 
                $element.STATUS -eq 'active' -and 
                $element.REQUIREDEPT -eq $null -and 
                $element.REQUIRELOC -eq $null -and 
                $element.REQUIREPROJECT -eq $null -and 
                $element.REQUIRECUSTOMER -eq $null -and 
                $element.REQUIREVENDOR -eq $null -and 
                $element.REQUIREEMPLOYEE -eq $null -and 
                $element.REQUIREITEM -eq $null -and 
                $element.REQUIRECLASS -eq $null -and 
                $element.REQUIRETASK -eq $null -and 
                $element.REQUIREGLDIM -eq $null
            }

        } # /it

    } # /context

    Context "Optional parameters" {

        it "calls Send-Request with the expected parameter values" {

            # arrange
            Mock Send-Request

            # arrange
            $Data | Add-Member -MemberType NoteProperty -Name 'CATEGORY' -Value 'something'
            $Data | Add-Member -MemberType NoteProperty -Name 'ACCOUNTTYPE' -Value 'cumulative'
            $Data | Add-Member -MemberType NoteProperty -Name 'STATUS' -Value 'inactive'
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIREDEPT' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIRELOC' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIREPROJECT' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIRECUSTOMER' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIREVENDOR' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIREEMPLOYEE' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIREITEM' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIRECLASS' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIRETASK' -Value $true
            $Data | Add-Member -MemberType NoteProperty -Name 'REQUIREGLDIM' -Value $true

            # act
            $Data | New-StatisticalAccount -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $element = ([xml]$Function).function.create.STATACCOUNT
                $element.CATEGORY -eq $Data.CATEGORY -and 
                $element.ACCOUNTTYPE -eq $Data.ACCOUNTTYPE -and 
                $element.STATUS -eq $Data.STATUS -and 
                $element.REQUIREDEPT -eq $true -and 
                $element.REQUIRELOC -eq $true -and 
                $element.REQUIREPROJECT -eq $true -and 
                $element.REQUIRECUSTOMER -eq $true -and 
                $element.REQUIREVENDOR -eq $true -and 
                $element.REQUIREEMPLOYEE -eq $true -and 
                $element.REQUIREITEM -eq $true -and 
                $element.REQUIRECLASS -eq $true -and 
                $element.REQUIRETASK -eq $true -and 
                $element.REQUIREGLDIM -eq $true
            }

        } # /it

    } # /context

    Context "Response - Success" {

        it "returns the specified ACCOUNTNO and a RECORDNO" {

            # arrange
            Mock Send-Request {

                $Content = "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <control>
                        <status>success</status>
                    </control>
                    <operation>
                        <authentication>
                            <status>success</status>
                        </authentication>
                        <result>
                            <status>success</status>
                            <function>create</function>
                            <controlid>testFunctionId</controlid>
                            <data listtype='objects' count='1'>
                                <stataccount>
                                    <RECORDNO>123</RECORDNO>
                                    <ACCOUNTNO>$($Data.ACCOUNTNO)</ACCOUNTNO>
                                </stataccount>
                            </data>
                        </result>
                    </operation>
                </response>"
                # Write-Debug $Content
                [xml]$Content

            }

            # act
            $Actual = $Data | New-StatisticalAccount -Session $Session

            # assert
            $Actual.ACCOUNTNO | Should -Be $Data.ACCOUNTNO
            $Actual.RECORDNO | Should -Not -BeNullOrEmpty
        }

    } # /context

    Context "Create multiple" {

        it "returns the specified ACCOUNTNO and a RECORDNO" {

            # arrange
            $Data = @( 
                [pscustomobject]@{ACCOUNTNO=9000;TITLE='Foo'}
                [pscustomobject]@{ACCOUNTNO=9999;TITLE='Bar'}
            )

            Mock Send-Request {

                $Content = "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <control>
                        <status>success</status>
                    </control>
                    <operation>
                        <authentication>
                            <status>success</status>
                        </authentication>
                        <result>
                            <status>success</status>
                            <function>create</function>
                            <controlid>testFunctionId</controlid>
                            <data listtype='objects' count='2'>
                                <stataccount>
                                    <RECORDNO>100</RECORDNO>
                                    <ACCOUNTNO>9000</ACCOUNTNO>
                                </stataccount>
                                <stataccount>
                                    <RECORDNO>200</RECORDNO>
                                    <ACCOUNTNO>9999</ACCOUNTNO>
                                </stataccount>
                            </data>
                        </result>
                    </operation>
                </response>"
                # Write-Debug $Content
                [xml]$Content

            }
        
            # act
            $Data | New-StatisticalAccount -Session $Session | ForEach-Object {
                # assert
                $_.ACCOUNTNO | Should -Not -BeNullOrEmpty
                $_.RECORDNO | Should -Not -BeNullOrEmpty
            }

        }

    }

    Context "Response - Failure" {

        it "throws a non-terminating error" {

            # arrange
            Mock Write-Error
            Mock Send-Request {

                $Content = "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <operation>
                        <result>
                            <status>failure</status>
                            <data listtype='objects' count='0'/>
                            <errormessage>
                                <error>
                                    <errorno>BL01001973</errorno>
                                    <description>Duplicate account number</description>
                                    <description2>The account number &#039;$($Data.ACCOUNTNO)&#039; already exists</description2>
                                    <correction>Enter unique account number</correction>
                                </error>
                                <error>
                                    <errorno>BL01001973</errorno>
                                    <description></description>
                                    <description2>Could not create Statistical Account record!</description2>
                                    <correction></correction>
                                </error>
                            </errormessage>
                        </result>
                    </operation>
                </response>"
                # Write-Debug $Content
                [xml]$Content

            }

            # act
            $Data | New-StatisticalAccount -Session $Session

            # assert
            Assert-MockCalled Write-Error -Times 2 -Exactly

            # redirect stderr to stdout
            # $Data | New-StatisticalAccount -Session $Session 2>&1 > $null | Should -HaveCount 2
        }

    }
    
}
