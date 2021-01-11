BeforeAll {

    # /PsIntacct
    # $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsIntacct/PsIntacct/Private
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
    # $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

    # /PsIntacct/Tests/Fixtures/
    # $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # New-IntacctSdkObject.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # dependencies
    . (Join-Path $PublicPath "Get-IntacctSdkType.ps1")

    # . /PsIntacct/PsIntacct/Public/New-IntacctSdkObject.ps1
    . (Join-Path $PublicPath $SUT)

}

Describe "New-IntacctSdkObject" -tag 'Unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'New-IntacctSdkObject'
        }

        Context "Name" {
            BeforeAll { $ParameterName='Name' }

            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type [string]
            }
    
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

    }

    Context "Name" {

        Context "when a valid type is supplied" {

            It "returns the expected Type" {

                # arrange
                $Name = 'CustomerCreate'
                
                # act
                $Actual = New-IntacctSdkObject -Name $Name
    
                # assert
                $Actual.GetType().FullName | Should -Be 'Intacct.SDK.Functions.AccountsReceivable.CustomerCreate'
            }
    
        }

        Context "when an invalid type is supplied" {

            It "throws an exception" {

                # arrange
                $Name = 'FooBar'
                
                # act/assert
                { New-IntacctSdkObject -Name $Name } | Should -Throw "Type not found: $Name"

            }
    
        }

    }

}