$BIOSInfo = Get-CIMInstance CIM_BIOSElement | Select-Object SerialNumber,SMBIOSBIOSVersion
$DiskInfo = Get-WmiObject -Class Win32_logicaldisk -Filter "DriveType = '3'" |
            Select-Object @{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}},@{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}}