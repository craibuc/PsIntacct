<#
.SYNOPSIS
Retrieve Object metadata

.PARAMETER Session
The Session object created by New-Session

.PARAMETER Object
Get information for the specified Object

.PARAMETER Details
Include all details for the specified Object

.EXAMPLE
PS> Get-Object

Get all Objects

.EXAMPLE
PS> Get-Object -Object 'EMPLOYEE'

Get summary information for EMPLOYEE

.EXAMPLE
PS> Get-Object -Object 'EMPLOYEE' -Details

Get detailed information for EMPLOYEE

#>
function Get-Object {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter()]
        [string]$Object='*',

        [Parameter()]
        [switch]$Details
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"

    $Inspect = switch ($Object) 
    {
        '*' { "<inspect><object>$Object</object></inspect>" }
        Default { "<inspect detail='$( [int]$Details.IsPresent )'><object>$Object</object></inspect>" }
    }
    # Write-Debug "Inspect: $Inspect"

    $Function = "<function controlid='$( New-Guid )'>$Inspect</function>"
    # Write-Debug "Function: $Function"

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
