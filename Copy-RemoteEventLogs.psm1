function Copy-RemoteEventLogs{
    <#
    .SYNOPSIS
    Copies the remote event logs into the performance information folder

    .DESCRIPTION
    Copies the remote event logs into the performance information folder
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$session
    )

    $copylog = Invoke-Command -Session $session -ScriptBlock{
        # Set up the outcome dictionary
        $outcome = @{}
        # Get the timestamp of the command being run
        $outcome.Add("CopyEventLogTimestamp", (Get-Date).ToString())
        # Copy item
        $copyitem = Copy-Item -LiteralPath C:\Windows\System32\winevt\Logs -Destination C:\PerformanceInformation
        $outcome.Add("EventLogCopy", $copyitem)
        # Return results
        Write-Output $outcome
    }

    Write-Output $copylog

}