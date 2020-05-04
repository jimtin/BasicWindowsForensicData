#Requires -Version 5.1
#Requires -RunAsAdministrator

# Import modules
Write-Information -InformationAction Continue -MessageData "Importing Get-CurrentHostDetails"
Import-Module -Name .\Get-CurrentHostDetails.psm1 -Force
Write-Information -InformationAction Continue -MessageData "Importing Invoke-GetBasicForensicData"
Import-Module -Name .\Invoke-GetBasicForensicData.psm1 -Force
Write-Information -InformationAction Continue -MessageData "Importing Move-WinPMEM"
Import-Module -Name .\Move-WinPmem.psm1 -Force
Write-Information -InformationAction Continue -MessageData "Importing Invoke-MemoryDump"
Import-Module -Name .\Invoke-MemoryDump.psm1 -Force
Write-Information -InformationAction Continue -MessageData "Importing Invoke-ArtefactCleanup"
Import-Module -Name .\Invoke-ArtefactCleanup.psm1 -Force
Write-Information -InformationAction Continue -MessageData "Importing New-RemoteSMBShare"
Import-Module -Name .\New-RemoteSMBShare.psm1 -Force
