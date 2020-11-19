<#
.SYNOPSIS
Removes the attachment header and all associated attachment lines.

.DESCRIPTION
Removes the attachment header and all associated attachment lines.

.PARAMETER id
The attachment's ID.

.EXAMPLE
Remove-IntacctAttachment -Session $Session -id 'ATT-0000'

.LINK
https://developer.intacct.com/api/company-console/attachments/#delete-attachment-legacy

#>
function Remove-IntacctAttachment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory)]
        [string]$id
    )
    
    begin
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"        
    }
    
    process{

        $Guid = New-Guid
    
        $Function = 
        "<function controlid='$Guid'>
            <delete_supdoc key=""$id""></delete_supdoc>
        </function>"

        Write-Debug "Function: $Function"

        if ( $PSCmdlet.ShouldProcess("DELETE: $id","Send-Request") )
        {

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
                            $Content.response.operation.result.data.supdoc
                        }
                        else
                        {
                            Write-Warning "$( $name -ne '' ? "Folder '$name'" : 'Folders' ) not found"
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
                Write-Error $_.Exception.Message
            }

        } # /ShouldProcess

    } # /Process
    
    end {}

}