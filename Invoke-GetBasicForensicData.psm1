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


    # Set up a PSRemoting session to the endpoint. This could also have used a straight Invoke-Command object, but this method reduces noise on the network
    Write-Information -InformationAction Continue -MessageData "Setting up Remote Session"
    $remotesession = New-PSSession -ComputerName $Target -Credential $Credential
    # Check remote session has been created
    if ($remotesession -ne $null){
        $foresnicdatarecord.Add("SetupRemoteSession", (Get-Date).ToString())
        # Test the endpoint to see if the Performance Information folder exists
        $pathexists = Invoke-Command -Session $remotesession -ScriptBlock{Test-Path -Path "C:\PerformanceInformation"}
        if ($pathexists -eq $false){
            # Create the folder on the endpoint to place WinPMEM
            Invoke-Command -Session $remotesession -ScriptBlock{New-Item -Path "C:\" -Name "PerformanceInformation" -ItemType "directory"}
        }else{
            Write-Information -InformationAction Continue -MessageData "Endpoint path exists, continuing"
        }
        
        # Transfer WinPMEM. Folder location is C:\PerformanceInformation\mem_info.exe
        Write-Information -InformationAction Continue -MessageData "Transferring WinPmem"
        Move-WinPMEM -Session $remotesession
        # Get the targets name and dump a copy of raw memory
        Invoke-MemoryDump -Session $remotesession

        # Create an SMBShare to retrieve memory dump
        New-RemoteSMBShare -Session $remotesession -Target $Target

        # Delete Artefacts
        Write-Information -InformationAction Continue -MessageData "Deleting Artefacts"
        #Invoke-ArtefactCleanup -Session $remotesession
    }else{
        Write-Information -InformationAction Continue -MessageData "Remote session not created"
        $foresnicdatarecord.Add("SetupRemoteSession", "Failed")
    }
    

    
    
}