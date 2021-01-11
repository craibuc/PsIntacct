<#
.SYNOPSIS
Get a reference to the assemblies in the current domain, defaulting to 'Intacct.SDK.dll'
#>
function Get-Assembly {

    [CmdletBinding()]
    param (
        [string]$Name = 'Intacct.SDK.dll'
    )

    try 
    {
        [AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.Location -like "*$Name" } | Select-Object -First 1
    }
    catch 
    {
        Write-Warning $_.Exception.Message
    }

}