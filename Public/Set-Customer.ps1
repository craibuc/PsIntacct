function Set-Customer {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$CUSTOMER
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
                    $CUSTOMER
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
                $ErrorNumber = $Err.errorno
                $ErrorMessage = $Err.description2 -eq '' ? $Err.errorno : $Err.description2
                # $Correction = $Err.correction

                $Exception = [Exception]::new($ErrorMessage)
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    $Exception,
                    $ErrorNumber,
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    $Content.response.operation.result
                )
                # $ErrorRecord.ErrorDetails.RecommendedAction = $Correction 
                $PSCmdlet.WriteError($ErrorRecord)

                # Write-Error -Message $ErrorMessage -ErrorId $ErrorNumber -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        }
    
    }
    
    end {}

}
