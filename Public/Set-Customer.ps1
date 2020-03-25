function Set-Customer {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ValueFromPipeline,Mandatory)]
        [xml]$CustomerXml
    )

    begin 
    {
        Write-Debug $MyInvocation.MyCommand.Name
    }
    
    process 
    {
        $Function = 
            "<function controlid='$( New-Guid )'>
                <update>
                    $( $CustomerXml.OuterXml )
                </update>
            </function>"

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
                            <function>create</function>
                            <controlid>db762c48-1761-4086-bfc1-a7e6861fbc57</controlid>
                            <data listtype="objects" count="1">
                                <customer><RECORDNO>8346</RECORDNO><CUSTOMERID>CentralLut</CUSTOMERID></customer>
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
                $ErrorMessage = "{0} [{1}]: {2}" -f $customerxml.CUSTOMER.NAME, $customerxml.CUSTOMER.CUSTOMERID, $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                Write-Error -Message $ErrorMessage -ErrorId $ErrorId -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        }
    
    }
    
    end {}

}
