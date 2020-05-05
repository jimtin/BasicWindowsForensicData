function Invoke-GetBasicForensicData{
    <#
    .SYNOPSIS
        Overarching function to retrieve forensic data from a remote Windows host in a forensically sound manner

    .DESCRIPTION
        Gets the following forensic data from a remote windows machine
        1. Memory dump
        2. Copy of event logs folder
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$Target, 
        [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$Credential 
    )

    # Set a variable to store the commands, their timestamp. This allows for forensic reporting to occur
    $foresnicdatarecord = @{
        "Target" = $Target
        "TimeZoneofGatheringMachine" = (Get-TimeZone).DisplayName
    }

    # Set up the output dictionary
    $outcome = @{}

    # Set up a PSRemoting session to the endpoint. This could also have used a straight Invoke-Command object, but this method reduces noise on the network
    Write-Information -InformationAction Continue -MessageData "Setting up Remote Session"
    $remotesession = New-PSSession -ComputerName $Target -Credential $Credential
    # Check remote session has been created
    if ($remotesession -ne $null){
        $foresnicdatarecord.Add("SetupRemoteSession", (Get-Date).ToString())
        # Get information about remote endpoint
        $targetinfo = Get-TargetInformation -Session $remotesession
        $outcome.Add("GetTargetInformationTimestamp", (Get-Date).ToString())
        # Test the endpoint to see if the Performance Information folder exists
        $pathexists = Invoke-Command -Session $remotesession -ScriptBlock{Test-Path -Path "C:\PerformanceInformation"}
        $outcome.Add("TestedEndpointTimestamp", (Get-Date).ToString())
        if ($pathexists -eq $false){
            # Create the folder on the endpoint to place WinPMEM
            Invoke-Command -Session $remotesession -ScriptBlock{New-Item -Path "C:\" -Name "PerformanceInformation" -ItemType "directory"}
            $outcome.Add("CreatedPerformanceInformationFolderTimestamp", (Get-Date).ToString())
        }else{
            Write-Information -InformationAction Continue -MessageData "Endpoint path exists, continuing"
        }
        
        # Transfer WinPMEM. Folder location is C:\PerformanceInformation\mem_info.exe
        Write-Information -InformationAction Continue -MessageData "Transferring WinPmem"
        $winpmemmove = Move-WinPMEM -Session $remotesession
        $outcome.Add("WinPMEMMove", $winpmemmove)

        # Get the targets name and dump a copy of raw memory
        $memdumpoutcome = Invoke-MemoryDump -Session $remotesession
        $outcome.Add("MemoryDumpOutcome", $memdumpoutcome)

        # Copy the Memory Dump to this computer, renaming to the hostname to enable easy tracking
        Write-Information -InformationAction Continue -MessageData "Copying remote memory file. Note, file will be renamed to <endpoint>.raw"
        $GetMemDumpOutcome = Get-MemoryDump -Session $remotesession -TargetHostName $targetinfo.HostName
        $outcome.Add("GetMemoryDumpOutcome", $GetMemDumpOutcome)

        # Copy the event logs from remote endpoint into the PerformanceInformation folder
        $copyeventlogsoutcome = Copy-RemoteEventLogs -Session $remotesession
        $outcome.Add("CopyEventLogsOutcome", $copyeventlogsoutcome)
        # Get the event logs back from remote endpoint, renaming folder to the endpoints name
        $getremoteeventlogsoutcome = Get-RemoteEventLogFolder -Session $remotesession -TargetHostName $targetinfo.HostName
        $outcome.Add("GetRemoteEventLogsOutcome", $getremoteeventlogsoutcome)

        # Delete Artefacts
        Write-Information -InformationAction Continue -MessageData "Deleting Artefacts"
        $artefactclean = Invoke-ArtefactCleanup -Session $remotesession
        $outcome.Add("ArtefactClean", $artefactclean)
    }else{
        Write-Information -InformationAction Continue -MessageData "Remote session not created"
        $foresnicdatarecord.Add("SetupRemoteSession", "Failed")
    }

    # Turn into JSON
    $outcomejson = $outcome | ConvertTo-Json
    # Store in a file
    $location = (Get-Location).tostring()
    $filelocation = $location "\" + $targetinfo.HostName + "_CommandHistory.json"
    $outcomejson | Out-File $filelocation
    
    Write-Output $outcome    
}