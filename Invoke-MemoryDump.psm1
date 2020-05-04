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

    $spaceneeds = Invoke-Command -Session $Session -ScriptBlock {
        # Get the total physical memory size 
        $ramsize = [Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName localhost).TotalPhysicalMemory/1Gb)
        # Check that there is enough space on disk
        $disk = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" ).FreeSpace/1GB
        # Setup outcome
        $outcome = @{
            "MemorySize" = $ramsize
            "FreeDiskSpace" = $disk
        }
    }
    if ($spaceneeds.disk -gt $spaceneeds.ramsize){
        # Run memory dump
        Invoke-Command -Session $session -ScriptBlock{C:\PerformanceInformation\mem_info.exe memory.raw}
        $outcome.Add("MemDumpOperation", (Get-Date).ToString())
    }else{
        $outcome.Add("MemDumpOperation", "NotEnoughDiskSpace")
    }
        
    Write-Output $outcome
}
