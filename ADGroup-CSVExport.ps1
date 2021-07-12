<# 
This script can be used for pulling the list of members from a group in Active Directory.
Note that this script does not recurse on pulled objects, so if there are nested sub-groups,
then you will only see the top-level group.

You will be prompted for an Group name string when ran -- you can use a dn, cn, or other valid identifier.
#>

[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$groupname = [Microsoft.VisualBasic.Interaction]::InputBox('Please enter the name of the group you would like to export','Choose a Group Name')

Get-ADGroupMember -Identity $groupname | select name, samAccountName | Export-CSV -path "$HOME\Documents\$("$groupname") Export.csv" -NoTypeInformation
