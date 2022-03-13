# This Script will use Microsoft Security Baseline as a starting point for Group Policy
# It will also create our own Group Policy object for Administration


# Install 7zip for unpacking zip files (As recommended by Erik):
choco install -y 7zip

# Install Windows 10 Security baseline:
Invoke-WebRequest -URI 'https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/Windows%2010%20version%2021H2%20Security%20Baseline.zip' -OutFile C:\Users\Administrator\Windows%2010%20version%2021H2%20Security%20Baseline.zip
# Install Windows Server 2022 Security baseline:
Invoke-WebRequest -URI 'https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/Windows%20Server%202022%20Security%20Baseline.zip' -OutFile C:\Users\Administrator\Windows%20Server%202022%20Security%20Baseline.zip

# Unpack the zip files:
7z x .\Windows%2010%20version%2021H2%20Security%20Baseline.zip
7z x .\Windows%20Server%202022%20Security%20Baseline.zip

# Run the powershell scripts downloaded to get the Group Policies:
Set-Location '.\Windows-10-v21H2-Security-Baseline\Scripts\'
.\Baseline-ADImport.ps1
Set-Location ..
Set-Location ..

Set-Location '.\Windows Server-2022-Security-Baseline-FINAL\Scripts\'
.\Baseline-ADImport.ps1
Set-Location ..
Set-Location ..


# Link Group Policies from Windows 10 Security baseline to Clients:
$OU = 'OU=Clients,DC=riot,DC=core'
$ClientGPOs = @('MSFT Internet Explorer 11 - Computer', 'MSFT Internet Explorer 11 - User',
'MSFT Windows 10 21H2 - BitLocker', 'MSFT Windows 10 21H2 - Computer',
'MSFT Windows 10 21H2 - Credential Guard', 'MSFT Windows 10 21H2 - Defender Antivirus',
'MSFT Windows 10 21H2 - Domain Security', 'MSFT Windows 10 21H2 - User')
foreach ($GPO in $ClientGPOs) { Get-GPO -Name $GPO | New-GPLink -Target $OU }


# Link Group Policies from Windows Server Security baseline to Domain Controller:
$OU = 'OU=Domain Controllers,DC=riot,DC=core'
$DomainControllerGPOs = @('MSFT Internet Explorer 11 - Computer', 'MSFT Internet Explorer 11 - User',
'MSFT Windows Server 2022 - Defender Antivirus', 'MSFT Windows Server 2022 - Domain Controller',
'MSFT Windows Server 2022 - Domain Security')
foreach ($GPO in $DomainControllerGPOs) { Get-GPO -Name $GPO | New-GPLink -Target $OU }


# Link Group Policies from Windows Server Security baseline to Servers:
$OU = 'OU=Servers,DC=riot,DC=core'
$ServerGPOs = @('MSFT Internet Explorer 11 - Computer', 'MSFT Internet Explorer 11 - User',
'MSFT Windows Server 2022 - Defender Antivirus', 'MSFT Windows Server 2022 - Member Server',
'MSFT Windows Server 2022 - Domain Security')
foreach ($GPO in $ServerGPOs) { Get-GPO -Name $GPO | New-GPLink -Target $OU }



# Import Selfmade GPO for Administration:
# As we do not trust the administration with computers this group policy disables access to the control panel and command propt as recommended by https://www.netwrix.com/group_policy_best_practices.html
Import-GPO -BackupGpoName U_AdmRestrictionPolicyBackUp -TargetName U_AdmRestrictionPolicy -CreateIfNeeded -Path C:\Users\Administrator\dcsg-1005-project\code\

Get-GPO -Name "U_AdmRestrictionPolicy" | New-GPLink -Target "OU=Adm,OU=AllUsers,DC=riot,DC=core"

