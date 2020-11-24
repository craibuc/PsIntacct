<#
.SYNOPSIS
Delete an object from Intacct.  High potential for a career-ending actions!

.PARAMETER Session
The object created by the New-IntacctSession cmdlet.

.PARAMETER Object
The type of object to be deleted (e.g. CUSTOMER, CONTACT)

.PARAMETER Id
The Id (RECORDNO) of the object to be deleted.

.EXAMPLE
Remove-IntacctObject -Object 'CUSTOMER' -Id 1234 -WhatIf

Preview the effects of deleting CUSTOMER 1234.

.EXAMPLE
Remove-IntacctObject -Object 'CUSTOMER' -Id 1234

Confirm
Are you sure you want to perform this action?
Performing the operation "Delete" on target "CUSTOMER: 1234".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): Y

Delete CUSTOMER 1234 after being prompted for confirmation.

.EXAMPLE
Remove-IntacctObject -Object 'CUSTOMER' -Id 1234 -Confirm:$false

Delete CUSTOMER 1234 without confirmation prompting.  DANGEROUS!

.EXAMPLE
Find-Object -Object 'CUSTOMER' | Remove-IntacctObject -Confirm:$false

Delete all CUSTOMER objects without confirmation prompting.  SUPER, SUPER, SUPER DANGEROUS!

#>
function Remove-IntacctObject {

    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$Object,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Alias('RECORDNO')]
        [int]$Id
    )

    begin { 
        # Write-Debug "$($MyInvocation.MyCommand.Name)::BEGIN" 
    }

    process
    {
        # Write-Debug "$($MyInvocation.MyCommand.Name)::PROCESS"

        $Function =
            "<function controlid='$( New-Guid )'>
                <delete>
                    <object>$Object</object>
                    <keys>$Id</keys>
                </delete>
            </function>"

        if ($pscmdlet.ShouldProcess("$Object`: $Id", "Delete"))
        {
            Write-Verbose "Deleting $Object $Id..."

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
                    # return the first error
                    $Err = $Content.response.operation.result.errormessage.FirstChild
    
                    # create specific exception if possible
                    switch ($Err.errorno) {
                        'BL01001973' # Cannot find customer with key 'XXX' to delete.
                        {
                            $ErrorCategory = [System.Management.Automation.ErrorCategory]::ObjectNotFound
                        }
                        Default {
                            $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
                        }
                    }
    
                    $ErrorNumber = $Err.errorno
                    $ErrorMessage = $Err.description2 ?? $Err.errorno
                    $Exception = New-Object ApplicationException $ErrorMessage
                    $ErrorId = "{0}\{1} - {2} [{3}]" -f $MyInvocation.MyCommand.Module.Name, $MyInvocation.MyCommand.Name, $ErrorMessage, $ErrorNumber
                    # $Correction = $Err.correction
    
                    # create ErrorRecord
                    $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content
    
                    # Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category NotSpecified -RecommendedAction $Correction -TargetObject $Content.response.operation.result
                    $PSCmdlet.WriteError($ErrorRecord)
                }
            } # /switch
    
        } # /ShouldProcess

    }

    end { 
        # Write-Debug "$($MyInvocation.MyCommand.Name)::END" 
    }

}
