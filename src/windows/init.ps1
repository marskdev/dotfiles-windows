# Step 1 ------------------------------------------------
# Self elevate administrative permissions in this script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
  return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}
# Activate Windows
slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
# Enable WSL 1
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /restart