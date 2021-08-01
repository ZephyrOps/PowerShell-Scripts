<# This script is designed to take a .csv formatted list of groups from a file and pull a recursive report of the users in each group. #>

if (Get-Module -ListAvailable -Name "ActiveDirectory") {
    Write-Host "The ActiveDirectory module is installed. Proceeding..." -ForegroundColor "Green"
} else {
    Write-Host "The ActiveDirectory module is not installed. Installing the latest version..." -ForegroundColor "Yellow"
    Install-Module -name "ActiveDirectory" -Scope CurrentUser -Force
}

if (Get-Module -ListAvailable -Name "ImportExcel") {
    Write-Host "The ImportExcel module is installed. Proceeding..." -ForegroundColor "Green"
} else {
    Write-Host "The ImportExcel module is not installed. Installing the latest version..." -ForegroundColor "Yellow"
    Install-Module -name "ImportExcel" -Scope CurrentUser -Force
}

Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory=[Environment]::GetFolderPath('Desktop')
    Filter= "Text Document (*.txt)|*.txt|Microsoft Excel Comma Separated Values Files (*.csv)|*.csv"
    Title="Select a File Containing a List of Group Names"
}

# Validate that a file was received by the dialog before using Get-Content. Bring dialog box to TopMost

$DialogResult = $FileBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))

if ($DialogResult -eq "OK") {
    $GroupNames = Get-Content -Path $FileBrowser.FileName
} else {
    exit
}
# Create a temporary directory to house all exported .csvs before merging. WiP

New-Item -Path "$HOME\Downloads\" -Name "ExportTemp" -ItemType Directory -Force | Out-Null

foreach ($Group in $GroupNames) {
    Get-ADGroupMember -Identity $Group -Recursive | 
    Get-ADUser -Properties mail | 
    Select-Object name,mail,samaccountname | 
    export-csv -Path "$HOME\Downloads\ExportTemp\$($Group) Export.csv"  -NoTypeInformation
}

$csvList = Get-ChildItem "$HOME\Downloads\ExportTemp\*" -Include *.csv
Write-Host "Detected the following CSV files: $($csvList.Count)"
foreach ($csv in $csvList) {
    Write-Host " -"$csv.Name
}

$excelFileName = "Group Export.xlsx"

foreach ($csv in $csvList) {
    $csvPath = "$HOME\Downloads\ExportTemp\" + $csv.Name
    $worksheetName = ($csv.Name).TrimEnd(" Export.csv")
    Import-Csv -Path $csvPath | Export-Excel -Path "$HOME\Downloads\$excelFileName" -WorkSheetname $worksheetName -AutoSize -FreezeTopRow -BoldTopRow
}

Remove-Item -Path "$HOME\Downloads\ExportTemp" -Recurse -Force

exit