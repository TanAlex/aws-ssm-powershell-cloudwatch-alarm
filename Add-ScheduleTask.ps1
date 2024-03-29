$Trigger= New-ScheduledTaskTrigger `
    -Once `
    -At (Get-Date).AddMinutes(1) `
    -RepetitionInterval (New-TimeSpan -Minutes 5) `
    -RepetitionDuration ([System.TimeSpan]::MaxValue)
$User= "NT AUTHORITY\SYSTEM" # Specify the account to run the script
$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "C:\OnicaTools\SendMetrics.ps1" 
# Specify what program to run and with its parameters
Register-ScheduledTask -TaskName "SendMetricsCronJob" -Trigger $Trigger `
    -User $User -Action $Action -RunLevel Highest -Force
