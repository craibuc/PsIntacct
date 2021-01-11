function Set-IntacctSdkConfiguration {

    [CmdletBinding()]
    param (
        [pscredential]$SenderCredential,
        [pscredential]$UserCredential,
        [string]$CompanyId
    )
    
    [Intacct.SDK.ClientConfig] $Script:ClientConfig = [Intacct.SDK.ClientConfig]::new()

    $Script:ClientConfig.SenderId = $SenderCredential.UserName
    $Script:ClientConfig.SenderPassword = $SenderCredential.Password | ConvertFrom-SecureString -AsPlainText
    $Script:ClientConfig.UserId = $UserCredential.UserName
    $Script:ClientConfig.UserPassword = $UserCredential.Password | ConvertFrom-SecureString -AsPlainText
    $Script:ClientConfig.CompanyId = $CompanyId

}