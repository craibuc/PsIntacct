function Format-Xml {

    [CmdletBinding()]
    param (
        [xml]$XmlDocument
    )

    $sw = New-Object -Type System.IO.StringWriter
    $xw = New-Object -Type System.Xml.XmlTextWriter::new($sw)
    $xw.Formatting = [System.Xml.Formatting]::Indented

    $XmlDocument.WriteTo($xw)
    
    $sw.ToString()
}
