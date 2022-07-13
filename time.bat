rem net start w32time
rem w32tm /resync
rem net stop w32time
powershell.exe -ExecutionPolicy ByPass -File "C:\Time\time.ps1"
