<#
.PARAMETER Session
The Session object create by New-IntacctSession

.PARAMETER JOURNAL
Stat journal symbol

.PARAMETER BATCH_DATE
Posting date in format mm/dd/yyyy

.PARAMETER BATCH_TITLE
Description of entry

.PARAMETER ENTRIES
Must have at least one line. Stat journal entries do not need to balance like regular journal entries.

.PARAMETER REVERSE_DATE
Reverse date in format mm/dd/yyyy. Must be greater than BATCH_DATE.

.PARAMETER HISTORY_COMMENT
Comment added to history for this transaction

.PARAMETER REFERENCENO
Reference number of transaction

.PARAMETER SUPDOCID
Attachments ID

.PARAMETER STATE
State to create the entry in. Posted to post to the GL, otherwise Draft. (Default: Posted)

.PARAMETER CustomField
Custom fields. For a multi-pick-list custom field, implode multiple field va
#>
function New-StatisticalJournalEntry {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$JOURNAL,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [datetime]$BATCH_DATE,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$BATCH_TITLE,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$ENTRIES,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Posted','Draft')]
        [string]$STATE='Posted',

        [Parameter(ValueFromPipelineByPropertyName)]
        # [ValidateScript({
        #     if ($_.REVERSEDATE -gt $_.BATCH_DATE) {$true} else {throw "REVERSEDATE must be after BATCH_DATE"}
        #     # if ($REVERSEDATE -gt $BATCH_DATE) {$true} else {throw "REVERSEDATE must be after BATCH_DATE"}
        # })]
        [Alias('REVERSEDATE')]
        [datetime]$REVERSE_DATE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$HISTORY_COMMENT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$REFERENCENO,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$SUPDOCID
    )
    
    begin
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"
    }
    
    process
    {
        # validation
        if ( $REVERSE_DATE -and $REVERSE_DATE -lt $BATCH_DATE ) {throw "REVERSE_DATE must be after BATCH_DATE"}

        # mandatory
        if ($JOURNAL) { $Fields+= "<JOURNAL>$JOURNAL</JOURNAL>"}
        if ($BATCH_DATE) { $Fields+= "<BATCH_DATE>$($BATCH_DATE.ToString('MM/dd/yyyy'))</BATCH_DATE>"}
        if ($BATCH_TITLE) { $Fields+= "<BATCH_TITLE>$BATCH_TITLE</BATCH_TITLE>" }
        if ($ENTRIES) { $Fields+= $ENTRIES } else { $Fields+= "<ENTRIES/>" }

        # optional
        if ($REVERSE_DATE) { $Fields+= "<REVERSEDATE>$($REVERSE_DATE.ToString('MM/dd/yyyy'))</REVERSEDATE>"}
        if ($HISTORY_COMMENT) { $Fields+= "<HISTORY_COMMENT>$HISTORY_COMMENT</HISTORY_COMMENT>"}
        if ($REFERENCENO) { $Fields+= "<REFERENCENO>$REFERENCENO</REFERENCENO>"}
        if ($SUPDOCID) { $Fields+= "<SUPDOCID>$SUPDOCID</SUPDOCID>"}
        if ($STATE) { $Fields+= "<STATE>$STATE</STATE>"}

        $Function = 
"
<function controlid='$( New-Guid )'>
    <create>
        <GLBATCH>
        $( $Fields -Join '' )
        </GLBATCH>
    </create>
</function>
"
        Write-Debug $Function

        try
        {
            $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
            Write-Debug "status: $($Content.response.operation.result.status)"

            if ( $Content.response.operation.result.status -eq 'success' )
            {
                $Content.response.operation.result      
            }
        }
        catch
        {
            $_
        }

    }
    
    end {}

}
