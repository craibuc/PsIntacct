<#
.SYNOPSIS

.PARAMETER Session

.PARAMETER Object
Any, valid Intacct class (e.g. 'APBILL','ARADJUSTMENT','ARINVOICE','ARPYMT')

.PARAMETER Fields
Any valid field for the specified class (e.g. 'RECORDNO','RECORDID','STATE','VENDORID','VENDORNAME','DOCNUMBER','SUPDOCID' for APBILL).

.PARAMETER Query
A query in the legacy, readByQuery syntax (e.g. "VendorName = 'Regal Services'").

.PARAMETER Offset
Number of records to skip before returning records.

.PARAMETER PageSize
Number of records to return.

.EXAMPLE
Find-Object -Session $Session -Object 'APBILL'

Return all APBILL records

.EXAMPLE
Find-Object -Session $Session -Object 'APBILL' -Fields 'RECORDNO','RECORDID','STATE','VENDORID','VENDORNAME','DOCNUMBER','SUPDOCID'

Return the specified fields for all APBILL records

.EXAMPLE
Find-Object -Session $Session -Object 'APBILL' -Query "STATE='A' AND SUPDOCID IS NULL"

Return Posted, Paid, or Partially Paid APBILL records that do not have an attachment record.

.LINK
Get-Class

.LINK
https://developer.intacct.com/api/platform-services/objects/

.LINK
https://developer.intacct.com/web-services/queries/#using-legacy-readbyquery

#>
function Find-Object {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(Mandatory)]
        # [ValidateSet('APBILL','ARADJUSTMENT','ARINVOICE','ARPYMT','BOOKING_TYPE','CONTACT','CUSTOMER','EMPLOYEE','GLACCOUNT','PROJECT','USERINFO','VENDOR')]
        [string]$Object,

        [Parameter()]
        [object]$Fields,

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
                <fields>$( $Fields.length -eq 0 ? '*' : ( $Fields -is [array] ? $Fields -join ',' : $Fields) )</fields>
                <query>$Query</query>
                <pagesize>$PageSize</pagesize>
            </readByQuery>
        </function>"
    Write-Debug $Function

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
