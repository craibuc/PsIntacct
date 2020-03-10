<#
.PARAMETER ContactName
Contact name to create

.PARAMETER PrintAs
Print as

.PARAMETER CompanyName
Company name

.PARAMETER Taxable
Taxable. Use false for No, true for Yes. (Default: true)

.PARAMETER TAXGROUP
Contact tax group name

.PARAMETER PREFIX
Prefix

.PARAMETER FIRSTNAME
First name

.PARAMETER LASTNAME
Last name

.PARAMETER INITIAL
Middle name

.PARAMETER PHONE1
Primary phone number

.PARAMETER PHONE2
Secondary phone number

.PARAMETER CELLPHONE
Cellular phone number

.PARAMETER PAGER
Pager number

.PARAMETER FAX
Fax number

.PARAMETER EMAIL1
Primary email address

.PARAMETER EMAIL2
Secondary email address

.PARAMETER URL1
Primary URL

.PARAMETER URL2
Secondary URL

.PARAMETER STATUS
Status. Use active for Active or inactive for Inactive (Default: active)

.PARAMETER MAILADDRESS
Mail address

#>
function New-Contact {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [pscustomobject]$Session,
        
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$ContactName,
        
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$PrintAs,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$CompanyName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$Taxable=$true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$TaxGroup,

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$Prefix,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FirstName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Initial,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$LastName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Phone1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Phone2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Cellphone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Pager,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Fax,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Email1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Email2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Url1,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Url2,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('active','inactive')]
        [string]$STATUS='active'

        # [Parameter(ValueFromPipelineByPropertyName)]
        # [string]$MAILADDRESS
    )

    Begin
    {
        Write-Debug "$($MyInvocation.MyCommand.Name)"

        Write-Debug "Sender: $($Session.Credential.UserName)"
        Write-Debug "sessionid: $($Session.sessionid)"
        Write-Debug "endpoint: $($Session.endpoint)"

        $Password = $Session.Credential | ConvertTo-PlainText
        $Timestamp = Get-Date -UFormat %s
        $Guid = New-Guid
    
        $Contacts = @()

    } # /begin

    Process
    {

        $Contact = `
@"
<CONTACT>
    <CONTACTNAME>$ContactName</CONTACTNAME>
    <PRINTAS>$PrintAs</PRINTAS>
    <COMPANYNAME>$CompanyName</COMPANYNAME>
    <TAXABLE>$($Taxable.ToString().ToLower())</TAXABLE>
    <TAXGROUP>$TaxGroup</TAXGROUP>
    <PREFIX>$Prefix</PREFIX>
    <FIRSTNAME>$FirstName</FIRSTNAME>
    <INITIAL>$Initial</INITIAL>
    <LASTNAME>$LastName</LASTNAME>
    <PHONE1>$Phone1</PHONE1>
    <PHONE2>$Phone2</PHONE2>
    <CELLPHONE>$CellPhone</CELLPHONE>
    <PAGER>$Pager</PAGER>
    <FAX>$Fax</FAX>
    <EMAIL1>$Email1</EMAIL1>
    <EMAIL2>$Email2</EMAIL2>
    <URL1>$Url1</URL1>
    <URL2>$Url2</URL2>
    <STATUS>$Status</STATUS>
</CONTACT>
"@

# 
# <MAILADDRESS>$MAILADDRESS</MAILADDRESS>

        $Contacts += $Contact

    } # /process

    End
    {

        $Body = `
@"
<?xml version="1.0" encoding="UTF-8"?>
<request>
    <control>
        <senderid>$($Session.Credential.UserName)</senderid>
        <password>$Password</password>
        <controlid>$Timestamp</controlid>
        <uniqueid>false</uniqueid>
        <dtdversion>3.0</dtdversion>
        <includewhitespace>false</includewhitespace>
    </control>
    <operation>
        <authentication>
            <sessionid>$($Session.sessionid)</sessionid>
        </authentication>
        <content>
            <function controlid='$Guid'>
                <create>
                $( $Contacts -Join '`r' )
                </create>
            </function>
        </content>
    </operation>
</request>
"@

        # Write-Debug $Body

        try
        {
            $Response = Invoke-WebRequest -Method POST -Uri $Session.endpoint -Body $Body -ContentType 'application/xml'

            $Content = [xml]$Response.Content

            Write-Debug "status: $($Content.response.control.status)"

            switch ( $Content.response.control.status )
            {
                'success'
                {  
                    $Content.response.operation.result.data.customer
                }
                'failure'
                { 
                Write-Debug "Error: $($Content.response.errormessage.error.description2)"
                # raise an exception
                Write-Error -Message $Content.response.errormessage.error.description2
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

    } # /end

}
