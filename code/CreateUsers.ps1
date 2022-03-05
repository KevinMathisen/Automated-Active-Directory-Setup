# 50 Unique norwegien given names:
# From https://gitlab.com/erikhje/heat-mono/-/blob/master/scripts/CreateUserCSV.ps1
$NorwegianGN = @('Nora', 'Emma', 'Ella', 'Maja', 'Olivia', 'Emilie',
'Sofie', 'Leah', 'Sofia', 'Ingrid', 'Frida', 'Sara',
'Tiril', 'Selma', 'Ada', 'Hedda', 'Amalie', 'Anna',
'Alma', 'Eva', 'Mia', 'Thea', 'Live', 'Ida',
'Astrid', 'Ellinor', 'Vilde', 'Linnea', 'Iben', 'Aurora',
'Mathilde', 'Jenny', 'Tuva', 'Julie', 'Oda', 'Sigrid',
'Amanda', 'Lilly', 'Hedvig', 'Victoria', 'Amelia', 'Josefine',
'Agnes', 'Solveig', 'Saga', 'Marie', 'Eline', 'Oline',
'Maria', 'Hege')

# 50 Unique norwegian surnames:
# From https://gitlab.com/erikhje/heat-mono/-/blob/master/scripts/CreateUserCSV.ps1
$NorwegianSN = @('Hansen', 'Johansen', 'Olsen', 'Larsen', 'Andersen', 'Pedersen',
'Nilsen', 'Kristiansen', 'Jensen', 'Karlsen', 'Johnsen', 'Pettersen',
'Eriksen', 'Berg', 'Haugen', 'Hagen', 'Johannessen', 'Andreassen',
'Jacobsen', 'Dahl', 'Jørgensen', 'Henriksen', 'Lund', 'Halvorsen',
'Sørensen', 'Jakobsen', 'Moen', 'Gundersen', 'Iversen', 'Strand',
'Solberg', 'Svendsen', 'Eide', 'Knutsen', 'Martinsen', 'Paulsen',
'Bakken', 'Kristoffersen', 'Mathisen', 'Lie', 'Amundsen', 'Nguyen',
'Rasmussen', 'Ali', 'Lunde', 'Solheim', 'Berge', 'Moe',
'Nygård', 'Bakke')

# 50 Unique indian given names:
# From https://gist.githubusercontent.com/mbejda/7f86ca901fe41bc14a63/raw/38adb475c14a3f44df9999c1541f3a72f472b30d/Indian-Male-Names.csv
$IndianGN = @('barjraj', 'ramdin', 'sharat', 'birender', 'amit', 'kushal',
'kasid', 'shiv', 'vikram', 'sanjay', 'abhi', 'ram',
'khadak', 'gurmit', 'chanderpal', 'aman', 'khursid', 'rajeev',
'durgesh', 'nahar', 'ram', 'sunder', 'maansingh', 'rohit',
'rohit', 'sparsh', 'santosh', 'santosh', 'punit', 'dinesh',
'gulshan', 'arvind', 'nausad', 'gurmit', 'afsar', 'shiv',
'moti', 'kausal', 'rohit', 'rohit', 'mohabbat', 'raj',
'jaswant', 'sevak', 'chotelal', 'amit', 'rupesh', 'midda',
'dharam', 'manoj')

# 50 Unique indian surnames:
# From https://surnam.es/india
$IndianSN = @('Devi', 'Singh', 'Kumar', 'Das', 'Kaur', 'Ram',
'Yadav', 'Kumari', 'Lal', 'Bai', 'Khatun', 'Mandal',
'Ali', 'Sharma', 'Ray', 'Mondal', 'Khan', 'Sah',
'Patel', 'Prasad', 'Patil', 'Ghosh', 'Pal', 'Sahu',
'Gupta', 'Shaikh', 'Bibi', 'Sekh', 'Begam', 'Biswas',
'Sarkar', 'Paramar', 'Khatoon', 'Mahto', 'Ansari', 'Nayak',
'Ma', 'Rathod', 'Jadhav', 'Mahato', 'Rani', 'Barman',
'Behera', 'Mishra', 'Chand', 'Roy', 'Begum', 'Saha',
'Paswan', 'Thakur')

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
# Department numbers for creating employee numbers:
$DepartmentNums = @{
	IT 			= '0001'
	Prog 		= '0101'
	Animators 	= '0102'
	HR 			= '0003'
	Advertising	= '0201'
	PR 			= '0202'
	Adm 		= '0005'
}
# Because Names for users have to be unique, keep track of used names:
$Global:NamesUsed = @()


