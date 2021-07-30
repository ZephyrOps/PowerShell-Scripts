<# This script is designed to take a .csv formatted list of groups in a Groups.txt file and pull a recursive report of the users in each group. #>

[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$DocumentName = [Microsoft.VisualBasic.Interaction]::InputBox('Please enter the name of the file containing the list of groups and include the file extension. This file must exist in a Desktop\Scripting directory on your local machine.',
'Upload Export List')

$Groups = Get-Content -Path "$HOME\Desktop\Scripting\$($DocumentName)"

foreach ($Group in $Groups)
{
Get-ADGroupMember -Identity $Group -Recursive | 
Get-ADUser -Properties Mail | 
select name,mail,samaccountname | 
export-csv -Path "$HOME\Desktop\Scripting\$($Group) Export.csv"  -NoTypeInformation
}