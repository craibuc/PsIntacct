function Get-Customer {

    [CmdletBinding()]
    param
    (
        # [Parameter(ParameterSetName='ByID', Mandatory)]
		[Parameter(ParameterSetName='ByNumber', Mandatory)]
        [pscustomobject]$Session,

        # [Parameter(ParameterSetName='ByID', Mandatory)]
        # [int]$Id,

        [Parameter(ParameterSetName='ByNumber', Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('CUSTOMERID')]
        [string]$Number,

        [Parameter(ParameterSetName='ByNumber')]
        [string]$Fields='*'

    )

    begin
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"
    }
    process
    {
        $Function = 
        "<function controlid='$(New-Guid)'>
            <readByName>
                <object>CUSTOMER</object>
                <keys>$Number</keys>
                <fields>$Fields</fields>
            </readByName>
        </function>"

        try 
        {
            $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
            
            # Write-Debug "status: $($Content.response.operation.result.status)"
            switch ($Content.response.operation.result.status)
            {
                'success'
                {
                    $Content.response.operation.result.data.CUSTOMER
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
            }
        }
        catch
        {
            $_
        }
        
    } # /process
    end {}

}
