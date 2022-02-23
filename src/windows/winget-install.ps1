# Step 2 ------------------------------------------------
# Self elevate administrative permissions in this script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
  return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Install WinGet
# Based on this gist: https://gist.github.com/crutkas/6c2096eae387e544bd05cde246f23901
$hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
    "Installing winget Dependencies"
    Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

    $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri $releases_url
    $latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith('msixbundle') } | Select -First 1

    "Installing winget from $($latestRelease.browser_download_url)"
    Add-AppxPackage -Path $latestRelease.browser_download_url
}
else {
    "winget already installed"
}

winget list

# Remove a few pre-installed applications
Write-Output "Removing pre-installed apps"
$apps = @(
    @{name = "Microsoft.549981C3F5F10_8wekyb3d8bbwe" },
		@{name = "Microsoft.BingWeather_8wekyb3d8bbwe" },
		@{name = "Microsoft.Getstarted_8wekyb3d8bbwe" },
		@{name = "Microsoft.MSPaint_8wekyb3d8bbwe" },
		@{name = "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe" },
		@{name = "Microsoft.Office.OneNote_8wekyb3d8bbwe" },
		@{name = "Microsoft.People_8wekyb3d8bbwe" },
		@{name = "Microsoft.SkypeApp_kzf8qxf38zg5c" },
		@{name = "Microsoft.YourPhone_8wekyb3d8bbwe" },
		@{name = "Microsoft.OneDrive" },
		@{name = "Microsoft.WindowsMaps_8wekyb3d8bbwe" }
);
Foreach ($app in $apps) {
    Write-host "Uninstalling:" $app.name
    if ($app.source -ne $null) {
        winget uninstall --exact --silent $app.name
    }
    else {
        winget uninstall --exact --silent $app.name 
    }
}

# Install some apps
$apps = @(
    @{name = "7zip.7zip" },
		@{name = "Figma.Figma" },
		@{name = "Opera.Opera" },
		@{name = "Notion.Notion" },
		@{name = "gerardog.gsudo" },
		@{name = "Microsoft.PowerToys" },
		@{name = "Microsoft.WindowsTerminal" },
		@{name = "Microsoft.VisualStudioCode" },
		@{name = "Discord.Discord" },
		@{name = "VideoLAN.VLC" },
		@{name = "TimKosse.FileZilla.Client" },
		@{name = "PuTTY.PuTTY" },
		@{name = "PowerSoftware.PowerISO" },
		@{name = "NordVPN.NordVPN" },
		@{name = "Lexikos.AutoHotkey" },
		@{name = "ShareX.ShareX" },
		@{name = "NickeManarin.ScreenToGif" },
		@{name = "flux.flux" },
		@{name = "Postman.Postman"},
		@{name = "AnyDeskSoftwareGmbH.AnyDesk"},
		@{name = "Canonical.Ubuntu" }
);
Foreach ($app in $apps) {
    #check if the app is already installed
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.name
        if ($app.source -ne $null) {
            winget install --exact --silent $app.name --source $app.source
        }
        else {
            winget install --exact --silent $app.name 
        }
    }
    else {
        Write-host "Skipping Install of " $app.name
    }
}