function Get-MemoryDump{
    <#
    .SYNOPSIS
    Gets the memory dump from the remote endpoint using SMB

    .DESCRIPTION
    Retrieves the memory dump using the SMB Share created 
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$session,
        [Parameter(Mandatory=$true)]$TargetHostname
    )

    # Set up the outcome dictionary
    $outcome = @{}
    $outcome.Add("GetMemoryDumpTimestamp", (Get-Date).ToString())
    # Get the current location
    $location = (Get-Location).ToString()
    # Construct the destination string
    $deststring = $location + "\" + $TargetHostname + ".raw"
    $copyitem = Copy-Item -FromSession $session -Path C:\PerformanceInformation\memory.raw -Destination $deststring
    $outcome.Add("GetMemoryDumpOutcome", $copyitem)
    Write-Output $outcome
}