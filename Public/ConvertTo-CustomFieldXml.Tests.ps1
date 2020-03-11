$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ConvertTo-CustomFieldXml" {

    $CustomField = [pscustomobject]@{customfieldname='ABC';customfieldvalue=123},[pscustomobject]@{customfieldname='DEF';customfieldvalue='678'}

    Context "Required fields" {

        it "has 2, mandatory parameters" {
            Get-Command "ConvertTo-CustomFieldXml" | Should -HaveParameter customfieldname -Mandatory
            Get-Command "ConvertTo-CustomFieldXml" | Should -HaveParameter customfieldvalue -Mandatory
        }
    
        it "returns the expected values" {
            # act
            [xml]$Actual = $CustomField | ConvertTo-CustomFieldXml
            
            # assert
            $Actual.customfields.customfield.customfieldname | Should -Be $CustomField.customfieldname
            $Actual.customfields.customfield.customfieldvalue | Should -Be $CustomField.customfieldvalue
        }
    }

}
