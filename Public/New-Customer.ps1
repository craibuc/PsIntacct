function New-Customer {

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
                <create>
                    $CUSTOMER
                </create>
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
                $ErrorMessage = $Err.description2 ?? $Err.errorno
                $Correction = $Err.correction

                # if duplicate, throw an exception
                if ( $ErrorNumber -eq 'BL34000061' ) 
                {
                    throw New-Object System.ArgumentException $ErrorMessage
                }

                Write-Error -Message $ErrorMessage -ErrorId $ErrorNumber -Category InvalidArgument -RecommendedAction $Correction -TargetObject $Content.response.operation.result
            }
        }
    
    }
    # BL01001973/"Cannot figure out country code from country US"
    end {}

}
