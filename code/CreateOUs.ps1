# Riot.core User OUs:
New-ADOrganizationalUnit 'AllUsers' -Description 'Contains OUs for users'
# Under Allusers:
New-ADOrganizationalUnit 'IT' -Description 'IT Department' -Path 'OU=AllUsers,DC=riot,DC=core'
New-ADOrganizationalUnit 'GameDev' -Description 'Game development' -Path 'OU=AllUsers,DC=riot,DC=core'  
New-ADOrganizationalUnit 'HR' -Description 'Human resources' -Path 'OU=AllUsers,DC=riot,DC=core'
New-ADOrganizationalUnit 'Marketing' -Description 'Marketing' -Path 'OU=AllUsers,DC=riot,DC=core'
New-ADOrganizationalUnit 'Adm' -Description 'Administration' -Path 'OU=AllUsers,DC=riot,DC=core'
# Under Game development, AllUsers:
New-ADOrganizationalUnit 'Prog' -Description 'Programming' -Path 'OU=GameDev,OU=AllUsers,DC=riot,DC=core'  
New-ADOrganizationalUnit 'Animators' -Description 'Animation and art design' -Path 'OU=GameDev,OU=AllUsers,DC=riot,DC=core'  
# Under Marketing, AllUsers:
New-ADOrganizationalUnit 'Advertising' -Description 'Advertisement and market resreach' -Path 'OU=Marketing,OU=AllUsers,DC=riot,DC=core'
New-ADOrganizationalUnit 'PR' -Description 'Public relations' -Path 'OU=Marketing,OU=AllUsers,DC=riot,DC=core'

# Riot.core Computer OUs:
New-ADOrganizationalUnit 'Clients' -Description 'Contains OUs for company computers'
New-ADOrganizationalUnit 'Servers' -Description 'Contains OUs for company servers'

# Under Clients: 
New-ADOrganizationalUnit 'Adm' -Description 'Administration computers' -Path 'OU=Clients,DC=riot,DC=core'
New-ADOrganizationalUnit 'IT' -Description 'IT computers' -Path 'OU=Clients,DC=riot,DC=core'
New-ADOrganizationalUnit 'GameDev' -Description 'Game development computers' -Path 'OU=Clients,DC=riot,DC=core'
New-ADOrganizationalUnit 'Marketing' -Description 'Marketing computers' -Path 'OU=Clients,DC=riot,DC=core'

# Under Game devlopment, clients: 
New-ADOrganizationalUnit 'Prog' -Description 'Programming computers' -Path 'OU=GameDev,OU=Clients,DC=riot,DC=core'
New-ADOrganizationalUnit 'Animators' -Description 'Animators computers' -Path 'OU=GameDev,OU=Clients,DC=riot,DC=core'