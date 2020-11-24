BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsIntacct/PsIntacct/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dependencies
    . (Join-Path $PrivatePath "Send-Request.ps1")

    # Find-Object.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Find-Object.ps1
    . (Join-Path $PublicPath $sut)
}

Describe "Find-Object" -Tag 'unit' {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Find-Object'
        }

        Context "Session" {
            BeforeAll {
                $ParameterName = 'Session'
            }

            it "is a [pscustomobject]" {
                $Command | Should -HaveParameter $ParameterName -Type pscustomobject
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "Object" {
            BeforeAll {
                $ParameterName = 'Object'
            }

            it "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "Fields" {
            BeforeAll {
                $ParameterName = 'Fields'
            }

            it "is a [object]" {
                $Command | Should -HaveParameter $ParameterName -Type object
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            # it "has a default value of *" {
            #     $Command | Should -HaveParameter $ParameterName -DefaultValue '*'
            # }
        }

        Context "Offset" {
            BeforeAll {
                $ParameterName = 'Offset'
            }

            it "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "PageSize" {
            BeforeAll {
                $ParameterName = 'PageSize'
            }

            it "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            it "has a default value of 100" {
                $Command | Should -HaveParameter $ParameterName -DefaultValue 100
            }
            it "has a valid range from 1 to 2000" -skip {
                $Command | Should -HaveParameter $ParameterName -DefaultValue 100 #-MinimumValue 1 -MaximumValue 2000
            }
        }

    }

    Context "Usage" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='0123456789';endpoint='https://xx.yy.cc'}

            $Object = 'APBILL'
        }

        BeforeEach {
            # arrange
            Mock Send-Request {
                $Fixture = 'Find-Object.Response.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # # Write-Debug $Content
                # [xml]$Content    

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response

                # $Content = "<?xml version='1.0' encoding='UTF-8'?>
                # <response>
                #     <operation>
                #         <result>
                #             <status>success</status>
                #             <function>readByQuery</function>
                #             <data listtype='$($Object.ToLower())' count='$DefaultPageSize'>
                #                 <$($Object.ToLower())/>
                #             </data>
                #         </result>
                #     </operation>
                # </response>"
                # Write-Debug $Content
                # [xml]$Content
            }    
        }

        Context "when the 'Object' parameter is supplied and the remaining parameters are not" {

            BeforeEach {
                # act
                $Actual = Find-Object -Session $Session -Object 'APBILL'
            }

            it "adds the 'readByQuery' element" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.ChildNodes[0].Name -eq 'readByQuery'
                }
            }

            it "adds the 'object' element" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.object -eq $Object
                }
            }

            it "adds the 'fields' element and sets its text to '*'" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.fields -eq '*'
                }
            }

            it "adds the 'query' element and sets its text to null" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.query -eq ''
                }
            }

            it "adds the 'pagesize' element and sets its text to 100" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.pagesize -eq 100
                }
            }

        } # /Context - Object

        Context "when the 'Fields' parameter is supplied" {

            Context "as an array of strings" {

                it "adds the 'fields' element and sets its text as a comma-delimited string" {    
                    # arrange
                    $Fields = 'A','B'
    
                    # act
                    Find-Object -Session $Session -Object $Object -Fields $Fields

                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $xml = [xml]$Function
                        $xml.function.readByQuery.fields -eq ($Fields -join ',')
                    }
                }
                    
            }

            Context "as an empty array" {

                it "adds the 'fields' element and sets its text to '*'" {    
                    # arrange
                    $Fields = @()
    
                    # act
                    Find-Object -Session $Session -Object $Object -Fields $Fields

                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $xml = [xml]$Function
                        $xml.function.readByQuery.fields -eq '*'
                    }
                }
                    
            }

            Context "as a string" {
                it "adds the 'fields' element and sets its text as a comma-delimited string" {
                    # arrange
                    $Fields = 'A,B'
    
                    # act
                    Find-Object -Session $Session -Object $Object -Fields $Fields
    
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $xml = [xml]$Function
                        $xml.function.readByQuery.fields -eq $Fields
                    }
                }    
            }

            Context "as an empty string" {
                it "adds the 'fields' element and sets its text to '*'" {
                    # arrange
                    $Fields = ''
    
                    # act
                    Find-Object -Session $Session -Object $Object -Fields $Fields
    
                    # assert
                    Should -Invoke Send-Request -ParameterFilter {
                        $xml = [xml]$Function
                        $xml.function.readByQuery.fields -eq '*'
                    }
                }    
            }

        } # /Context - Fields
    
        Context "when the 'Query' parameter is supplied" {

            BeforeEach {
                # arrange
                $Query = "RECORDID='00000'"

                # act
                Find-Object -Session $Session -Object $Object -Query $Query
            }

            it "adds the 'query' element and sets its value to '$Query'" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.query -eq $Query
                }
            }
        }

        Context "when the 'PageSize' parameter is supplied" {

            BeforeEach {
                # arrange
                $PageSize = 50

                # act
                Find-Object -Session $Session -Object $Object -PageSize $PageSize
            }

            it "adds the 'pagesize' element to its value to $PageSize" {
                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $xml = [xml]$Function
                    $xml.function.readByQuery.pagesize -eq $PageSize
                }
            }

        }

    } # /Context - Usage

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
