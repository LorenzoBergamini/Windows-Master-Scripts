# clean-and-simple compile.ps1
$source = "WindowsMasterScripts.ps1"
$target = "WindowsMasterScripts.exe"
$icon   = "icon.ico"          # comment out if you don't have one

# Install PS2EXE module if missing
if (-not (Get-Module -ListAvailable -Name PS2EXE)) {
    Install-Module PS2EXE -Scope CurrentUser -Force
}

# build command
$ps2exeParams = @{
    InputFile  = $source
    OutputFile = $target
    NoConsole  = $true          # << GUI build, no black window
    Title      = "Windows Master Scripts"
    $ps2exeParams.Icon = $icon
}

Invoke-PS2EXE @ps2exeParams     # the real cmdlet name
Write-Host "`nDone   find the EXE at: $target"
