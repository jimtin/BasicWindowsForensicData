function Move-WinPmem{
    <#
        .SYNOPSIS
        Moves WinPmem 1.6 across to target machine

        .DESCRIPTION
        Uses WinRM protocol to move Winpmem across to the local machine. 
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$Session
    )
    # Set up outcome dictionary
    $outcome = @{}
    # Get the timestamp of action occurring
    $outcome.Add("TransferredWinPMEMTimestamp", (Get-Date).ToString())
    # Move WinPMEM Across
    $winpmem = Copy-Item -Path .\winpmem_1.6.2.exe -Destination "C:\PerformanceInformation\mem_info.exe" -ToSession $Session
    $outcome.Add("WinPMEMTransfer", $winpmem)
    # Return the outcome
    Write-Output $outcome
    
}