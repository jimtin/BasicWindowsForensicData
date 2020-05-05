function Get-RemoteEventLogs{
    <#
    .SYNOPSIS
    Gets the remote event logs from the endpoint. Renames it to the hostname of endpoint. 

    .DESCRIPTION
    Gets the remote event logs from the endpoint. Renames it to the hostname of the endpoint. 
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$session,
        [Parameter(Mandatory=$true)]$HostName
    )

    # Setup the outcome variable
    $outcome = @{}
    # Get timestamp of the command being run
    $outcome.Add("GetRemoteEventLogsTimestamp", (Get-Date).ToString())
    # Set up the destination string
    $location = (Get-Location).ToString()
    $destination = $location + "\" + $HostName + "_EventLogs"
    # Copy the event logs using the powershell session
    $geteventlogs = Copy-Item -FromSession $session -LiteralPath C:\Windows\System32\winevt\Logs -Destination $destination
    $outcome.Add("GetEventLogsCommand", $geteventlogs)
    Write-Output $outcome
}