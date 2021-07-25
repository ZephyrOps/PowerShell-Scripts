$users = ForEach ($user in $(Get-Content C:\Users\44724\Desktop\Scripting\names_to_ecodes.txt))
{
Get-QADUser $user -Properties samAccountName, userPrincipalName, mail, title, department
}
$users |
Select-Object samAccountName | Export-CSV -Path C:\Users\44724\Desktop\Scripting\Export\Users.csv