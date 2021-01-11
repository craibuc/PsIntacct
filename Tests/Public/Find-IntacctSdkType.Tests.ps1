BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsIntacct/PsIntacct/Private
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"
    
    # Find-IntacctSdkType.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Find-IntacctSdkType.ps1
    . (Join-Path $PublicPath $SUT)

}

Describe "Find-IntacctSdkType" -tag 'Unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Find-Command 'Find-IntacctSdkType'
        }

        Context "TypeName" {
            BeforeAll { $ParameterName='TypeName' }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
    
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

    }

    Context "TypeName" {

        It "returns the expected Type" {

            # arrange
            $TypeName = 'CustomerCreate'
            
            # act
            $Actual = Find-IntacctSdkType -TypeName $TypeName

            # assert
            $Actual.FullName | Should -Be 'Intacct.SDK.Functions.AccountsReceivable.CustomerCreate'
        }

    }

}