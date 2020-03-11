<#
.PARAMETER ADDRESS1
Address line 1

.PARAMETER ADDRESS2
Address line 2

.PARAMETER CITY
City

.PARAMETER STATE
State/province

.PARAMETER ZIP
Zip/postal code

.PARAMETER COUNTRY
Country

#>
function ConvertTo-MailingAddressXml {

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ADDRESS1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ADDRESS2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CITY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$STATE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$ZIP,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$COUNTRY='US'
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$COUNTRYCODE='US'

    )

    Begin
    {
        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.AppendLine("<MAILADDRESS>")
    }
    Process
    {
        if ($ADDRESS1) { [void]$SB.Append("<ADDRESS1>$ADDRESS1</ADDRESS1>") }
        if ($ADDRESS2) { [void]$SB.Append("<ADDRESS2>$ADDRESS2</ADDRESS2>") }
        if ($CITY) { [void]$SB.Append("<CITY>$CITY</CITY>") }
        if ($STATE) { [void]$SB.Append("<STATE>$STATE</STATE>") }
        if ($ZIP) { [void]$SB.Append("<ZIP>$ZIP</ZIP>") }
        # if ($COUNTRY) { [void]$SB.Append("<COUNTRY>$COUNTRY</COUNTRY>") }
        if ($COUNTRYCODE) { [void]$SB.Append("<COUNTRYCODE>$COUNTRYCODE</COUNTRYCODE>") }    
    }
    End
    {
        [void]$SB.AppendLine("</MAILADDRESS>")
        $SB.ToString()
    }

}
