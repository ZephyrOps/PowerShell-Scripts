function Confirm-Module {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$TRUE, Position=0)]
        [string[]] $ModuleNames
    )

    foreach ($Module in $ModuleNames) {
        if (Get-Module -ListAvailable -Name $Module) {
            Write-Verbose "The $($Module) module is installed. Proceeding..." -ForegroundColor "Green"
        } else {
            Write-Host "The $($Module) module is not installed. Installing the latest version..." -ForegroundColor "Yellow"
            Install-Module -name $Module -Scope CurrentUser -Force
        }
    }
}