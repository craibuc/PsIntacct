<#
.SYNOPSIS
Convert CustomField model to Xml.

.PARAMETER customfieldname
Custom field ID

.PARAMETER customfieldvalue
Custom field value. For a multi-pick-list custom field, implode multiple field values with #~#.

.EXAMPLE
PS> [PsCustomObject]@{customfieldname='HourlyRate';customfieldvalue=125.00},[PsCustomObject]@{customfieldname='Title';customfieldvalue='Chief Information Officer'} | ConvertTo-CustomFieldXml
<customfields>
    <customfield>
        <customfieldname>HourlyRate</customfieldname>
        <customfieldvalue>125</customfieldvalue></customfield>
    <customfield>
        <customfieldname>Title</customfieldname>
        <customfieldvalue>Chief Information Officer</customfieldvalue>
    </customfield>
</customfields>

.LINK
https://developer.intacct.com/api/accounts-receivable/invoices/#create-invoice-legacy

#>
function ConvertTo-CustomFieldXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$customfieldname,
        
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$customfieldvalue
    )

    begin {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.AppendLine('<customfields>')
    }
    process {
        [void]$SB.AppendLine('<customfield>')
        [void]$SB.Append("<customfieldname>$customfieldname</customfieldname>")
        [void]$SB.Append("<customfieldvalue>$( [System.Security.SecurityElement]::Escape($customfieldvalue) )</customfieldvalue>")
        [void]$SB.AppendLine('</customfield>')
    }
    end {
        [void]$SB.AppendLine('</customfields>')
        $SB.ToString()
    }

}
