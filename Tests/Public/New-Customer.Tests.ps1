# /PsIntacct
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsIntacct/PsIntacct/Public
$PublicPath = Join-Path $ProjectDirectory "/PsIntacct/Public/"
$PrivatePath = Join-Path $ProjectDirectory "/PsIntacct/Private/"

# /PsIntacct/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-Dimension.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsIntacct/PsIntacct/Public/Get-Dimension.ps1
. (Join-Path $PublicPath $sut)

# dependencies
. (Join-Path $PrivatePath "Send-Request.ps1")

Describe "New-Customer" -Tag 'unit' {

    Context "Default" {

        Mock Send-Request {
            $Content = 
            "<response>
                <operation>
                    <result>
                        <status>success</status>
                        <function>create</function>
                        <controlid>1</controlid>
                        <data listtype='objects' count='1'>
                            <customer>
                                <RECORDNO>27</RECORDNO>
                                <CUSTOMERID>ACME</CUSTOMERID>
                            </customer>
                        </data>
                    </result>
                </operation>
            </response>"
            $Content
        } # /mock

        It "creates a customer" -Skip {
            $true | Should -Be $false
        }
    
    } # /success

    Context "Duplicate" {

        Mock Send-Request {
            $Content = 
            "<response>
                <operation>
                    <result>
                        <status>failure</status>
                        <function>create</function>
                        <controlid>1</controlid>
                        <data listtype='objects' count='0'/>
                        <errormessage>
                            <error>
                                <errorno>BL34000061</errorno>
                                <description></description>
                                <description2>Another Contact with the given value(s)   already exists</description2>
                                <correction>Use a unique value instead.</correction>
                            </error>
                            <error>
                                <errorno>BL01001973</errorno>
                                <description></description>
                                <description2>Could not create Contact record!</description2>
                                <correction></correction>
                            </error>
                            <error>
                                <errorno>BL01001973</errorno>
                                <description></description>
                                <description2>Error While Saving the Display Contact</description2>
                                <correction></correction>
                            </error>
                            <error>
                                <errorno>BL01001973</errorno>
                                <description></description>
                                <description2>Could not create Customer record!</description2>
                                <correction></correction>
                            </error>
                        </errormessage>
                    </result>
                </operation>
            </response>"
            $Content
        } # /mock

    } # /context

    <#
    <?xml version="1.0" encoding="UTF-8"?>
<response>
    <operation>
        <result>
            <status>failure</status>
            <function>create</function>
            <controlid>1</controlid>
            <data listtype="objects" count="0"/>
            <errormessage>
                <error>
                    <errorno>BL03000018</errorno>
                    <description></description>
                    <description2>Illegal format for Contactversion : Primary Email Address @aeon.org.</description2>
                    <correction></correction>
                </error>
                <error>
                    <errorno>BL01001973</errorno>
                    <description></description>
                    <description2>Validate contactversion record failed!</description2>
                    <correction></correction>
                </error>
                <error>
                    <errorno>BL01001973</errorno>
                    <description></description>
                    <description2>Could not create contactversion record!</description2>
                    <correction></correction>
                </error>
                <error>
                    <errorno>BL01001973</errorno>
                    <description></description>
                    <description2>Could not create ContactVersion record!</description2>
                    <correction></correction>
                </error>
                <error>
                    <errorno>BL01001973</errorno>
                    <description></description>
                    <description2>Could not create Contact record!</description2>
                    <correction></correction>
                </error>
                <error>
                    <errorno>BL01001973</errorno>
                    <description></description>
                    <description2>Error While Saving the Display Contact</description2>
                    <correction></correction>
                </error>
                <error>
                    <errorno>BL01001973</errorno>
                    <description></description>
                    <description2>Could not create Customer record!</description2>
                    <correction></correction>
                </error>
            </errormessage>
        </result>
    </operation>
</response>
    #>
}
