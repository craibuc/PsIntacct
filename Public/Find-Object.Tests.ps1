$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/Send-Request.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Find-Object" {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='0123456789';endpoint='https://xx.yy.cc'}

    $DefaultPageSize = 100

    Context "Parameters" {

        it "has one mandatory parameter" -skip {
            Get-Command "Find-Object" | Should -HaveParameter Session -Mandatory
            Get-Command "Find-Object" | Should -HaveParameter Object -Mandatory -Type String
        }
    
        it "has four optional parameters" -skip {
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

        # arrange
        $Object = 'GLACCOUNT'

        BeforeEach {

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

            # act
            $Actual = Find-Object -Session $Session -Object $Object
        }

        Context "-Object" {

            it "sets the function.readByQuery.object element correctly" {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.object -eq $Object
                }
            }

            it "returns the expected data type" {
                Write-Debug "listtype: $()"
                # assert
                # $Actual.response.operation.result.data.listtype | Should -Be ($Object.ToLower())
                # $Actual.response.operation.result.data.ChildNodes[0].Name | Should -Be ($Object.ToLower())
            }
        }

        Context "-Fields" {
            it "sets the function.readByQuery.fields element correctly" -skip {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.fields -eq '*'
                }
            }
        }

        Context "-Query" {
            it "sets the function.readByQuery.query element correctly" -skip {
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

            it "sets the function.readByQuery.pagesize element correctly" -skip {
                # assert
                Assert-MockCalled Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.pagesize -eq $DefaultPageSize
                }
            }

            it "returns the expected data type" -skip {
                # assert
                $Actual.response.operation.result.data.listtype | Should -Be ($Object.ToLower())
                $Actual.response.operation.result.data.ChildNodes[0].Name | Should -Be ($Object.ToLower())
            }

        }

    } # /context

    Context "Default parameter values" {

        # arrange        
        Mock Send-Request

#         <#
#         <function controlid="{{$guid}}">
#         <readMore><resultId>7765623638XlglD9MIYIQQc4fECC5@LwAAABU4</resultId></readMore>
#         <!--<readByQuery>-->
#         <!--    <object>GLACCOUNT</object>-->
#         <!--    <fields>RECORDNO,ACCOUNTNO,TITLE,ACCOUNTTYPE</fields>-->
#         <!--    <query></query>-->
#         <!--    <pagesize>50</pagesize>-->
#         <!--</readByQuery>-->
#         </function>
#         #>
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
