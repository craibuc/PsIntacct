<#
.SYNOPSIS

.PARAMETER Expression

.EXAMPLE
Find-IntacctSdkType -Expression 'Customer*'
#>
function Find-IntacctSdkType {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Expression
    )
    
    $Assembly = [AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.Location -like '*Intacct.SDK.dll' } | Select-Object -First 1

    # $Where = $IFunction.IsPresent? { $_.Name -like "$Expression*" -and $_.ImplementedInterfaces.Contains([Intacct.SDK.Functions.IFunction]) } : { $_.Name -like "$Expression*" }

    $Assembly.GetTypes() | Where-Object { $_.Name -like $Expression }

}