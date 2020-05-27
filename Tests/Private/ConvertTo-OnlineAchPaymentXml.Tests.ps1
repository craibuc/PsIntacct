# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-OnlineAchPaymentXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Private/ConvertTo-OnlineAchPaymentXml.ps1
. (Join-Path $PrivatePath $sut)

Describe "ConvertTo-OnlineAchPaymentXml" -tag 'Unit' {

    Context "Parameter validation" {
        $Command = Get-Command "ConvertTo-OnlineAchPaymentXml"

        Context "bankname" {
            $ParameterName = 'bankname'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "accounttype" {
            $ParameterName = 'accounttype'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "accountnumber" {
            $ParameterName = 'accountnumber'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "routingnumber" {
            $ParameterName = 'routingnumber'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "accountholder" {
            $ParameterName = 'accountholder'
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context "usedefaultcard" {
            $ParameterName = 'usedefaultcard'
            It "is a [bool]" {
                $Command | Should -HaveParameter $ParameterName -Type bool
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context "Legacy" {
            $ParameterName = 'Legacy'
            It "is a [switch]" {
                $Command | Should -HaveParameter $ParameterName -Type switch
            }
        }

    }

    Context "Usage" {
        # arrange
        $OnlineAchPayment = [pscustomobject]@{
            bankname = 'Acme Banking'
            accounttype = 'checking'
            accountnumber = '9876543210'
            routingnumber = '0123456789'
            accountholder = 'Wile E Coyote'
            usedefaultcard = $true
        }
    
        it "returns the expected values" {
            # act
            $Actual = $OnlineAchPayment | ConvertTo-OnlineAchPaymentXml
    
            # assert
            $Actual.onlineAchpayment.bankname | Should -Be $OnlineAchPayment.bankname
            $Actual.onlineAchpayment.accounttype | Should -Be $OnlineAchPayment.accounttype
            $Actual.onlineAchpayment.accountnumber | Should -Be $OnlineAchPayment.accountnumber
            $Actual.onlineAchpayment.routingnumber | Should -Be $OnlineAchPayment.routingnumber
            $Actual.onlineAchpayment.accountholder | Should -Be $OnlineAchPayment.accountholder
            $Actual.onlineAchpayment.usedefaultcard | Should -Be $OnlineAchPayment.usedefaultcard.ToString().ToLower()
        }
    }

}
