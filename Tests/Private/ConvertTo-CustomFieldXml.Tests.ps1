# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Private
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# ConvertTo-CustomFieldXml.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Private/ConvertTo-CustomFieldXml.ps1
. (Join-Path $PrivatePath $sut)

Describe "ConvertTo-CustomFieldXml" -Tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command "ConvertTo-CustomFieldXml"

        Context "customfieldname" {
            $ParameterName='customfieldname'

            it "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
            It "allows ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }
        Context "customfieldvalue" {
            $ParameterName='customfieldvalue'

            it "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            it "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "allows ValueFromPipelineByPropertyName" {
                $Command.Parameters[$ParameterName].Attributes.ValueFromPipelineByPropertyName | Should -Be $true
            }
        }

    }

    Context "All fields provided" {
    
        it "returns the expected values" {
            # arrange
            $CustomField = [pscustomobject]@{customfieldname='ABC';customfieldvalue=123},[pscustomobject]@{customfieldname='DEF';customfieldvalue='678'}

            # act
            [xml]$Actual = $CustomField | ConvertTo-CustomFieldXml
            
            # assert
            $Actual.customfields.customfield.customfieldname | Should -Be $CustomField.customfieldname
            $Actual.customfields.customfield.customfieldvalue | Should -Be $CustomField.customfieldvalue
        }
    }

    Context "Only customfieldname provided" {
    
        it "returns the expected values" {
            # arrange
            $CustomField = [pscustomobject]@{customfieldname='ABC';customfieldvalue=$null}

            # act
            [xml]$Actual = $CustomField | ConvertTo-CustomFieldXml
            
            # assert
            $Actual.customfields.customfield.customfieldname | Should -Be $CustomField.customfieldname
            $Actual.customfields.customfield.customfieldvalue | Should -BeNullOrEmpty
        }
    }

}
