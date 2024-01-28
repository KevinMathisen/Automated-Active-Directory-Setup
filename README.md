# DCSG1005 Project - Automated Active Directory Setup

This repository contains PowerShell scripts for setting up Active Directory. It is designed for creating an example organization named Riot. The scripts automate the creation of organizational units, user accounts, computer accounts, group memberships, and the application of group policies.
The setup follows best practices for setting up AD, including the AGDLP principle, least privilege, separation of duties, and using Microsoft Security Baseline.

## Setup
Before running the script you need to ensure
- You have to have 4 windows computers/server on a network, with the names `DC1`, `SRV1`, `CL1`, and `MGR`.
- Active directory needs to be installed on `DC1`.
- Join the 3 other computers to their default containers using the following commands:
```powershell
Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses IP-ADRESS-DC1
$cred = Get-Credential -UserName 'SEC\Administrator' -Message 'Cred'
Add-Computer -Credential $cred -DomainName sec.core -PassThru -Verbose
Restart-Computer
  ```

## Running the scripts
Run the scripts in the following order
1.  `CreateOUs.ps1` - Establishes the basic structure for users and computers.
2.  `JoinComputers.ps1` - Ensures that computers are correctly organized within the Active Directory.
3.  `CreateUsers.ps1` - Populates the AD with users in the respective departments.
4.  `CreateGlobalGroups.ps1` - Sets up groups for permission management.
5.  `GroupPolicy.ps1` - Applies security policies and configurations.

## License

This project is licensed under the [MIT License](LICENSE). See the `LICENSE` file for more details.