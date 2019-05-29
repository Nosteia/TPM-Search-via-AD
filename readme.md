# TPM Finder

This PowerShell script will scan all devices in an OU, and break them down into four categories.  
Inactive: This means the script was not able to find an active TPM.  
Skipped: The machine is not reachable or not responding to ping requests.  
OldTPM: The machine is running TPMv 1.2  
NewTPM: The machine is running TPMv 2.0  
