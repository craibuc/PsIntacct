$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# dot-source dependencies
$Parent = Split-Path -Parent $here
. "$Parent/Private/Send-Request.ps1"
. "$here\New-GLEntry.ps1"

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-StatisticalJournalEntry" {

    # arrange
    $Credential = New-MockObject -Type PsCredential
    $Session = [PsCustomObject]@{Credential=$Credential;sessionid='abcdefghi';endpoint='https://x.y.z'}
    
    $Entries = [pscustomobject]@{ACCOUNTNO='HEADS';TRX_AMOUNT=2.00;TR_TYPE=1} | New-GLEntry
    # $Entries += [pscustomobject]@{
    #     ACCOUNTNO='HEADS'
    #     TRX_AMOUNT=2.00
    #     TR_TYPE=1
    # }
    
    $Today = (Get-Date).Date

    BeforeEach {
        $Batch = [pscustomobject]@{
            JOURNAL='SHC'
            BATCH_DATE= $Today
            BATCH_TITLE='batch title'
            ENTRIES=$Entries
        }    
    }

    Context "General" {

        it "has 4, mandatory parameters" {
            Get-Command "New-StatisticalJournalEntry" | Should -HaveParameter Session -Mandatory
            Get-Command "New-StatisticalJournalEntry" | Should -HaveParameter JOURNAL -Mandatory
            Get-Command "New-StatisticalJournalEntry" | Should -HaveParameter BATCH_DATE -Mandatory
            Get-Command "New-StatisticalJournalEntry" | Should -HaveParameter BATCH_TITLE -Mandatory
            Get-Command "New-StatisticalJournalEntry" | Should -HaveParameter ENTRIES -Mandatory
        }

    }

    Context "Mandatory parameters" {

        # arrange
        Mock Send-Request

        it "calls Send-Request with the expected parameter values" {
            # act
            $Batch | New-StatisticalJournalEntry -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $element = ([xml]$Function).function.create.GLBATCH
                $element.JOURNAL -eq $Batch.JOURNAL -and 
                $element.BATCH_DATE -eq $Batch.BATCH_DATE.ToString('MM/dd/yyyy') -and 
                $element.BATCH_TITLE -eq $Batch.BATCH_TITLE -and 
                $element.ENTRIES -ne $null -and
                # optional
                $element.REVERSEDATE -eq $null -and 
                $element.HISTORY_COMMENT -eq $null -and 
                $element.REFERENCENO -eq $null -and 
                $element.SUPDOCID -eq $null -and 
                $element.STATE -eq 'Posted'
            }

        } # /it

    } # /context

    Context "Optional parameters" {

        # arrange
        Mock Send-Request

        it "calls Send-Request with the expected parameter values" {

            # arrange
            $Tomorrow = $Today.AddDays(1) # REVERSEDATE > BATCH_DATE
            $Batch | Add-Member -MemberType NoteProperty -Name 'REVERSEDATE' -Value $Tomorrow
            $Batch | Add-Member -MemberType NoteProperty -Name 'HISTORY_COMMENT' -Value 'lorem ipsum'
            $Batch | Add-Member -MemberType NoteProperty -Name 'REFERENCENO' -Value '0123456789'
            $Batch | Add-Member -MemberType NoteProperty -Name 'SUPDOCID' -Value '1234,5678'
            $Batch | Add-Member -MemberType NoteProperty -Name 'STATE' -Value 'Draft'

            # act
            $Batch | New-StatisticalJournalEntry -Session $Session

            # assert
            Assert-MockCalled Send-Request -ParameterFilter {
                $element = ([xml]$Function).function.create.GLBATCH
                $element.REVERSEDATE -eq $Tomorrow.ToString('MM/dd/yyyy') -and 
                $element.HISTORY_COMMENT -eq $Batch.HISTORY_COMMENT -and 
                $element.REFERENCENO -eq $Batch.REFERENCENO -and 
                $element.SUPDOCID -eq $Batch.SUPDOCID -and 
                $element.STATE -eq $Batch.STATE # -and 
            }

        } # /it

    } # /context

    Context "Parameter validation" {

        it "REVERSEDATE < BATCH_DATE" {
            # arrange
            $Yesterday = $Today.AddDays(-1) # REVERSEDATE < BATCH_DATE
            $Batch | Add-Member -MemberType NoteProperty -Name 'REVERSEDATE' -Value $Yesterday

            # act / assert
            { $Batch | New-StatisticalJournalEntry -Session $Session } | Should -Throw "REVERSE_DATE must be after BATCH_DATE"
        }
    }

} # /describe
