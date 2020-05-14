function Compress-ForensicData{
    <#
    .SYNOPSIS
        Compresses the forensic data folder into a zip using native powershell commands

    .DESCRIPTION
        Compresses forensic data into a zip using native powershell commands
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$ForensicDataLocation,
        [Parameter(Mandatory=$true)]$EndpointName
    )

    # Setup the outcome variable
    $outcome = @{
        "ForensicDataLocation" = $ForensicDataLocation
    }

    # Test if ForensicData exists at this location
    $folderexists = Test-Path -Path $ForensicDataLocation
    $outcome.Add("PathExists", $folderexists)

    # If path exists, compress. Compress-Archive will not work in this instance as file size is too large.
    if($folderexists -eq $true){
        $storagelocation = $ForensicDataLocation + "_Compressed"
        Add-Type -Assembly System.IO.Compression.FileSystem
        $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
        [System.IO.Compression.ZipFile]::CreateFromDirectory($ForensicDataLocation, $storagelocation, $compressionLevel, $false)
        Write-Progress -Activity "Compressing Artifacts. Ths will take a while" -Status "Compressing"
    }

}