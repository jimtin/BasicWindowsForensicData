#Requires -Version 5.1
#Requires -RunAsAdministrator

# Get a list of modules from the modules file 
$modules = Get-Content -Path .\modules.txt

foreach ($cmdlet in $modules){
    $messagestring = "Importing cmdlet: " + $cmdlet
    Write-Information -InformationAction Continue -MessageData $messagestring
    # Import the module
    Import-Module -Name $cmdlet -Force
}


