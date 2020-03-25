$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/Send-Request.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Find-Object" -Tag 'unit' {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='0123456789';endpoint='https://xx.yy.cc'}

    $Object = 'GLACCOUNT'

    Context "Mandatory parameters" {

        it "has two, mandatory parameters" {
            Get-Command "Find-Object" | Should -HaveParameter Session -Mandatory
            Get-Command "Find-Object" | Should -HaveParameter Object -Mandatory -Type String
        }

        Mock Send-Request {
            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <operation>
                    <result>
                        <status>success</status>
                        <function>readByQuery</function>
                        <data listtype='$($Object.ToLower())' count='$DefaultPageSize'>
                            <$($Object.ToLower())/>
                        </data>
                    </result>
                </operation>
            </response>"
            Write-Debug $Content
            [xml]$Content
        }

        Context "-Object" {

            it "sets the function.readByQuery.object element to the specified value ($Object)" {
                # act
                Find-Object -Session $Session -Object $Object

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.object -eq $Object
                }
            }

            it "returns the expected data type" -Skip {
                # act
                $Actual = Find-Object -Session $Session -Object $Object

                Write-Debug "listtype: $( $Actual.response.operation.result.data.listtype )"

                # assert
                $Actual.response.operation.result.data.listtype | Should -Be ($Object.ToLower())
                # $Actual.response.operation.result.data.ChildNodes[0].Name | Should -Be ($Object.ToLower())
    
            }

        }

    }

    Context "Optional parameters" {

        it "has four optional parameters" {
            Get-Command "Find-Object" | Should -HaveParameter Fields -Type String -DefaultValue '*'
            Get-Command "Find-Object" | Should -HaveParameter Query -Type String -DefaultValue $null
            Get-Command "Find-Object" | Should -HaveParameter Offset -Type int # page number
            Get-Command "Find-Object" | Should -HaveParameter PageSize -Type int -DefaultValue 100 #-MinimumValue 1 -MaximumValue 2000

            # ((Get-Command "$here\$sut").Parameters['PageSize'].Attributes.Mandatory | Should Be $true
        }

    }

    Context "Default parameter values" {

        <#
        <function controlid="{{$guid}}">
            <readByQuery>
                <object>GLACCOUNT</object>
                <fields>*</fields>
                <query></query>
                <pagesize>100</pagesize>
            </readByQuery>
        </function>
        #>

        BeforeEach {

            # arrange
            Mock Send-Request {
                $Content = 
                "<?xml version='1.0' encoding='UTF-8'?>
                <response>
                    <operation>
                        <result>
                            <status>success</status>
                            <function>readByQuery</function>
                            <data listtype='$($Object.ToLower())' count='$DefaultPageSize'>
                                <$($Object.ToLower())/>
                            </data>
                        </result>
                    </operation>
                </response>"
                Write-Debug $Content
                [xml]$Content
            }

            # act
            Find-Object -Session $Session -Object $Object
        }

        Context "-Fields" {

            it "sets the function.readByQuery.fields element to its default value ('*')" {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.fields -eq '*'
                }
            }

        }

        Context "-Query" {

            it "sets the function.readByQuery.query element to its default value ('')" {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.query -eq ''
                }
            }
        }

#         Context "-Offset" {
#             it "sets the function.readByQuery.pagesize element correctly" -skip {
#                 Assert-MockCalled Send-Request -ParameterFilter {
#                 }
#             }
#         }

        Context "-PageSize" {

            it "sets the function.readByQuery.pagesize element to its default value (100)" {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.pagesize -eq 100
                }
            }

        }

    } # /context

    Context "Specified parameter values" {

        # arrange
        Mock Send-Request {
            $Content = "<?xml version='1.0' encoding='UTF-8'?>
            <response>
                <operation>
                    <result>
                        <status>success</status>
                        <function>readByQuery</function>
                        <data listtype='$($Object.ToLower())' count='$DefaultPageSize'>
                            <$($Object.ToLower())/>
                        </data>
                    </result>
                </operation>
            </response>"
            Write-Debug $Content
            [xml]$Content
        }

        Context "-Object" {

            Context "Valid objects" {

                # arrange
                $Object = 'PROJECT'

                it "sets the function.readByQuery.fields element to the specified value ($Object)" {
                    
                    # act
                    Find-Object -Session $Session -Object $Object

                    # assert
                    Assert-MockCalled Send-Request -ParameterFilter {
                        $xml = [xml]$Function
                        $xml.function.readByQuery.object -eq $Object
                    }
                }

            }

            Context "Invalid object" {

                it "throw an exception" -skip {
                    # act/assert
                    {Find-Object -Session $Session -Object $Object 'INVALID'} | Should -Throw    
                }
    
            }

        }

        Context "-Fields" {

            # arrange
            $Fields = "RECORDNO,ACCOUNTNO"

            it "sets the function.readByQuery.fields element to the specified value ($Fields)" {
                
                # act
                Find-Object -Session $Session -Object $Object -Fields $Fields

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.fields -eq $Fields
                }
            }

        }

        Context "-Query" {

            # arrange
            $Query = "RECORDID='00000'"

            it "sets the function.readByQuery.query element to the specified value ($Query)" {
                # act
                Find-Object -Session $Session -Object $Object -Query $Query

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.query -eq $Query
                }
            }
        }

        Context "-PageSize" {

            # arrange
            $PageSize = 50

            it "sets the function.readByQuery.pagesize element to the specified value ($PageSize)" {
                # act
                Find-Object -Session $Session -Object $Object -PageSize $PageSize

                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.pagesize -eq $PageSize
                }
            }

        }

    }

