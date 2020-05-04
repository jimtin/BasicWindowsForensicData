function Invoke-ArtefactCleanup{    
    <#
    .SYNOPSIS
    Cleans up the artefacts created by this script

    .DESCRIPTION
    Cleans the following artefacts from remote endpoints
    1. PerformanceInformation log
    2. WinPMEM 

    #>

    [CmdletBinding()]
    param (
        $Session
    )

    # First test the folder exists
    $pathexists = Invoke-Command -Session $Session -ScriptBlock{Test-Path -Path "C:\PerformanceInformation"}
    # Clean up the folder
    if ($pathexists -eq $true){
        Invoke-Command -Session $Session -ScriptBlock{Remove-Item -Path "C:\PerformanceInformation" -Recurse -Force}
    }

    # Remove the session
    Remove-PSSession -Session $Session

}