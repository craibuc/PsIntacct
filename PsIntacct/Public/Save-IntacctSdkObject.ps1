<#
.SYNOPSIS

.PARAMETER InputObject
The object (e.g. CustomerCreate, CustomerUpdate, CustomerDelete) to be saved.

.EXAMPLE
@{CustomerName='Acme Anvils, Inc.';PrintAs='Coyote, Wile E.';FirstName='Wile E.';LastName='Coyote';Active=$true} | New-IntacctSdkObject -TypeName 'CustomerCreate' | Save-IntacctSdkObject

#>
function Save-IntacctSdkObject {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
        
        if ( -Not $Script:ClientConfig)
        {
            throw "Invalid credentials"
        }

        [Intacct.SDK.OnlineClient] $OnlineClient = [Intacct.SDK.OnlineClient]::new($Script:ClientConfig)    
    }

    process {

        if ($PSCmdlet.ShouldProcess($InputObject.GetType().Name, 'OnlineClient.Execute'))
        {
            [System.Threading.Tasks.Task[Intacct.SDK.Xml.OnlineResponse]]$task = $OnlineClient.Execute($InputObject);
    
            $task.Wait()
        
            [Intacct.SDK.Xml.OnlineResponse]$Response = $task.Result
        
            $Response.Results[0]    
        }
    
    }

    end {}

}