# Function for creating new active directory users for a specified department. Inspired from https://gitlab.com/erikhje/heat-mono/-/blob/master/scripts/CreateUserCSV.ps1.
function New-ADUsersDepartment {
	# The function takes the amount of users to create, which department they belong to, and two lists of givennames and surnames to choose from, as paramters:
	param([int]$Amount, [string]$DepartmentDN, [int]$DepartmentNum, [string[]]$GivenNames, [string[]]$Surnames)

	# For each user to create:
	foreach ($i in 1..$Amount) {

		# Creates a random password until it is valid (contains a number):
		Do {
			$Password 	= -join ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPRSTUVWXYZ0123456789!"#$%&()*+,-./:<=>?@[\]_{|}'.ToCharArray() | Get-Random -Count 15)
		} Until ($Password -match '\d')

		# Chooses a name until is is valid (not already used):
		# Inspired from https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-pick-a-random-name-from-a-list/
		Do {
			$GivenName = Get-Random -InputObject $GivenNames
		} Until ($Global:NamesUsed -notcontains $GivenName)
		# Stores the names we have used:
		$Global:NamesUsed = $Global:NamesUsed += $GivenName

		# Creates other parameters for New-ADUser:
		$SurName	 		= Get-Random -InputObject $Surnames
		$DisplayName 		= $GivenName + ' ' + $SurName
		$Initials			= $GivenName[0] + $SurName[0]
		$SamAccountName		= $GivenName.ToLower()
		$UserPrincipalName 	= $SamAccountName + '@sec.core'
		$Department 		= ($DepartmentDN -split "[,=]")[1]
		$Path				= $DepartmentDN
		# From https://stackoverflow.com/questions/51912486/format-variable-as-4-digits-with-leading-zeroes:
		$EmployeeNumber		= $DepartmentNum + ('{0:d4}' -f $i)
		$PasswordSS 		= ConvertTo-SecureString $Password -AsPlainText -Force

		# Creates a splatting variable:
		$NewUserArg = @{
			GivenName 				= $GivenName
			SurName 				= $Surname
			Name 					= $DisplayName
			DisplayName 			= $DisplayName
			Initials 				= $Initials
			SamAccountName 			= $SamAccountName
			UserPrincipalName 		= $UserPrincipalName
			Department 				= $Department
			Path					= $Path
			EmployeeNumber 			= $EmployeeNumber
			AccountPassword 		= $PasswordSS
			Enabled 				= $True
			ChangePasswordAtLogon 	= $False
		}

		New-ADUser @NewUserArg

		# Write user information to userPassword document:
		Write-Output '$($NewUserArg.DisplayName);$($NewUserArg.Department);$Password' >> userPasswords.csv
	}
}


# Write header to userPassword document:
Write-Output 'DisplayName;Department;Password' > userPasswords.csv

# Create users for each department with the Create-Users function:
New-ADUsersDepartment -Amount 10 -DepartmentDN $DepartmentDNs.Adm -DepartmentNum $DepartmentNums.Adm -GivenNames $NorwegianGN -Surnames $NorwegianSN  
New-ADUsersDepartment -Amount 5 -DepartmentDN $DepartmentDNs.IT -DepartmentNum $DepartmentNums.IT -GivenNames $IndianGN -Surnames $IndianSN 
New-ADUsersDepartment -Amount 2 -DepartmentDN $DepartmentDNs.HR -DepartmentNum $DepartmentNums.HR -GivenNames $NorwegianGN -Surnames $NorwegianSN 
New-ADUsersDepartment -Amount 20 -DepartmentDN $DepartmentDNs.Prog -DepartmentNum $DepartmentNums.Prog -GivenNames $IndianGN -Surnames $IndianSN 
New-ADUsersDepartment -Amount 15 -DepartmentDN $DepartmentDNs.Animators -DepartmentNum $DepartmentNums.Animators -GivenNames $NorwegianGN -Surnames $NorwegianSN 
New-ADUsersDepartment -Amount 10 -DepartmentDN $DepartmentDNs.Advertising -DepartmentNum $DepartmentNums.Advertising -GivenNames $NorwegianGN -Surnames $NorwegianSN 
New-ADUsersDepartment -Amount 5 -DepartmentDN $DepartmentDNs.PR -DepartmentNum $DepartmentNums.PR -GivenNames $NorwegianGN -Surnames $NorwegianSN 