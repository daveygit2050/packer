Enable-RemoteDesktop
Set-NetFirewallRule -Name RemoteDesktop-UserMode-In-TCP -Enabled True

Update-ExecutionPolicy -Policy Unrestricted

Install-WindowsUpdate -AcceptEula
if(Test-PendingReboot){ Invoke-Reboot }

Write-BoxstarterMessage "Cleaning SxS..."
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

mkdir C:\Windows\Panther\Unattend
copy-item a:\postunattend.xml C:\Windows\Panther\Unattend\unattend.xml

Write-BoxstarterMessage "Setting up winrm"
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
Enable-WSManCredSSP -Force -Role Server

Enable-PSRemoting -Force -SkipNetworkProfileCheck
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