# <#
# <?xml version="1.0" encoding="UTF-8"?>
# <response>
#     <operation>
#         <result>
#             <status>success</status>
#             <function>readMore</function>
#             <controlid>7d5ba1c5-6cb4-4000-b083-46af6dbb3a4b</controlid>
#             <data listtype="glaccount" count="50" totalcount="94" numremaining="44" resultId="7765623638XlglD9MIYIQQc4fECC5@LwAAABU4">
#                 <glaccount>
#                     <RECORDNO>101</RECORDNO>
#                     <ACCOUNTNO>1004</ACCOUNTNO>
#                     <TITLE>American Express</TITLE>
#                     <ACCOUNTTYPE>balancesheet</ACCOUNTTYPE>
#                 </glaccount>
#             </data>
#         </result>
#     </operation>
# </response>
# #>
#     Context "Offset" {

#         $Offset = 50
#         Mock Send-Request {
#             $Content = [xml]"<?xml version='1.0' encoding='UTF-8'?>
#             <response>
#                 <operation>
#                     <result>
#                         <status>success</status>
#                         <function>readMore</function>
#                         <controlid>7d5ba1c5-6cb4-4000-b083-46af6dbb3a4b</controlid>
#                         <data listtype='glaccount' count='50' totalcount='94' numremaining='44' resultId='7765623638XlglD9MIYIQQc4fECC5@LwAAABU4'>
#                             <glaccount>
#                                 <RECORDNO>101</RECORDNO>
#                                 <ACCOUNTNO>1004</ACCOUNTNO>
#                                 <TITLE>American Express</TITLE>
#                                 <ACCOUNTTYPE>balancesheet</ACCOUNTTYPE>
#                             </glaccount>
#                         </data>
#                     </result>
#                 </operation>
#             </response>"
#             Write-Debug $Content
#             $Content
#         }

#         it "sets the requests 'pagesize' element" -Skip {
#             Assert-MockCalled Send-Request -ParameterFilter {
#                 $function = [xml]$Function.function
#                 $function.pagesize -eq $Offset
#             }
#         }

#         it "returns the selected page" -Skip {
#             Assert-MockCalled Send-Request -ParameterFilter {
#                 $function = [xml]$Function.function
#                 $function.pagesize -eq $Offset
#             }
#         }

#     }

#     Context "PageSize" {

#         # arrange
#         $PageSize = 50
#         Mock Send-Request {
#             $Content = [xml]"<?xml version='1.0' encoding='UTF-8'?>
#             <response>
#                 <operation>
#                     <result>
#                         <status>success</status>
#                         <function>readMore</function>
#                         <controlid>7d5ba1c5-6cb4-4000-b083-46af6dbb3a4b</controlid>
#                         <data listtype='glaccount' count='$PageSize' totalcount='94' numremaining='44' resultId='7765623638XlglD9MIYIQQc4fECC5@LwAAABU4'>
#                             <glaccount></glaccount>
#                         </data>
#                     </result>
#                 </operation>
#             </response>"
#             Write-Debug $Content
#             $Content
#         }

#                 <#
#         <function controlid="{{$guid}}">
#             <readMore><resultId>7765623638XlglD9MIYIQQc4fECC5@LwAAABU4</resultId></readMore>
#             <readByQuery>
#                 <object>GLACCOUNT</object>
#                 <fields>RECORDNO,ACCOUNTNO,TITLE,ACCOUNTTYPE</fields>
#                 <query></query>
#                 <pagesize>50</pagesize>
#             </readByQuery>
#         </function>
#         #>
#         it "sets the requests 'pagesize' element" -Skip {
#             Assert-MockCalled Send-Request -ParameterFilter {
#                 $function = [xml]$Function.function
#                 $function.readByQuery.pagesize -eq $PageSize
#             }
#         }

#         it "returns the specified number of records" -Skip {
#             # act 
#             [xml]$Actual = Find-Object -Session $Session

#             #assert
#             $Actual.response.operation.result.data.count | Should -Be $PageSize

#         }

#     }

}
