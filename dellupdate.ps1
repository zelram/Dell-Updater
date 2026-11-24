# Create variable to hold the code block.
$script = {
	# Locate dcu-cli.exe (checks both x64 and x86 default paths)
	$dcuPath = @(
		"C:\Program Files\Dell\CommandUpdate\dcu-cli.exe",
		"C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
	) | Where-Object { Test-Path $_ } | Select-Object -First 1

	if ($dcuPath) {
		# Run updates silently and suppress automatic reboots
		Start-Process -FilePath $dcuPath -ArgumentList "/applyUpdates -reboot=disable" -Wait -NoNewWindow
	} else {
		Write-Warning "Dell Command | Update CLI (dcu-cli.exe) was not found."
	}
}

# Start in a new powershell window to ensure it is ran as admin
# Try catch ensures that if the wt.exe cannot be found it will just default to powershell.

try {
	Start-Process wt.exe -Verb RunAs -ArgumentList @(
		'powershell'
		'-NoExit'
		'-NoProfile'
		'-ExecutionPolicy', 'Bypass'
		'-Command', $script
	)
}

catch {
	Start-Process powershell -Verb RunAs -ArgumentList @(
		'-NoExit',
		'-ExecutionPolicy', 'Bypass',
		'-Command', $script
	)
}
exit
