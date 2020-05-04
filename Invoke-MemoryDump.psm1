function Invoke-MemoryDump{
    <#
    .SYNOPSIS
    Invokes memory dump on a remote endpoint

    .DESCRIPTION
    Uses WinPmem 1.6.2 on the remote endpoint to dump memory into performance data

    #>

    [CmdletBinding()]
    param (
        $Session
    )

    $outcome = @{}
    # Test that WinPMEM exists
    $mem_info = Invoke-Command -Session $Session -ScriptBlock{Test-Path -LiteralPath "C:\PerformanceInformation\mem_info.exe"}
    # Compute that we have enough space
    $spaceneeds = Invoke-Command -Session $Session -ScriptBlock {
        # Get the total physical memory size 
        $ramsize = [Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName localhost).TotalPhysicalMemory/1Gb)
        # Check that there is enough space on disk
        $disk = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" ).FreeSpace/1GB
        # Setup outcome
        $outcome = @{}
        $outcome.Add("MemorySize", $ramsize)
        $outcome.Add("FreeDiskSpace", $disk)
        Write-Output $outcome
    }

    if ($spaceneeds.FreeDiskSpace -gt $spaceneeds.MemorySize){
        Write-Information -InformationAction Continue -MessageData "Endpoint has enough space"
        if($mem_info -eq $true){
            Write-Information -InformationAction Continue -MessageData "WinPMEM exits"
            Write-Information -InformationAction Continue -MessageData "Dumping memory"
            Invoke-Command -Session $session -ScriptBlock{C:\PerformanceInformation\mem_info.exe "C:\PerformanceInformation\memory.raw"}
        }
        $outcome.Add("MemDumpOperation", (Get-Date).ToString())
    }else{
        $outcome.Add("MemDumpOperation", "NotEnoughDiskSpace")
    }
        
    Write-Output $outcome
}
