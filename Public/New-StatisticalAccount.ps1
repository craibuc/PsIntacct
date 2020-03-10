<#
.SYNOPSIS
lorem ipsum

.PARAMETER ACCOUNTNO
Statistical Account number

.PARAMETER TITLE
Title

.PARAMETER CATEGORY
System Category

.PARAMETER ACCOUNTTYPE
Report type. Use forperiod for a For the period account otherwise use cumulative for a Cumulative balance account. (Default: forperiod)

.PARAMETER STATUS
Statistical Account status. Use active for Active otherwise use inactive for Inactive. (Default: active)

.PARAMETER REQUIREDEPT
Use true to make department required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIRELOC
Use true to make location required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIREPROJECT
Use true to make project required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIRECUSTOMER
Use true to make customer required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIREVENDOR
Use true to make vendor required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIREEMPLOYEE
Use true to make employee required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIREITEM
Use true to make item required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIRECLASS
Use true to make class required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIRETASK
Use true to make task required for this account, otherwise use false. (Default: false)

.PARAMETER REQUIREGLDIM
Use true to make user defined dimension required for this account, otherwise use false. UDD object integration name usually appended to REQUIREGLDIM. (Default: false)

.LINK
https://developer.intacct.com/api/general-ledger/stat-accounts/#create-statistical-account

#>
function New-StatisticalAccount {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$ACCOUNTNO,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$TITLE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CATEGORY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('forperiod','cumulative')]
        [string]$ACCOUNTTYPE='forperiod',

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('active','inactive')]
        [string]$STATUS='active',

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIREDEPT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIRELOC,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIREPROJECT,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIRECUSTOMER,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIREVENDOR,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIREEMPLOYEE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIREITEM,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIRECLASS,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIRETASK,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$REQUIREGLDIM
    )
    
    begin
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)::Begin"

        $SB = New-Object -TypeName System.Text.StringBuilder
        [void]$SB.Append("<function controlid='$( New-Guid )'>")
        [void]$SB.AppendLine("<create>")
    } # /begin
    
    process
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)::Process"
        Write-Debug "ACCOUNTNO: $ACCOUNTNO"

        [void]$SB.Append('<STATACCOUNT>')

        # mandatory
        if ($ACCOUNTNO) { [void]$SB.Append("<ACCOUNTNO>$ACCOUNTNO</ACCOUNTNO>") }
        if ($TITLE) { [void]$SB.Append("<TITLE>$TITLE</TITLE>") }

        # optional
        if ($CATEGORY) { [void]$SB.Append("<CATEGORY>$CATEGORY</CATEGORY>") }
        if ($ACCOUNTTYPE) { [void]$SB.Append("<ACCOUNTTYPE>$ACCOUNTTYPE</ACCOUNTTYPE>") }
        if ($STATUS) { [void]$SB.Append("<STATUS>$STATUS</STATUS>") }

        if ($REQUIREDEPT) { [void]$SB.Append("<REQUIREDEPT>$($REQUIREDEPT.ToString().ToLower())</REQUIREDEPT>") }
        if ($REQUIRELOC) { [void]$SB.Append("<REQUIRELOC>$($REQUIRELOC.ToString().ToLower())</REQUIRELOC>") }
        if ($REQUIREPROJECT) { [void]$SB.Append("<REQUIREPROJECT>$($REQUIREPROJECT.ToString().ToLower())</REQUIREPROJECT>") }
        if ($REQUIRECUSTOMER) { [void]$SB.Append("<REQUIRECUSTOMER>$($REQUIRECUSTOMER.ToString().ToLower())</REQUIRECUSTOMER>") }
        if ($REQUIREVENDOR) { [void]$SB.Append("<REQUIREVENDOR>$($REQUIREVENDOR.ToString().ToLower())</REQUIREVENDOR>") }
        if ($REQUIREEMPLOYEE) { [void]$SB.Append("<REQUIREEMPLOYEE>$($REQUIREEMPLOYEE.ToString().ToLower())</REQUIREEMPLOYEE>") }
        if ($REQUIREITEM) { [void]$SB.Append("<REQUIREITEM>$($REQUIREITEM.ToString().ToLower())</REQUIREITEM>") }
        if ($REQUIRECLASS) { [void]$SB.Append("<REQUIRECLASS>$($REQUIRECLASS.ToString().ToLower())</REQUIRECLASS>") }
        if ($REQUIRETASK) { [void]$SB.Append("<REQUIRETASK>$($REQUIRETASK.ToString().ToLower())</REQUIRETASK>") }
        if ($REQUIREGLDIM) { [void]$SB.Append("<REQUIREGLDIM>$($REQUIREGLDIM.ToString().ToLower())</REQUIREGLDIM>") }

        [void]$SB.AppendLine('</STATACCOUNT>')
    } # /process
    
    end
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)::End"

        [void]$SB.Append("</create>")
        [void]$SB.Append("</function>")

        $Function = $SB.ToString()
        # Write-Debug $Function

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
                        Write-Output $Content.response.operation.result.data.stataccount
                    }
                    else
                    {
                        Write-Error $_
                    }
    
                }
                'failure'
                {
                    # write an ErrorRecord for each error in the errormessage collection
                    foreach ($err in $Content.response.operation.result.errormessage.error) {

                        # create ErrorRecord
                        $Exception = New-Object ApplicationException $err.description2
                        $ErrorId = "$($MyInvocation.MyCommand.Module.Name).$($MyInvocation.MyCommand.Name) - $($err.errorno)"
                        $ErrorCategory = [System.Management.Automation.ErrorCategory]::NotSpecified
                        $ErrorRecord = New-Object Management.Automation.ErrorRecord $Exception, $ErrorId, $ErrorCategory, $Content

                        # write ErrorRecord
                        Write-Error -ErrorRecord $ErrorRecord -RecommendedAction $err.correction
                    }
                }    
    
            } # /switch

        }
        catch
        {   
            Write-Error $_
        }

    } # /end

}
