$OU = "ENTER AD OU HERE"
$computers = Get-ADComputer -Filter * -SearchBase $OU | Select-Object Name | Foreach {$_.Name}
$fileDump = "C:\scripts\Dump"

foreach ($computer in $computers)
    {
    $PingResult = Test-Connection -ComputerName $computer -Count 1 -Quiet
		    If($PingResult)
		    {
                $tpmStatus = Get-WmiObject -Class Win32_TPM -Namespace "root\CIMV2\Security\MicrosoftTpm" -ComputerName $computer

                    If($tpmStatus.IsActivated_InitialValue -eq $True)
					{
                        If($tpmStatus.SpecVersion.StartsWith("1.2")) 
						{
                        Write-Host "$computer is 1.2"
                        Out-File -append -FilePath $fileDump\oldtpm.txt -InputObject $computer,$tpmStatus.SpecVersion,`r
                        }
                        Else
                        {
                        Write-Host "$computer is 2.0"
                        Out-File -append -FilePath $fileDump\newtpm.txt -InputObject $computer,$tpmStatus.SpecVersion,`r
                        }
                        $tpmStatus = $null
                    }
                    Else
                    {
                       Write-Host "TPM isn't activated on $computer  Skipping..."
                       Out-File -append -FilePath $fileDump\inactive.txt -InputObject $computer
                    }
            }
            Else
            {
                Write-Host "$computer isn't responding. Skipping..."
                Out-File -append -FilePath $fileDump\skipped.txt -InputObject $computer
            }
    }