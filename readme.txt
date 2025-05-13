compile command:
powershell -ExecutionPolicy Bypass -Command "& { Import-Module ps2exe; Invoke-PS2EXE -InputFile 'WindowsMasterScripts.ps1' -OutputFile 'WindowsMasterScripts.exe' -icon 'icon.ico' -noConsole -title 'Windows Master Scripts' }"
