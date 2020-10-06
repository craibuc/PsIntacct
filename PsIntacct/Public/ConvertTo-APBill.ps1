<#
.PARAMETER WHENCREATED
Transaction date in format mm/dd/yyyy
.PARAMETER WHENPOSTED
GL posting date in format mm/dd/yyyy. Not used if PRBATCH provided.
.PARAMETER VENDORID
Vendor ID
.PARAMETER BILLTOPAYTOCONTACTNAME
Pay to contact
.PARAMETER SHIPTORETURNTOCONTACTNAME
Return to contact
.PARAMETER RECORDID
Bill number
.PARAMETER DOCNUMBER
Reference number
.PARAMETER DESCRIPTION
Description
.PARAMETER TERMNAME
Payment term
.PARAMETER RECPAYMENTDATE
Recommended to pay on date in format mm/dd/yyyy
.PARAMETER SUPDOCID
Attachments ID
.PARAMETER WHENDUE
Due date in format mm/dd/yyyy
.PARAMETER PAYMENTPRIORITY
Payment priority. Use either urgent, high, normal, low. (Default: normal)
.PARAMETER ONHOLD
On hold. Use false for No, true for Yes. (Default: false)
.PARAMETER PRBATCH
Summary name to post into. Required if bill summary option is set to user specified in AP config.
.PARAMETER CURRENCY
Transaction currency code
.PARAMETER BASECURR
Base currency code
.PARAMETER EXCH_RATE_DATE
Exchange rate date in format mm/dd/yyyy
.PARAMETER EXCH_RATE_TYPE_ID
Exchange rate type. Do not use if EXCHANGE_RATE is set. (Leave blank to use Intacct Daily Rate)
.PARAMETER EXCHANGE_RATE
Exchange rate value. Do not use if EXCH_RATE_TYPE_ID is set.
.PARAMETER INCLUSIVETAX
Inclusive taxes. Set to true to have the system calculate the transaction amount (TRX_AMOUNT) for the bill line and the transaction tax (TRX_TAX) for the tax entry based on the value supplied for TOTALTRXAMOUNT on the bill line and the tax rate of the tax detail (DETAILID) for the tax entry. (AU, GB, ZA only)
.PARAMETER ACTION
Action to execute on create. Use Draft or Submit. (Default: Submit)
.PARAMETER APBILLITEM
APBILLITEM[1...n]	Bill lines, must have at least 1.
.PARAMETER CUSTOMFIELDS
Custom fields. For a multi-pick-list custom field, implode multiple field values with #~#.
#>

function ConvertTo-APBill 
{

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [datetime]$WHENCREATED,
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$WHENPOSTED,
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string]$VENDORID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BILLTOPAYTOCONTACTNAME,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$SHIPTORETURNTOCONTACTNAME,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$RECORDID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DOCNUMBER,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$DESCRIPTION,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TERMNAME,
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$RECPAYMENTDATE,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$SUPDOCID,
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [datetime]$WHENDUE,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('urgent','high','normal','low')]
        [string]$PAYMENTPRIORITY,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$ONHOLD,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$PRBATCH,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CURRENCY,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$BASECURR,
        [Parameter(ValueFromPipelineByPropertyName)]
        [datetime]$EXCH_RATE_DATE,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$EXCH_RATE_TYPE_ID,
        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$EXCHANGE_RATE,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$INCLUSIVETAX,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Draft','Submit')]
        [string]$ACTION,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [pscustomobject[]]$APBILLITEM,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [pscustomobject]$CUSTOMFIELDS
    )
    
    begin {
        $SB = [Text.StringBuilder]::new()
        [void]$SB.Append("<APBILL>")  
    }
    
    process {
        
        foreach($parameter in $PSBoundParameters.GetEnumerator())
        {
            switch ($parameter.Key) {
                # encode reserved Xml characters (& --> &amp;)
                # {$_ -in 'NAME'} { 
                #     $Text = "<{0}>{1}</{0}>" -f $parameter.Key, [System.Security.SecurityElement]::Escape($parameter.Value)
                #     [void]$SB.Append( $Text )
                # }
                # boolean fields need to be lower case
                {$_ -in 'ONHOLD','INCLUSIVETAX'} { 
                    $Text = "<{0}>{1}</{0}>" -f $parameter.Key, $parameter.Value.ToString().ToLower()
                    [void]$SB.Append( $Text )
                }
                # date fields need to be mm/dd/yyyy
                {$_ -in 'WHENCREATED','WHENPOSTED','RECPAYMENTDATE','WHENDUE','EXCH_RATE_DATE'} { 
                    $Text = "<{0}>{1}</{0}>" -f $parameter.Key, $parameter.Value.ToString('MM/dd/yyyy')
                    [void]$SB.Append( $Text )
                }
                # pscustomobjects
                {$_ -in 'CUSTOMFIELDS'} {
                    foreach ($property in $parameter.Value.PSObject.Properties) {
                        $Text = "<{0}>{1}</{0}>" -f $property.Name, $property.Value
                        [void]$SB.Append( $Text )
                    }
                }
                {$_ -in 'APBILLITEM'} {
                    $dc = $parameter.Value | ConvertTo-APBillItem
                    [void]$SB.Append( $dc.OuterXml )
                }
                # otherwise
                Default { 
                    $Text = "<{0}>{1}</{0}>" -f $parameter.Key, $parameter.Value
                    [void]$SB.Append( $Text )
                }
            } # /switch
        } # /foreach

    }
    
    end {
        [void]$SB.Append("</APBILL>")
        Write-Debug $SB.ToString()
        [xml]$SB.ToString()   
    }

}