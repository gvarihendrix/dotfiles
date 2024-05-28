if (Test-Path -Path $env:LOCALAPPDATA\nvim) {
	Remove-Item $env:LOCALAPPDATA\nvim -Recurse
}

Copy-Item $(pwd) -Destination $env:LOCALAPPDATA\nvim -Recurse

