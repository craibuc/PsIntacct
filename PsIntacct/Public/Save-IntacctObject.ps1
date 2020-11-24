<#
.SYNOPSIS
Save an XML representation of an Intacct object.

.PARAMETER Session
The Session object returned by New-IntacctSession.

.PARAMETER ObjectXml
The Xml representation of an object, from ConvertTo-[Object]Xml
#>

function Save-IntacctObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ValueFromPipeline,Mandatory)]
        [xml]$ObjectXml
    )
    
    begin {}
    
    process 
    {

        $Verb = $ObjectXml.DocumentElement.GetElementsByTagName('RECORDNO').Count -eq 0 ? 'create' : 'update'

        $Function = 
        "<function controlid='$( New-Guid )'>
            <{0}>
                {1}
            </{0}>
        </function>" -f $Verb, $ObjectXml.OuterXml
        Write-Debug $Function

        $Content = Send-Request -Credential $Session.Credential -Session $Session -Function $Function

        Write-Debug "status: $($Content.response.operation.result.status)"
        switch ($Content.response.operation.result.status)
        {
            'success'
            {
                <#
                <response>
                    <operation>
                        <result>
                            <status>success</status>
                            <function>update</function>
                            <controlid>db762c48-1761-4086-bfc1-a7e6861fbc57</controlid>
                            <data listtype="objects" count="1">
                                <customer><RECORDNO>8346</RECORDNO><CUSTOMERID>Acme Anvils</CUSTOMERID></customer>
                            </data>
                        </result>
                    </operation>
                </response>
                #>
                # return the <result/> node
                $Content.response.operation.result
            }

            'failure'
            {
                # return the first error
                $Err = $Content.response.operation.result.errormessage.FirstChild
                $ErrorId = "{0}::{1} - {2}" -f $MyInvocation.MyCommand.Module.Name, $MyInvocation.MyCommand.Name, $Err.errorno
                $ErrorMessage = "{0}" -f $Err.description2 ?? $Err.errorno
                # $ErrorMessage = "{0} [{1}]: {2}" -f $ObjectXml.CUSTOMER.NAME, $ObjectXml.CUSTOMER.CUSTOMERID, $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        } # /switch
        
    }
    
    end {}
}