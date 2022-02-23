# Step 3
# Installing Chocolatey and some apps
$ExecPolicy = Get-ExecutionPolicy

if ($ExecPolicy) {
  Set-ExecutionPolicy AllSigned
} 
else {
  Write-host "Policy is right"
}

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$apps = @(
    @{name = "paint.net" },
		@{name = "autoruns" },
		@{name = "cascadiacode"},
		@{name = "firacode-ttf"},
		@{name = "cmder" }
);
Foreach ($app in $apps) {
    #check if the app is already installed
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.name
        if ($app.source -ne $null) {
            choco install $app.name -y
        }
    }
    else {
        Write-host "Skipping Install of " $app.name
    }
}