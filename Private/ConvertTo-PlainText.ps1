<#
.SYNOPSIS
Convert an encrypted string ([System.Security.SecureString]) to its plain-text equivalent ([System.String])

.DESCRIPTION
Convert an encrypted string ([System.Security.SecureString]) to its plain-text equivalent ([System.String])

.PARAMETER SecureString
The encrypted value to be converted.

.EXAMPLE
PS > $password = ConvertTo-SecureString 'pa55w0rd' -AsPlainText -Force
PS > ConvertTo-PlainText $password
'pa55word'

.INPUTS
[System.Security.SecureString]

.OUTPUTS
[System.String]

.NOTES

#>
function ConvertTo-PlainText {

    [CmdletBinding()]
	param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('Password')]
		[SecureString]$SecureString
	)

    Begin{}
    Process
    {
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)    
    }
    End {}
    
}
