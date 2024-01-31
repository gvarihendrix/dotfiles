if (Test-Path -Path $env:LOCALAPPDATA\nvim) {
	Remove-Item $env:LOCALAPPDATA\nvim -Recurse
}

Copy-Item $env:USERPROFILE\dotfiles\nvim -Destination $env:LOCALAPPDATA\nvim -Recurse

