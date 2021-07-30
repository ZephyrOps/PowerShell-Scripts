<# This script is designed to export a user's group membership using PowerShell. #>

[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$username = [Microsoft.VisualBasic.Interaction]::InputBox('Please enter the name of the user whose group membership you would like you query','Choose a User')

Get-QADUser -Identity $username | Get-QADMemberOf | select name,Description | export-CSV -path "$HOME\Desktop\Scripting\$($username) Group Membership.csv"

<# A different example using Get-ADUser and Get-ADPrincipalMemberOf #>

$users = Get-ADUser -filter { Name -like 'Test *, GXC-10'} -searchBase "OU=Test Accounts,OU=Azure,OU=Resources,OU=Global,DC=BAIN,DC=com"

foreach($user in $users) 
{
Get-ADPrincipalGroupMembership $user.SamAccountName | 
Select-object Name,distinguishedName | 
Export-CSV -path "$HOME\Desktop\Scripting\$($User.Name) Group Export.csv" -NoTypeInformation
}