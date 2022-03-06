# This script follows the AGDLP Principle. It first creates global groups under OU's, adds members, and then adds the global group to domain local groups.

# Create Global groups representing each OU with users:
# Department Distingushed names:
$DepartmentDNs = @{
	IT 			= 'OU=IT,OU=AllUsers,DC=riot,DC=core'
	Prog 		= 'OU=Prog,OU=GameDev,OU=AllUsers,DC=riot,DC=core'
	Animators 	= 'OU=Animators,OU=GameDev,OU=AllUsers,DC=riot,DC=core'
	HR 			= 'OU=HR,OU=AllUsers,DC=riot,DC=core'
	Advertising = 'OU=Advertising,OU=Marketing,OU=AllUsers,DC=riot,DC=core'
	PR 			= 'OU=PR,OU=Marketing,OU=AllUsers,DC=riot,DC=core'
	Adm 		= 'OU=Adm,OU=AllUsers,DC=riot,DC=core'
}

# For each department:
foreach ($DepartmentDN in $DepartmentDNs.Values) {
	$DepartmentName = ($DepartmentDN -split "[,=]")[1]

	$NewGroupArg = @{
		Name			= 'g_My ' + $DepartmentName + ' users'
		GroupCategory 	= 'Security'
		GroupScope 		= 'Global'
		DisplayName		= $DepartmentName + ' Global Group'
		Path			= $DepartmentDN
		Description		= 'Users in the ' + $DepartmentName + ' department'
	}

	# Get members from department:
	$DepartmentMembers = Get-ADUser -Filter { department -eq $DepartmentName }

	# Creates a global group and adds members for department:
	New-AdGroup @NewGroupArg -PassThru | Add-AdGroupMember -Members $DepartmentMembers
}



# Make any users in Prog Global Group Remote Desktop Users on CL1:
Invoke-Command -ComputerName CL1 {Add-LocalGroupMember -Group 'Remote Desktop Users' -Member 'RIOT.CORE\g_My Prog users'}

# Make any users in Advertising Global Group Remote Desktop Users on MGR:
Invoke-Command -ComputerName MGR {Add-LocalGroupMember -Group 'Remote Desktop Users' -Member 'RIOT.CORE\g_My Advertising users'}

# Make any user in IT Global Group Event Log Readers and Remote Desktop Users:
Add-ADPrincipalGroupMembership -Identity 'g_My IT users' -MemberOf 'Event Log Readers'
Add-ADPrincipalGroupMembership -Identity 'g_My IT users' -MemberOf 'Remote Desktop Users'


# Array of IT members:
$ITMembers = Get-ADUser -Filter { Department -eq 'IT' }
# Domain Local Groups we want to add IT members to:
$DomainLocalGroupsIT = @('Administrators', 'Account Operators', 'Backup Operators', 'Network Configuration Operators')

# For each Domain Local Group:
foreach ($i in 0..($DomainLocalGroupsIT.Length-1)) {

	$NewGroupArg = @{
		Name			= 'g_My ' + $DomainLocalGroupsIT[$i]
		GroupCategory	= 'Security'
		GroupScope		= 'Global'
		DisplayName		= $DomainLocalGroupsIT[$i] + ' Users Global Group'
		Path			= $DepartmentDNs.IT
		Description		= 'Users with ' + $DomainLocalGroupsIT[$i] + ' priviliges'
	}

	# Creates a new group and adds one member from IT (We want one account for each domain local group):
	New-AdGroup @NewGroupArg -PassThru | Add-AdGroupMember -Members $ITMembers[$i]

	Add-ADPrincipalGroupMembership -Identity $NewGroupArg.Name -MemberOf $DomainLocalGroupsIT[$i]
}


# Creates group with one IT user and adds it to print operators and server operators:
$NewGroupArg = @{
	Name			= 'g_My Print and Server Operators'
	GroupCategory	= 'Security'
	GroupScope		= 'Global'
	DisplayName		= 'Print Operators and Server Operators Users Global Group'
	Path			= $DepartmentDNs.IT
	Description		= 'Users with Print Operators and Server Operator priviliges'
}

New-AdGroup @NewGroupArg -PassThru | Add-AdGroupMember -Members $ITMembers[4]
Add-ADPrincipalGroupMembership -Identity 'g_My Print and Server Operators' -MemberOf 'Print Operators','Server Operators'

