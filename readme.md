# Basic Windows Forensic Artefacts Gathering #

## Overview ##

Series of Powershell modules which enable a user to gather forensic data from remote machines and extract to a local machine.
Current forensic artefacts gathered:

1. Volatile Memory
2. All Event Logs
3. System Resource Usage Folder

## Process Overview ##

1. Using the `loadbasicforensicdata.ps1` script, a series of Powershell commandlets (cmdlet) are loaded into the current Powershell memory space.
2. Gathering memory. The program pushes the WinPMEM driver (1.6.2) across to the remote target, then dumps it into a .raw format.
3. Creates a folder on remote endpoint. All forensic artefacts are staged to this folder for extraction.
4. All files/folders including memory are extracted using the open powershell session.
5. All files/folders extracted are renamed to the target machines name. I.e. memory.raw is renamed to LABCOMPUTER.raw.
6. At the end of the process, the memory image, and copied folders and created folders are all deleted, leaving a net zero impact on target machine.
7. All commands are timestamped from the endpoint running the machine.

## Advantages ##

Using this program has several advantages, outlined below:

1. Automates gathering sufficient information for most Incident Response teams to perform triage level analysis in a forensically sound manner
2. Able to be used remotely. In a COVID19 world, the need for IR teams to dynamically gather forensic data to triage suspected machines is increasing. This script enables the basics to be gathered.
3. All commands are timestamped. This allows IR teams to deconflict their own actions with potential adversary actions.
4. Leverages the powerful native capabilities of Powershell. I.e. performing this action on multiple machines simultaneously is as simple as providing the `Invoke-GetBasicForensicData` cmdlet with a list of targets. Powershell will take care of the rest.
5. Uses the authentication mechanisms inherent to your environment. With the power of powershell only increasing, becoming cross platform and used extensively in automated build orchestration, if remote powershell is enabled in your environment, this script will work.
6. Open source so that you can inspect the code and make sure nothing nefarious is going on.

## Considerations ##

### Powershell ###

Many IR teams will have an instinctively negative reaction to any use of Powershell, (especially remote Powershell!), in their environment. There is good reason for this, not least the excellent work done by contributors to the Powershell Empire team <https://www.powershellempire.com/>
While each IR team and SecOps leadership team needs to make their own assessments on the risk/reward profile for Powershell usage in their environment, I submit the following considerations before insticitively discarding this project:

1. Powershell is simply a wrapper for the .NET framework. This entire project could easily be re-written in C# and simply call the various .NET API calls required to achieve the same outcome. In the process, you would disable many of the excellent logging, tracking and JIT assessments Microsoft has painstakingly built into Powershell of late.
2. With recent updates to Powershell, the protocol used to achieve expansion can now be changed. If WinRM is no longer desired, it is possible to use SSH to achieve the same outcomes. I haven't yet built that functionality into this project, but it is possible.
3. Powershell is becoming the default way to manage Windows based endpoints, including nano-servers. As such, it is likely that Microsoft continues to release new products, this trend will continue. Note: I do not have inside information or anything on this, just observing trends. As an Incident Responder, I feel more comfortable understanding this risk and planning for it.

### Usage Considerations ###

To keep things simple, I have made extensive use of Powershell Sessions. Further, I have chosen to use WinRM as this is most common when remote powershell is being used. Therefore, consider the following:

1. WinRM is quite a 'slow' protocol. This will increase the time it takes to transfer files, especially the memory files. I did initially consider creating an SMB Share using either the Win32 API (for powershell versions 2, 3, 4) or SMB cmdlets for Powershell 5, however this increases the artefacts the script leaves behind. On the plus side, using Powershell sessions means Powershell will manage transfer across multiple machines.
2. The script checks the endpoints disk vs memory space to make sure there is enough space to dump memory, but does not do so on the endpoint it is being run from. Make sure you have plenty of disk space :)

### Endpoint agents ###

This project is not meant to replace or imply that an endpoint agent is not required. It simply provides a mechanism for IR teams to get some basic Windows artefacts quickly. I'm always open to feedback on this, so feel free to post your thoughts.

## How to use ##

### Requirements ###

What you will need to run this:

1. Powershell 5.1 (note Powershell 6, 7 not yet supported)
2. Plenty of disk space
3. Remote Powershell enabled (`Enable-PSRemoting`)

### Install ###

What needs to be downloaded / installed:

1. Download the git repo to the folder you want to run the script from. Note that this will be the folder where all remote artefacts will be extracted to, so make sure you have disk space.
2. Check the WinPMEM binary. The link I got this binary from is: <https://github.com/google/rekall/releases?after=v1.3.2>
3. Open Powershell as administrator
4. Run `.\loadbasicforensicsdata.ps1`
5. You will see a series of messages written to the prompt, for instance: `Importing cmdlet: .\Get-CurrentHostDetails.psm1`

### Now use ###

Steps to run after install:

1. Set up your target(s) variable. For instance `$target = "127.0.0.1"`

a. If you are using Kerberos, you will need to use a hostname
b. If you wish to undertake this action on multiple machines, you can make this a list: `$target = [ComputerOne, ComputerTwo]`

2. Set up your credentials. This is your call, but if you wish to use this on multiple machines, I recommend you use the secure string created by the `Get-Credential` cmdlet (details here: <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7).> For instance: `$cred = Get-Credential`
3. Assuming you have set up your remote powershell usage (including updating the registry key with the machines allowed), run the following command: `Invoke-GetBasicForensicData -Target $target -Credential $cred`
4. You will see a series of messages written to the screen notifying you of progress. If using against multiple endpoints, there will be a lot!

### Output ###

Assuming the target endpoint was called LABCOMPUTER, the following would be output:

1. Memory image. This will be `<endpoint>.raw`. I.e. `LABCOMPUTER.raw`
2. EventLogs. Folder titled `<endpoint>_EventLogs`. I.e. `LABCOMPUTER_EventLogs`
3. SRU Folder. Folder titled `<endpoint>_sru`. I.e. `LABCOMPUTER_sru`
4. Timestamps of the commands run. File titled `<endpoint>_CommandHistory.json`. I.e. `LABCOMPUTER_CommandHistory.json`

If multiple endpoints called, there will one of each of the above for each endpoint.
