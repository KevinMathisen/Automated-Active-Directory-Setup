# SRV1, CL1 and MGR are joined to domain in default container CN=computers.
# Move the computers to their correct OUs:
Get-ADComputer "SRV1" | Move-ADObject -TargetPath "OU=Servers,DC=riot,DC=core"
Get-ADComputer "CL1" | Move-ADObject -TargetPath "OU=Prog,OU=GameDev,OU=Clients,DC=riot,DC=core"
Get-ADComputer "MGR" | Move-ADObject -TargetPath "OU=Marketing,OU=Clients,DC=riot,DC=core"