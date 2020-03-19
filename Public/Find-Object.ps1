function Find-Object {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory)]
        [ValidateSet('GLACCOUNT','PROJECT','BOOKING_TYPE')]
        [string]$Object,

        [Parameter()]
        [string]$Fields='*',

        [Parameter()]
        [string]$Query,

        [Parameter()]
        [int]$Offset,

        [Parameter()]
        [ValidateRange(1,2000)]
        [int]$PageSize=100
    )
    
    Write-Debug "$($MyInvocation.MyCommand.Name)"

    $Function =
        "<function controlid='$(New-Guid)'>
            <readByQuery>
                <object>$Object</object>
                <fields>$Fields</fields>
                <query>$Query</query>
                <pagesize>$PageSize</pagesize>
            </readByQuery>
        </function>"
    # Write-Debug $Function

    try
    {
        # $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
        # Write-Debug "status: $($Content.response.operation.result.status)"

        do 
        {  
            $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function
            Write-Debug "status: $($Content.response.operation.result.status)"
      
            # get Uri for the next set of records
            $data = $Content.response.operation.result.data

            # Write-Debug "listtype: $($data.listtype)"
            # Write-Debug "totalcount: $($data.totalcount)"
            # Write-Debug "numremaining: $($data.numremaining)"
            # Write-Debug "resultId: $($data.resultId)"

            # redefine the function call
            $Function = 
            "<function controlid='$($Content.response.operation.result.controlid)'>
                <readMore>
                    <resultId>$($Content.response.operation.result.data.resultId)</resultId>
                </readMore>
            </function>"
            # Write-Debug "Function: $Function"

            # return data
            $Content.response.operation.result.data.selectnodes($data.listtype)

            # returns PsCustomObject representation of object
            # if ( $Content.data ) { $Content.data }
    
            # otherwise raise an exception
            # elseif ($Content.error) { Write-Error -Message $Content.error.message }

            # GET next set of results
            # $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function

        } while ( $data.numremaining -gt 0 )

    }
    catch {
        $_
    }

}
