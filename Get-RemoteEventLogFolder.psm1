function Get-RemoteEventLogFolder{
    <#
    .SYNOPSIS
    Gets the remote event logs from the endpoint. Renames it to the hostname of endpoint. 

    .DESCRIPTION
    Gets the remote event logs from the endpoint. Renames it to the hostname of the endpoint. 
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$session,
        [Parameter(Mandatory=$true)]$TargetHostName,
        [Parameter(Mandatory=$true)]$Location
    )

    # Setup the outcome variable
    $outcome = @{}
    # Get timestamp of the command being run
    $outcome.Add("GetRemoteEventLogsTimestamp", (Get-Date).ToString())
    # Set up the destination string
    $destination = $Location + "\" + $TargetHostName + "_EventLogs"
    # Copy the event logs using the powershell session
    $geteventlogs = Copy-Item -FromSession $session -LiteralPath C:\PerformanceInformation\Logs -Destination $destination -Recurse
    $outcome.Add("GetEventLogsCommand", $geteventlogs)
    $destination = $location + "\" + $TargetHostName + "_sru"
    $getsrulogs = Copy-Item -FromSession $session -LiteralPath C:\PerformanceInformation\sru -Destination $destination -Recurse
    $outcome.Add("GetSRULogs", $getsrulogs)
    Write-Output $outcome
}