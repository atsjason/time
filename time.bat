net start w32time
w32tm /resync
net stop w32time
powershell.exe -ExecutionPolicy ByPass -File "C:\Time\time.ps1"
