<#
.SYNOPSIS
Convert a (file system) file to an Intacct representation of a file.

.PARAMETER Path
An absolute or relative path to a file.

.EXAMPLE
ConvertTo-IntacctFile -Path '~/Desktop/LoremIpsum.pdf'

attachments
-----------
attachments

Convert the specified file.

.EXAMPLE
Get-ChildItem *.pdf | ConvertTo-IntacctFile | Select-Object -ExpandProperty attachments | Select-Object -ExpandProperty attachment

attachmentname   attachmenttype attachmentdata
--------------   -------------- --------------
LoremIpsum       pdf            JVBER
IpsumLorem       pdf            JVBER

Convert and 'package' all PDF files in the current directory, then display the details of the conversion.

.INPUTS
[string[]] or [System.IO.FileInfo]

.OUTPUTS
[System.Xml]

.LINK
https://developer.intacct.com/api/company-console/attachments/#create-attachment-legacy
#>
function ConvertTo-IntacctFile {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string[]]$Path
    )

    begin 
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<attachments>")
    }
    
    process 
    {

        try 
        {
            [void]$SB.Append("<attachment>")

            foreach($P in $Path)
            {    
                Write-Host "Processing $P..."

                # metadata
                $Item = Get-Item -Path $P

                [void]$SB.Append("<attachmentname>$( $Item.BaseName )</attachmentname>")
                [void]$SB.Append("<attachmenttype>$( $Item.Extension.Substring(1, ($Item.Extension.Length -1)) )</attachmenttype>")

                # data
                $Content = [System.IO.File]::ReadAllBytes($Path)
                $Encoded = [Convert]::ToBase64String($Content)
                [void]$SB.Append("<attachmentdata>$Encoded</attachmentdata>")
            }

            [void]$SB.Append("</attachment>")
        }
        catch 
        {
            Write-Error $_.Exception.Message
        }

    }
    
    end 
    {
        [void]$SB.Append("</attachments>")
        [xml]$SB.ToString()
    }

}