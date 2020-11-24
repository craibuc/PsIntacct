<#
.SYNOPSIS
Create an Intacct attachment folder.

.PARAMETER Session
A valid Intacct session; use New-IntacctSession to create a valid session.

.PARAMETER supdocfoldername
Attachment folder's name.

.PARAMETER supdocfolderdescription
Attachment folder's description,

.PARAMETER supdocparentfoldername
Attachment folder's parent.

.LINK
New-IntacctSession

.LINK
https://developer.intacct.com/api/company-console/attachments/#create-attachment-folder-legacy
#>

function New-IntacctAttachmentFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [Alias('name')]
        [string]$supdocfoldername,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('description')]
        [string]$supdocfolderdescription,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('parentfolder')]
        [string]$supdocparentfoldername
    )
    
    begin {}
    
    process {
    
        $SB = [System.Text.StringBuilder]::new()
        [void]$SB.Append("<function controlid='$( New-Guid )'>")
        [void]$SB.Append("<create_supdocfolder>")
        if ($supdocfoldername) { [void]$SB.Append("<supdocfoldername>$supdocfoldername</supdocfoldername>") }
        if ($supdocfolderdescription) { [void]$SB.Append("<supdocfolderdescription>$supdocfolderdescription</supdocfolderdescription>") }
        if ($supdocparentfoldername) { [void]$SB.Append("<supdocparentfoldername>$supdocparentfoldername</supdocparentfoldername>") }
        [void]$SB.Append("</create_supdocfolder>")
        [void]$SB.Append("</function>")

        $Function = $SB.ToString()
        Write-Debug $Function

        if ( $PSCmdlet.ShouldProcess($supdocfoldername, 'New-IntacctAttachmentFolder') )
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
                    # return the first error
                    $Err = $Content.response.operation.result.errormessage.FirstChild
                    $ErrorId = "{0}::{1} - {2}" -f $MyInvocation.MyCommand.Module.Name, $MyInvocation.MyCommand.Name, $Err.errorno
                    $ErrorMessage = "{0} [{1}]: {2}" -f $ARPaymentXml.ARPYMT.DOCNUMBER, $ARPaymentXml.ARPYMT.CUSTOMERID, $Err.description2 ?? $Err.errorno
                    $Correction = $Err.correction
    
                    Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
                }
            } # /switch    
        }

    }
    
    end {}

}