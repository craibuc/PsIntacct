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

.PARAMETER COUNTRYCODE
Country code.

.INPUTS
Pipeline by property name

.OUTPUTS
System.String

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

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$COUNTRYCODE='US'
    )

    Begin
    {
        $SB = [Text.StringBuilder]::new()
        [void]$SB.Append("<MAILADDRESS>")
    }
    Process
    {
        if ($ADDRESS1) { [void]$SB.Append("<ADDRESS1>$( [System.Security.SecurityElement]::Escape($ADDRESS1) )</ADDRESS1>") }
        if ($ADDRESS2) { [void]$SB.Append("<ADDRESS2>$( [System.Security.SecurityElement]::Escape($ADDRESS2) )</ADDRESS2>") }
        if ($CITY) { [void]$SB.Append("<CITY>$( [System.Security.SecurityElement]::Escape($CITY) )</CITY>") }
        if ($STATE) { [void]$SB.Append("<STATE>$STATE</STATE>") }
        if ($ZIP) { [void]$SB.Append("<ZIP>$ZIP</ZIP>") }
        if ($COUNTRYCODE) { [void]$SB.Append("<COUNTRYCODE>$COUNTRYCODE</COUNTRYCODE>") }    
    }
    End
    {
        [void]$SB.Append("</MAILADDRESS>")        
        $xml = $SB.ToString()
        # Write-Debug $Xml
        [xml]$Xml
    }

}
