# Locate dcu-cli.exe (checks both x64 and x86 default paths)
$dcuPath = @(
    "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe",
    "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($dcuPath) {
    # Run updates silently and suppress automatic reboots
    Start-Process -FilePath $dcuPath -ArgumentList "/applyUpdates -silent -reboot=disable" -Wait -NoNewWindow
} else {
    Write-Warning "Dell Command | Update CLI (dcu-cli.exe) was not found."
}
