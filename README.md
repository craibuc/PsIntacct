# PsIntacct
PowerShell module that wraps the Intacct API.

## Installation

### Git
```powershell
PS> cd ~/Documents/WindowsPowerShell/Modules

PS> git clone git@github.com:craibuc/PsIntacct.git
```

## Configuration

### Sender

```powershell
PS> $SenderCredential = Get-Credential
```

### User

```powershell
PS> $UserCredential = Get-Credential
PS> $CompanyId = 'my_company'
```

## Usage

### Create a session

```powershell
$Session = New-Session -SenderCredential $SenderCredential -UserCredential $UserCredential -CompanyId $CompanyId
```

## Contributors
- [Craig Buchanan](https://github.com/craibuc/)
