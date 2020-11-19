<#
.SYNOPSIS
Removes the specified Intacct attachment folder.

.DESCRIPTION
Removes the specified Intacct attachment folder.

.PARAMETER name
The attachment folder's name.

.EXAMPLE
Remove-IntacctAttachmentFolder -Session $Session -name 'MyFolder'

.LINK
https://developer.intacct.com/api/company-console/attachments/#delete-attachment-folder-legacy

#>
function Remove-IntacctAttachmentFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory)]
        [string]$name
    )
    
    begin
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"        
    }
    
    process{

        $Function = "<function controlid='$( New-Guid )'><delete_supdocfolder key=""$name""/></function>"
        Write-Debug "Function: $Function"

        if ( $PSCmdlet.ShouldProcess("DELETE: $name","Send-Request") )
        {

            try
            {
                $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
        
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
            catch [Microsoft.PowerShell.Commands.HttpResponseException]
            {
                # HTTP exceptions
                Write-Error "$($_.Exception.Response.ReasonPhrase) [$($_.Exception.Response.StatusCode.value__)]"
            }
            catch
            {
                # all other exceptions
                Write-Error $_.Exception.Message
            }

        } # /ShouldProcess

    } # /Process
    
    end {}

}