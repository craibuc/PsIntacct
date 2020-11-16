<#
.SYNOPSIS
Retrieve all attachment folders or a specific folder by name.

.DESCRIPTION
Retrieve all attachment folders or a specific folder by name.

.PARAMETER  name
Name of the attachment folder.

.PARAMETER maxitems
Max items to return

.PARAMETER showprivate
Show entity private records if running this at top level. Use either true or false. (Default: false)

.PARAMETER filter
Filter(s) to use in list

.PARAMETER sorts
Field(s) to sort by in response

.PARAMETER fields
Field(s) to return in response

.EXAMPLE 
Get-IntacctAttachmentFolder -Session $Sessison

Get all attachment folders.

.EXAMPLE 
Get-IntacctAttachmentFolder -Session $Sessison -name 'MyFolder'

Get the 'MyFolder' attachment folder.
#>
function Get-IntacctAttachmentFolder {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='All', Mandatory)]
		[Parameter(ParameterSetName='ByName', Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ParameterSetName='ByName',Mandatory)]
        [string]$name

        # [Parameter(ParameterSetName='All')]
        # [int]$start

        # [Parameter(ParameterSetName='All')]
        # [int]$maxitems,

        # [Parameter(ParameterSetName='All')]
        # [bool]$showprivate,

        # [Parameter(ParameterSetName='All')]
        # [object]$filter,

        # [Parameter(ParameterSetName='All')]
        # [object[]]$sorts,

        # [Parameter(ParameterSetName='All')]
        # [Parameter(ParameterSetName='ByName')]
        # [object[]]$fields
    )
        
    Write-Debug "$($MyInvocation.MyCommand.Name)"

    $Guid = New-Guid
    $Function = if ( $name -ne '' )
    {
        "<function controlid='$Guid'><get object=""supdocfolder"" key=""$name""></get></function>"
    }
    else
    {
        "<function controlid='$Guid'><get_list object=""supdocfolder""></get_list></function>"
    }
    Write-Debug "Function: $Function"

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
                    $Content.response.operation.result.data.supdocfolder
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

}