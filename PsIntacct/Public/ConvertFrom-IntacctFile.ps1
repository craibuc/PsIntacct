<#
.SYNOPSIS

.PARAMETER attachments
The attachments node.

.LINK
https://developer.intacct.com/api/company-console/attachments/#create-attachment-legacy
#>
function ConvertFrom-IntacctFile {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [object]$attachments
    )
    
    begin {}
    
    process 
    {
        $attachments.attachment | ForEach-Object {
            [pscustomobject]@{
                Path = "{0}.{1}" -f $_.attachmentname, $_.attachmenttype
                Value = [System.Convert]::FromBase64String($_.attachmentdata)
            }
        }
    }
    
    end {}

}