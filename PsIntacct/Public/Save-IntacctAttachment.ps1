<#
.SYNOPSIS
Save an Intacct Attachment header and files.

.PARAMETER Session
A valid Intacct session; use New-IntacctSession to create a valid session.

.PARAMETER supdocid
Attachment ID to update

.PARAMETER supdocname
Name of attachment

.PARAMETER supdocfoldername
Attachments folder to create in

.PARAMETER supdocdescription
Description

.PARAMETER attachments
Zero or more attachments; use ConvertTo-IntacctFile to create correct object model/.

.LINK
New-IntacctSession

.LINK
ConvertTo-IntacctFile

.LINK
https://developer.intacct.com/api/company-console/attachments/#create-attachment-legacy

.LINK
https://developer.intacct.com/api/company-console/attachments/#update-attachment-legacy
#>

function Save-IntacctAttachment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ParameterSetName='Update', Mandatory)]
		[Parameter(ParameterSetName='Create', Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ParameterSetName='Update',ValueFromPipelineByPropertyName,Mandatory)]
        [string]$supdocid,

        [Parameter(ParameterSetName='Create',ValueFromPipelineByPropertyName,Mandatory)]
        [Parameter(ParameterSetName='Update',ValueFromPipelineByPropertyName)]
        [string]$supdocname,

        [Parameter(ParameterSetName='Create',ValueFromPipelineByPropertyName,Mandatory)]
        [Parameter(ParameterSetName='Update',ValueFromPipelineByPropertyName)]
        [Alias('folder')]
        [string]$supdocfoldername,

        [Parameter(ParameterSetName='Create',ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='Update',ValueFromPipelineByPropertyName)]
        [Alias('description')]
        [string]$supdocdescription,

        [Parameter(ParameterSetName='Create',ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName='Update',ValueFromPipelineByPropertyName)]
        [object]$attachments
    )
    
    begin {}
    
    process {
    
        $SB = [System.Text.StringBuilder]::new()
        [void]$SB.Append("<function controlid='$( New-Guid )'>")
        
        if ( $PSCmdlet.ParameterSetName -eq 'Create') { [void]$SB.Append("<create_supdoc>") } 
        else { [void]$SB.Append("<update_supdoc>") }

        [void]$SB.Append("<supdocid>$supdocid</supdocid>")
        if ($supdocname) { [void]$SB.Append("<supdocname>$supdocname</supdocname>") }
        if ($supdocfoldername) { [void]$SB.Append("<supdocfoldername>$supdocfoldername</supdocfoldername>") }
        if ($supdocdescription) { [void]$SB.Append("<supdocdescription>$supdocdescription</supdocdescription>") }
        if ($attachments) { [void]$SB.Append( $attachments.OuterXml ) }

        if ( $PSCmdlet.ParameterSetName -eq 'Create') { [void]$SB.Append("</create_supdoc>") } 
        else { [void]$SB.Append("</update_supdoc>") }

        [void]$SB.Append("</function>")

        $Function = $SB.ToString()
        Write-Debug $Function

        $Target = $PSCmdlet.ParameterSetName -eq 'Create' ? "$supdocfoldername/$supdocname" : $supdocid

        if ( $PSCmdlet.ShouldProcess($Target, 'Save-IntacctAttachment') )
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