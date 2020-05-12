function ConvertTo-DateXml {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [datetime]$InputObject,

        [Parameter(Mandatory)]
        [string]$Element
    )

    begin 
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
    }
    process 
    {
        [void]$SB.Append(
            "<$($Element)>
                <year>$( $InputObject.ToString('yyyy') )</year>
                <month>$( $InputObject.ToString('MM') )</month>
                <day>$( $InputObject.ToString('dd') )</day>
            </$($Element)>")
    }
    end 
    {
        [xml]$SB.ToString()
    }

}
