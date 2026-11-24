
# Check if running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

$isAdmin = $currentPrincipal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin) {

    Write-Host "Administrator privileges required. Relaunching..." -ForegroundColor Yellow

    # Relaunch the current script in an elevated PowerShell window
    $encodedCommand = [Convert]::ToBase64String(
        [System.Text.Encoding]::Unicode.GetBytes($MyInvocation.MyCommand.Definition)
    )

    Start-Process powershell.exe -Verb RunAs -ArgumentList @(
        '-NoExit'
        '-NoProfile'
        '-ExecutionPolicy', 'Bypass'
        '-EncodedCommand', $encodedCommand
    )

    # IMPORTANT: Return without closing the original terminal
    return
}

Write-Host "Running with Administrator privileges." -ForegroundColor Green

# Locate DCU-CLI
$dcuPath = @(
    "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe",
    "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($dcuPath) {

    Write-Host "Dell Command Update found: $dcuPath" -ForegroundColor Cyan
    Write-Host "Starting updates..." -ForegroundColor Yellow

    # Run updates and wait for completion
    $process = Start-Process -FilePath $dcuPath `
        -ArgumentList "/applyUpdates -reboot=disable" `
        -Wait `
        -PassThru `
        -NoNewWindow

    Write-Host "Dell Command Update finished. Exit code: $($process.ExitCode)" -ForegroundColor Green

} else {

    Write-Warning "Dell Command | Update CLI (dcu-cli.exe) was not found."

}

Write-Host "Script completed." -ForegroundColor Green
