<#
.SYNOPSIS

.PARAMETER Session

.PARAMETER InvoiceXml

#>
function New-Invoice {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$InvoiceXml
    )
        
    begin 
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"
    }
    
    process 
    {

        [xml]$Function = 
            "<function controlid='$( New-Guid )'>
                $( $InvoiceXml.OuterXml )
            </function>"

        Write-Debug $Function.OuterXml

        try
        {
            # if ($pscmdlet.ShouldProcess("$TempTableName", "Delete *")) {}
            $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function.OuterXml

            Write-Debug "status: $($Content.response.operation.result.status)"
            switch ( $Content.response.operation.result.status )
            {
                'success'
                {  
                    $Content.response.operation.result
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
        catch
        {
            $_
        }

    }
    
    end {}

}
