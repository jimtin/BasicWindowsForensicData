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
        [Parameter(Mandatory=$true)]$TargetHostname, 
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