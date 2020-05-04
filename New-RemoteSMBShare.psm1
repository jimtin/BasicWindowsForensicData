function New-RemoteSMBShare{
    <#
        .SYNOPSIS
        Creates an SMB Share on remote endpoint

        .DESCRIPTION
        Creates an SMB Share on a remote endpoint
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$Session,
        [Parameter(Mandatory=$true)]$Target
    )

    $outcome = @{}
    # Create the share on the endpoint, including permissions for only administrators
    $newsmbshare = Invoke-Command -Session $Session -ScriptBlock{
        New-SmbShare -Name "PerformanceInformation" -Path "C:\PerformanceInformation" -FullAccess "Administrators"
    }
    $outcome.Add("CreatedSMBDate", (Get-Date).ToString())
    $outcome.Add("NewSMBShareDetails", $newsmbshare)
    Write-Output $outcome
}