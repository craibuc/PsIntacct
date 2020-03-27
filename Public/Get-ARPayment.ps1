<#
.SYNOPSIS

.PARAMETER Session

.PARAMETER Id
The ARPMT's primary key (RECORDNO); pretty useless

.PARAMETER Query
The ARPMT's primary key (RECORDNO); pretty useless

#>
function Get-ArPayment {

    [CmdletBinding()]
    param
    (
        [Parameter(ParameterSetName='ByID', Mandatory)]
        [Parameter(ParameterSetName='ByQuery', Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ParameterSetName='ByID', Mandatory)]
        [int]$Id,

        [Parameter(ParameterSetName='ByQuery', Mandatory)]
        [string]$Query
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"

    $Guid = New-Guid

    $Function = 
        if ( $Id )
        {
            "<function controlid='$Guid'>
                <read>
                    <object>ARPYMT</object>
                    <keys>$Id</keys>
                    <fields>*</fields>
                </read>
        </function>"
        }
        elseif ( $Query )
        {
            "<function controlid='$Guid'>
                <readByQuery>
                    <object>ARPYMT</object>
                    <query>$Query</query>
                    <fields>*</fields>
                    <pagesize>100</pagesize>
                </readByQuery>
        </function>"
        }
    Write-Debug $Function

    try
    {
        $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function

        Write-Debug "status: $($Content.response.operation.result.status)"

        switch ( $Content.response.operation.result.status )
        {
            'success'
            {  
                Write-Debug "count: $($Content.response.operation.result.data.count)"

                if ( $Content.response.operation.result.data.count -gt 0 )
                {
                    $Content.response.operation.result.data.ARPYMT
                }
                else
                {
                    if ( $Id ) { Write-Error "A/R Payment $Id not found"}
                    else { Write-Error "A/R Payment not found" }
                }

            }
            'failure'
            { 
                # return the first error
                $Err = $Content.response.operation.result.errormessage.FirstChild
                $ErrorId = "{0}::{1} - {2}" -f $MyInvocation.MyCommand.Module.Name, $MyInvocation.MyCommand.Name, $Err.errorno
                $ErrorMessage = $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category NotSpecified -RecommendedAction $Correction -TargetObject $Content.response.operation.result

                # create ErrorRecord
                # $Exception = New-Object ApplicationException $Content.response.operation.result.errormessage.error.description2
                # $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $($Content.response.operation.result.errormessage.error.errorno)"
                # $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
                # $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content

                # write ErrorRecord
                # Write-Error -ErrorRecord $ErrorRecord -RecommendedAction $Content.response.operation.result.errormessage.error.correction
            }    
        } # /switch

    }
    catch [Microsoft.PowerShell.Commands.HttpResponseException]
    {
    # HTTP exceptions
    Write-Error "$($_.Exception.Response.ReasonPhrase) [$($_.Exception.Response.StatusCode.value__)]"
    }
    catch
    {
    # all other exceptions
    Write-Error $_ #.Exception.Message
    }

}
