# Check if the powershell is running as Admin

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
    Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Start-Sleep -Seconds 1
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
    exit
}

#Enter the port that you want
Write-Host "Warning !!!, This script will modify your registry setting, you may need to backup your system" -ForegroundColor Red
Write-Host "`n"
Write-Host "This is the script to change the Remote Desktop Port" -ForegroundColor Green
Write-Host "`n"
$NewPort = Read-Host "Enter the Remote Desktop Port that you want:"

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$KeyName ="PortNumber"

try {
    Set-ItemProperty -Path $RegistryPath -Name $KeyName -Value $NewPort -Force | Out-Null
}
catch {
    Write-Host "Error. Please check or contact your administrator" -ForegroundColor Red
}

Write-Host "RDP Port has been changed, please restart your computer to apply the changes"
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');