function Get-TargetInformation{
    <#
        .SYNOPSIS
        Gets basic information about the target endpoint. This can be used later to specify which version of powershell to use.

        .DESCRIPTION
        Gets basic information about the target endpoint. 
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$Session
    )

    $targetinfo = Invoke-Command -Session $Session -ScriptBlock{
        # Set up the outcome dictionary 
        $outcome = @{}
        # Get a timestamp of the command being run
        $outcome.Add("HostInfoCommandTime", (Get-Date).ToString())
        # Get information about the powershell version
        $psh = $PSVersionTable
        $outcome.Add("PowershellInfo", $psh)
        # Get information about the OS Version
        $outcome.Add("OSVersionInfo", [System.Environment]::OSVersion)
        # Get the hostname
        $outcome.Add("HostName", $env:COMPUTERNAME)
        Write-Output $outcome
    }
    Write-Output $targetinfo
}