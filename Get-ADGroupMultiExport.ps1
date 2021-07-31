<# This script is designed to take a .csv formatted list of groups from a file and pull a recursive report of the users in each group. #>

Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory=[Environment]::GetFolderPath('Desktop')
    Filter= "Text Document (*.txt)|*.txt|Microsoft Excel Comma Separated Values Files (*.csv)|*.csv"
    Title="Select a File Containing a List of Group Names"
}

$NULL = $FileBrowser.ShowDialog()

$GroupNames = Get-Content -Path $FileBrowser.FileName

foreach ($Group in $GroupNames) {
    Get-ADGroupMember -Identity $Group -Recursive | 
    Get-ADUser -Properties mail | 
    Select-Object name,mail,samaccountname | 
    export-csv -Path "$HOME\Downloads\$($Group) Export.csv"  -NoTypeInformation
}