function Get-MemoryDump{
    <#
    .SYNOPSIS
    Gets the memory dump from the remote endpoint using a Powershell Session

    .DESCRIPTION
    Retrieves the memory dump using a Powershell Session
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$session,
        [Parameter(Mandatory=$true)]$TargetHostName, 
        [Parameter(Mandatory=$true)]$Location
    )

    # Set up the outcome dictionary
    $outcome = @{}
    $outcome.Add("GetMemoryDumpTimestamp", (Get-Date).ToString())
    # Construct the destination string
    $deststring = $Location + "\" + $TargetHostname + ".raw"
    $copyitem = Copy-Item -FromSession $session -Path C:\PerformanceInformation\memory.raw -Destination $deststring
    $outcome.Add("GetMemoryDumpOutcome", $copyitem)
    Write-Output $outcome
}