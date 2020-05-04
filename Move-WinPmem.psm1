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

    # Move WinPMEM Across
    $outcome = Copy-Item -Path .\winpmem_1.6.2.exe -Destination C:\PerformanceInformation\mem_info.exe -ToSession $Session
    
    # Return the outcome
    Write-Output $outcome
    
}