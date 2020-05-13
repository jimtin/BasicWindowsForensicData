function New-ForensicDataStore{
    <#
    .SYNOPSIS
    Creates a new forensic data store based upon user input 

    .DESCRIPTION
    Creates a new forensic data store based upon user input
    
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]$ArtifactLocation
    )

    # Set up the output variable
    $output = @{
        "Outcome" = "Failed"
    }

    # If user has stated where they would like these artifacts to go, create a folder here
    # Append the name 'WindowsForensicData' to name
    $ArtifactLocationFull = $ArtifactLocation + "\WindowsForensicData"
    $output.Add("ArtifactLocation", $ArtifactLocationFull)
    # Check if folder already exists
    $artefactstore = Get-Item -Path $ArtifactLocationFull
    if ($artefactstore -eq $true){
        # If yes, notify the user
        $message = "Artefact storage location exists: " + $ArtifactLocationFull
        Write-Information -InformationAction Continue -MessageData $message
        $output.Outcome = "AlreadyCreated"
    }else{
        # If no, create
        $message = "Creating artefact storage location at: " + $ArtifactLocation
        Write-Information -InformationAction Continue -MessageData $message
        $createdfolder = New-Item -Path $ArtifactLocation -Name "WindowsForensicData" -ItemType Directory
        $output.Outcome = "Created"
        $output.Add("CreatedFolder", $createdfolder)
    }

    # Return outcome from function
    Write-Output $output
}