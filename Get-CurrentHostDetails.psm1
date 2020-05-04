function Get-CurrentHostDetails 
{
    <#
    .SYNOPSIS
        Gets information about the host it is being launched from

    .DESCRIPTION
        The Get-CurrentHostDetails cmdlet gets information from the current host. This is used for any future interactions with remote data sets.

    
    #>
    [CmdletBinding()]
    param ()

    $output = @{}

    # Get the HostName of our current endpoint
    $hostname = $env:COMPUTERNAME
    $output.Add("HostName", $hostname)
    $powershellversion = $PSVersionTable.PSVersion
    $output.Add("PSVersion", $powershellversion)

    # Test if Powershell remoting is available. Note for this instance, error action is set to silently continue as failure will mean that Powershell remoting is not set.
    $psremoting = Test-WSMan -ComputerName $hostname -ErrorAction SilentlyContinue
    # Error handling for PsRemoting
    if ($remoting -eq $null){
        Write-Information -InformationAction Continue -MessageData "PS Remoting does not appear enabled"
        $psremoting = "Nope"
    } 
    else {
        $psremoting = $psremoting
    }
    $output.Add("PSRemoting", $psremoting)    
    $timezone = Get-TimeZone
    $output.Add("TimeZone", $timezone)
    
    # Output the results
    Write-Output $output
}