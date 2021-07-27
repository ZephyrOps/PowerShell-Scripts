Install-Module -name AzureAD
Connect-AzureAD # Proceed through MFA prompt sign-in to authenticate elevated account credentials

$hubSpotGroups = Get-AzureADGroup -searchString "HubSpot"
$user = Get-AzureADUser -searchString "44724"
Add-AzureADGroupMember -objectID $hubSpotGroups -refObjectID $user
