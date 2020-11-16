BeforeAll {

    # /PsIntacct
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsIntacct/PsIntacct/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"

    # /PsIntacct/PsIntacct/Private
    $PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

    # /PsIntacct/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dependencies
    . $PrivatePath/Send-Request.ps1

    # Get-IntacctAttachmentFolder.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsIntacct/PsIntacct/Public/Get-IntacctAttachmentFolder.ps1
    $Path = Join-Path $PublicPath $sut

    . $Path
}

Describe "Get-IntacctAttachmentFolder" -Tag 'unit' {

    Context "Parameter validation" {

        BeforeAll {
            $Command = Get-Command 'Get-IntacctAttachmentFolder'
        } 

        $Parameters = @(
            @{
                ParameterName = 'Session'
                Type = [pscustomobject]
                ParameterSets = @(
                    @{ParameterSetName='All';Mandatory=$true}
                    @{ParameterSetName='ByName';Mandatory=$true}
                )
            }
            # @{
            #     ParameterName = 'start'
            #     Type = [int]
            #     Mandatory = $false
            # }
            # @{
            #     ParameterName = 'maxitems'
            #     Type = [int]
            #     Mandatory = $false
            # }
            # @{
            #     ParameterName = 'showprivate'
            #     Type = [bool]
            #     Mandatory = $false
            # }
            # @{
            #     ParameterName = 'filter'
            #     Type = [object]
            #     Mandatory = $false
            # }
            # @{
            #     ParameterName = 'sorts'
            #     Type = [object[]]
            #     Mandatory = $false
            # }
            @{
                ParameterName = 'name'
                Type = [string]
                ParameterSets = @(
                    @{ParameterSetName='All';Mandatory=$false}
                    @{ParameterSetName='ByName';Mandatory=$true}
                )
            }
            # @{
            #     ParameterName = 'Fields'
            #     Type = [object[]]
            #     Mandatory = $false
            # }
        ) | ForEach-Object {

            $Parameter = $_

            It "<ParameterName> is a <Type>" -TestCases $Parameter {
                param ($ParameterName, $Type)
                $Command | Should -HaveParameter $ParameterName -Type $Type
            }

            $_.ParameterSets | ForEach-Object {

                $Case = @{
                    ParameterName = $Parameter.ParameterName
                }
                $Case += $_

                It "<ParameterName> is $( $_.Mandatory ? 'a mandatory': 'an optional') member of <ParameterSetName>" -TestCases $Case {
                    param ($ParameterName,$ParameterSetName,$Mandatory)
                    $Command.Parameters[$ParameterName].ParameterSets[$ParameterSetName].IsMandatory -eq $Mandatory
                }
    
            }
    
        }

        # Context "Type" {
        #     It "<ParameterName> is a <Type>" -TestCases $Parameters {
        #         param ($ParameterName, $Type)
        #         $Command | Should -HaveParameter $ParameterName -Type $Type
        #     }    
        # }

        # Context "Mandatory" -skip {
        #     it '<ParameterName> mandatory is <Mandatory>' -TestCases $Parameters {
        #         param($ParameterName, $Type, $Mandatory)
              
        #         if ($Mandatory) { $Command | Should -HaveParameter $ParameterName -Mandatory }
        #         else { $Command | Should -HaveParameter $ParameterName -Not -Mandatory }
        #     }    
        # }

    } # /Contect - parameter validation

    Context "when 'Session' is supplied" {

        BeforeAll {
            # arrange
            $Credential = New-MockObject -Type PsCredential
            $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://intacct.com'}        
        }

        BeforeEach {
    
            Mock Send-Request {
                $Fixture = 'Get-AttachmentFolder.Response.xml'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw
                # # Write-Debug $Content
                # [xml]$Content    

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            # act
            $Actual = Get-IntacctAttachmentFolder -Session $Session
        }

        it "configures the function element properly" {

            # <function controlid='$Guid'><get_list object="supdocfolder"></get_list></function>

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $verb = ([xml]$Function).function.get_list
                $verb.object -eq 'supdocfolder'
            }    
        }

        # Context "when 'start' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'maxitems' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'showPrivate' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'filter' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'sorts' is supplied" {
        #     It "does something" {}
        # }
        # Context "when 'fields' is supplied" {
        #     It "does something" {}
        # }

        Context "when 'name' is supplied" {

            BeforeEach {
                # arrange
                $name = 'loremIpsum'

                # act
                $Actual = Get-IntacctAttachmentFolder -Session $Session -name $name
            }

            it "configures the function element properly" {

                # <function controlid='$Guid'><get object="supdocfolder" key="Bills"></get></function>

                # assert
                Should -Invoke Send-Request -ParameterFilter {
                    $verb = ([xml]$Function).function.get
                    $verb.object -eq 'supdocfolder' -and
                    $verb.key -eq $name
                }

            }

            # Context "when 'fields' is supplied" {
            #     It "does something" {}
            # }
        }

    }

} # /Describe