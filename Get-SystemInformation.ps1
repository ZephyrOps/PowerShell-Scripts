$BIOSInfo = Get-CIMInstance CIM_BIOSElement | Select-Object SerialNumber,Name
#$BIOSInterface = Get-WmiObject -Namespace root\wmi -Class Lenovo_BiosSetting | Select-Object CurrentSetting
$DiskInfo = Get-WmiObject Win32_logicaldisk -Filter "DriveType = '3'" |
            Select-Object @{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}},@{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}}
$OSVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
$CVAlpha = Get-WMIObject Win32_ComputerSystemProduct | Select-object vendor, version
$model = $CVAlpha.vendor.ToString() + " " + $CVAlpha.version.ToString()
$hashTable = [ordered]@{"Computer Model"=$model
                        "Computer Name"=$ENV:COMPUTERNAME
                        "BIOS_Serial"=$BIOSInfo.SerialNumber
                        "BIOS_Version"=$BIOSInfo.Name
                        "Disk_FreeSpace"=$DiskInfo.FreeSpaceGB
                        "Disk_MaxSpace"=$DiskInfo.Capacity
                        "OS Version"=$OSVersion
                        "OS Build"=(Get-WMIObject Win32_OperatingSystem).BuildNumber}
return $hashTable