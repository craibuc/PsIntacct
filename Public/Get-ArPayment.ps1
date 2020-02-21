function Get-ArPayment {

    [CmdletBinding()]
    param
    (
		[Parameter(ParameterSetName='ByID', Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ParameterSetName='ByID', Mandatory)]
        [int]$Id
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"

    $Guid = New-Guid

    $Function = `
@"
<function controlid='$Guid'>
    <read>
        <object>ARPYMT</object>
        <keys>$Id</keys>
        <fields>*</fields>
    </read>
</function>
"@

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
                    Write-Error "A/R Payment $Id not found"
                }

            }
            'failure'
            { 
                Write-Debug "Module: $($MyInvocation.MyCommand.Module.Name)"
                Write-Debug "Command: $($MyInvocation.MyCommand.Name)"
                Write-Debug "description2: $($Content.response.operation.result.errormessage.error.description2)"
                Write-Debug "correction: $($Content.response.operation.result.errormessage.error.correction)"

                # create ErrorRecord
                $Exception = New-Object ApplicationException $Content.response.operation.result.errormessage.error.description2
                $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $($Content.response.operation.result.errormessage.error.errorno)"
                $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
                $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content

                # write ErrorRecord
                Write-Error -ErrorRecord $ErrorRecord -RecommendedAction $Content.response.operation.result.errormessage.error.correction
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
