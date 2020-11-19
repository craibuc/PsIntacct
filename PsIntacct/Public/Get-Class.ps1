<#
.SYNOPSIS
Retrieve Class metadata

.PARAMETER Session
The Session object created by New-Session

.PARAMETER Name
Get information for the Class with the specified name.

.PARAMETER Details
Include all details for the specified Class.

.EXAMPLE
PS> Get-Class

Get all Classes

.EXAMPLE
PS> Get-Class -Name 'EMPLOYEE'

Get summary information for EMPLOYEE

.EXAMPLE
PS> Get-Class -Name 'EMPLOYEE' -Details

Get detailed information for EMPLOYEE

#>
function Get-Class {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter()]
        [string]$Name='*',

        [Parameter()]
        [switch]$Details
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"

    $Inspect = switch ($Name) 
    {
        '*' { "<inspect><object>$Name</object></inspect>" }
        Default { "<inspect detail='$( [int]$Details.IsPresent )'><object>$Name</object></inspect>" }
    }
    # Write-Debug "Inspect: $Inspect"

    $Function = "<function controlid='$( New-Guid )'>$Inspect</function>"
    Write-Debug "Function: $Function"

    $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function

    # Write-Debug "status: $($Content.response.operation.result.status)"
    switch ($Content.response.operation.result.status)
    {
        'success'
        {
            $Content.response.operation.result.data.type
        }
        'failure'
        {
            # create ErrorRecord
            $Exception = New-Object ApplicationException $Content.response.operation.result.errormessage.error.description2
            $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $($Content.response.operation.result.errormessage.error.errorno)"
            $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
            $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content

            # write ErrorRecord
            Write-Error -ErrorRecord $ErrorRecord -RecommendedAction $Content.response.operation.result.errormessage.error.correction    
        }
    }

}
