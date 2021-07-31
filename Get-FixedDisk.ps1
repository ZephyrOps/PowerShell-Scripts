Function Get-FixedDisk {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Computer
    )
$DiskInfo = Get-WMIObject Win32_LogicalDisk -ComputerName $Computer -Filter 'DriveType=3'
$DiskInfo
}