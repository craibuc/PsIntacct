<#
.SYNOPSIS
Retrieve all attachment or a specific attachment by its supdocid.

.DESCRIPTION
Retrieve all attachment or a specific attachment by its supdocid.

.PARAMETER  supdocid
supdocid of the attachment.

.PARAMETER start
Start at item, zero-based integer

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
Get-IntacctAttachment -Session $Session -Id 'ATT-0000' | ForEach-Object {

Get attachment 'ATT-0000'.

.EXAMPLE

# go to user's Desktop
Push-Location "~/Desktop"

# get specified attachment
Get-IntacctAttachment -Session $Session -Id 'ATT-0000' | ForEach-Object {

    # generate filename
    $Filename = "{0}.{1}" -f $_.attachments.attachment.attachmentname, $_.attachments.attachment.attachmenttype

    # convert base-64 encoded value to byte stream
    $Bytes = [Convert]::FromBase64String($_.attachments.attachment.attachmentdata)

    # save file
    Set-Content -Path $Filename -Value $Bytes -AsByteStream
}

# restore original directory
Pop-Location

Get attachment 'ATT-0000' and save all of its assocated files to the user's Desktop.

#>
function Get-IntacctAttachment {

    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='All', Mandatory)]
		[Parameter(ParameterSetName='ById', Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ParameterSetName='ById',Mandatory)]
        [string]$supdocid,

        # [Parameter(ParameterSetName='All')]
        # [int]$start,

        # [Parameter(ParameterSetName='All')]
        # [int]$maxitems

        # [Parameter(ParameterSetName='All')]
        # [bool]$showprivate,

        [Parameter(ParameterSetName='All')]
        [pscustomobject]$filter,

        # [Parameter(ParameterSetName='All')]
        # [object[]]$sorts,

        [Parameter(ParameterSetName='All')]
        [Parameter(ParameterSetName='ById')]
        [ValidateSet('recordno', 'supdocid', 'supdocname', 'folder', 'description', 'creationdate', 'createdby','attachments')]
        [string[]]$fields
    )    
    Write-Debug "$($MyInvocation.MyCommand.Name)"
    

    #
    # create 'Function' XML
    #

    $SB = [Text.StringBuilder]::new()
    [void]$SB.Append("<function controlid='$( New-Guid )'>")

    switch ($PSCmdlet.ParameterSetName)
    {
        <#
        <get_list object="supdoc" start='0' maxitems="10" showprivate='true'>
            <filter>
                <expression>
                    <field>supdocname</field><operator>=</operator><value>lorem_ipsum_3</value>
                </expression>
                <logical/>
            </filter>
            <sorts>
                <sortfield order='asc'>supdocname</sortfield>
            </sorts>
            <fields>
                <field>supdocid</field><field>supdocname</field>
            </fields>
        </get_list>
        #>
        'All' 
        { 
            [void]$SB.Append("<get_list object='supdoc'>") 

            if ($filter.expression) 
            {
                [void]$SB.Append( '<filter><expression>')
                [void]$SB.Append( ('<field>{0}</field><operator>{1}</operator><value>{2}</value>' -f $filter.expression.field, $filter.expression.operator, $filter.expression.value) )
                [void]$SB.Append( '</expression></filter>')
            }
            # TODO: finish logical implementation
            if ($filter.logical) 
            {
                [void]$SB.Append( '<filter><logical>')
                # [void]$SB.Append( ('<field>{0}</field><operator>{1}</operator><value>{2}</value>' -f $filter.expression.field, $filter.expression.operator, $filter.expression.value) )
                [void]$SB.Append( '</logical></filter>')
            }
            # TODO: finish sorts implementation
            # if ($sorts) { [void]$SB.Append( '<sorts><sortfield>{0}</sortfield></sorts>' -f ( $sorts -join '</sortfield><sortfield>') ) }
            if ($fields) { [void]$SB.Append( '<fields><field>{0}</field></fields>' -f ( $fields -join '</field><field>') ) }

            [void]$SB.Append("</get_list>")
        }

        <#
        <get object="supdoc" key='ATT-00000'>
            <fields><field>supdocid</field><field>supdocname</field></fields>
        </get>
        #>
        'ById' 
        {
            [void]$SB.Append("<get object='supdoc' key='$supdocid'>")
            if ($fields) { [void]$SB.Append( '<fields><field>{0}</field></fields>' -f ( $fields -join '</field><field>') ) }
            [void]$SB.Append("</get>")
        }
    }
    
    [void]$SB.Append("</function>")
    $Function = $SB.ToString()

    Write-Debug "Function: $Function"

    # TODO: implement support for attributes; need to convert $Function to XML
    # if ( $PSCmdlet.ParameterSetName -eq 'All' )
    # {
    #     if ($start) { $function.function.get_list.SetAttribute('start',$start) }
    #     if ($maxitems) { $function.function.get_list.SetAttribute('maxitems',$maxitems) }
    #     if ($showPrivate) { $function.function.get_list.SetAttribute('showPrivate',$showPrivate.ToString().ToLower() ) }
    # }

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

}
