<# 
This script can be used for pulling the list of members from a group in Active Directory.
Note that this script does not recurse on pulled objects, so if there are nested sub-groups,
then you will only see the top-level group.

You will be prompted for an Identity value when ran -- you can use a dn, cn, or other valid identifier.

Be sure to change the -path attribute to an existing folder on your machine.
#>

Get-ADGroupMember | select name, samAccountName | Export-CSV -path C:\Users\Shawn\Desktop\Scripts\Export\ADGroup_Export.csv
