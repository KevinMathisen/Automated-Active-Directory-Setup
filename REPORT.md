# Project Report

To complete the DCSG1005 Project I had to overcome a lot of challenges and problems. This ranged from simple syntax errors corrected by script analyzer to problems requiring several hours of browsing stack overflow before finding a solution.


## Create OUs

Creating the Organizational Units was quite easy. I did have to modify my organizational chart when I understood that I probably wouldn't need 20 departments, but apart from that, there were no real problems. 


## Join Computers

Probably the easiest script to write, no problems. 


## Create Users

The first script which posed a challenge. From getting names formatted correctly, creating valid passwords, and trying to find a middle ground with script analyzer. 

### Names
As I wanted to have some variation in my user accounts I wanted two sets with names. There are several sources of common names, but I wanted specifically Indian names as they would fit with the IT and Programming department. I found some name sources, one from [Eriks create user script](https://gitlab.com/erikhje/heat-mono/-/blob/master/scripts/CreateUserCSV.ps1) with correct formatting (how convenient) and two not so convenient sources, one from 
[Mbejda on github](https://gist.github.com/mbejda/7f86ca901fe41bc14a63/) and one from [surnam.es](https://surnam.es/india). 

To get the names correctly formatted I wrote a python script that took my clipboard and extracted the names and formatted them so I could put them in my PowerShell script. 

### Passwords 
I didn't know how to create passwords from scratch, so here I took inspiration from [Eriks create user script](https://gitlab.com/erikhje/heat-mono/-/blob/master/scripts/CreateUserCSV.ps1) again in addition to [stack overflow; regex check if string contains digit](https://stackoverflow.com/questions/3180354/regex-check-if-string-contains-at-least-one-digit). I combined these with a do loop which we use in PROG1004 and created PowerShell code for creating a password with a least one digit. 

### Usernames
As active directory requires unique usernames, I had to find a way to generate unique usernames, but also try to use something original and not copy Erik's code once again. 

The solution was a combination of code from [devblogs Microsoft; use PowerShell to pick a random name from a list](https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-pick-a-random-name-from-a-list/) and the use of global variables. Yes, global variables are not optimal, and the solution Erik used in his script was probably better, however, I at least managed to create PowerShell code that picked random names and made sure the name was unique. 

## Scriptanalyzer
Even though I managed to get my script working exactly as I wanted, there was still some unresolved business with script analyzer. Script analyzer had several complaints, which included the use of global variables, using ´ConvertTo-SecureString´ with plaintext, and the lack of *ShouldProcess*. 

I tried to find alternatives to using global variables for choosing usernames like maybe the one Erik used in his [script](https://gitlab.com/erikhje/heat-mono/-/blob/master/scripts/CreateUserCSV.ps1). However I didn't want to copy Erik, and I didn't find any other easily implementable solutions. In addition, the use of global variables shouldn’t be a problem in my script, as it is small and not that complicated. The use of global variables is usually more of a problem in larger programs, where they can lead to some hard-to-find bugs (As they can be changed anywhere, and are hard to test). 

Scriptanalyzers complaining over using ´ConvertTo-SecureString´ with plaintext did also not seem like such a big problem, as this would be more of a problem if the passwords actually were confidential. However, we are creating temporary randomly generated passwords, so this shouldn’t be a problem. 

The script not supporting *ShouldProcess* is a fair critique. It could be nice to ask the user for confirmation when creating new users. However, I tried to implement a solution, but it resulted in having to say yes when creating every single user, which quickly became tiresome when you are creating 60+ accounts. Therefore I decided to not implement it, even though script analyzer wasnt happy.  
 

## Create global groups

This script was not as bad as createUsers, but it still had some challenges.  I had to troubleshoot invoke-command, and figure out how to add global groups to active directory domain local groups. 

### Invoke-command
When creating global groups I wanted to add some global groups to domain local groups on CL1 and MGR. As I wanted to do it in one script I needed to use ´invoke-command´, which shouldn't be a problem in itself. However, when I tried to run the script I would only get errors. 

The solution was using `winrm quickconfig` ([stackoverflow](https://stackoverflow.com/questions/18235513/invoke-command-fails-until-i-run-winrm-quickconfig-on-remote-server)) on MGR and CL1 and enabling firewall exception for WS-Management traffic. 

### Add global groups to active directory groups
As we had only learned how to add groups to local groups from the lectures, I had to search how to add global groups to active directory domain local group (as the command `Add-LocalGroupMember` didn't work). 

The solution was using `Add-ADPrincipalGroupsMembership´ ([Microsoft](https://docs.microsoft.com/en-us/powershell/module/activedirectory/add-adprincipalgroupmembership?view=windowsserver2022-ps)) which let me add global groups to the active directory domain local groups. 


## Group Policy

This script involved a couple of challenges. I had to use Set-Location in the script, download files, and figure out how to export and import group policy objects.

### Downloading files
As I wanted to use pure PowerShell for my scripts, ´curl´ wasn't going to cut it. Instead, I had to use Invoke-WebRequest which I learned from [microsoft docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2). 

### Set-Location
As I was downloading, extracting, and then running files all in the same PowerShell script I had to use ´Set-Location´ for moving around in the file system, rather than ´cd´ which I was used to.  

### Export and Import Group Policy Objects
As I wanted the script to run without any GUIs popping up I had to create a group policy object in advance and create a file I could import to use in the script.

To solve this I used Group Policy Management Console ([Microsoft; Export a GPO to a file](https://docs.microsoft.com/en-us/microsoft-desktop-optimization-pack/agpm/export-a-gpo-to-a-file#:~:text=To%20export%20a%20GPO%20to,and%20then%20click%20Export%20to.)) and the ´Import-GPO´ command ([Microsoft; Import-GPO](https://docs.microsoft.com/en-us/powershell/module/grouppolicy/import-gpo?view=windowsserver2022-ps)). 


## Conclusion

In conclusion, I had to solve several problems underways, using various methods from several sources. Some of the solutions worked great, some could have been better. However, overall I am happy with the result and think I managed to implement a good active directory for the riot organization. 


