<#
.SYNOPSIS
Create a new instance of an Intacct class.

.PARAMETER Name
The name of the object.

.EXAMPLE
New-IntacctSdkObject -TypeName 'CustomerCreate'

.EXAMPLE
@{CustomerName='Acme Anvils, Inc.';PrintAs='Coyote, Wile E.';FirstName='Wile E.';LastName='Coyote';Active=$true} | New-IntacctSdkObject -TypeName 'CustomerCreate'

ControlId                           : a208bea4-2d77-4e6b-94fb-a95f47d8dd26
CustomerId                          : 
CustomerName                        : Acme Anvils, Inc.
OneTime                             : 
Active                              : True
LastName                            : Coyote
FirstName                           : Wile E.
MiddleName                          : 
Prefix                              : 
CompanyName                         : 
PrintAs                             : Coyote, Wile E.
PrimaryPhoneNo                      : 
SecondaryPhoneNo                    : 
CellularPhoneNo                     : 
...
#>
function New-IntacctSdkObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$TypeName,

        [Parameter(ValueFromPipeline)]
        [object]$InputObject
    )
    
    $Type = Find-IntacctSdkType -Expression $TypeName

    if (-Not $Type) { throw "Type not found: $TypeName" } 
    
    # constructor
    $Object = $Type::New()

    # attempt to populate fields and properties
    if ($InputObject)
    {
        foreach ($item in $InputObject.GetEnumerator()) {
        
            # try field
            if ( $null -ne $Object.GetType().GetField($item.Key) )
            {
                $Object.GetType().GetField($item.Key).SetValue($Object, $item.Value)
            }
            # try property
            elseif ( $null -ne $Object.GetType().GetProperty($item.Key) ) 
            {
                $Object.GetType().GetProperty($item.Key).SetValue($Object, $item.Value, $null)        
            }
    
        }
    }


    # return it
    $Object

}