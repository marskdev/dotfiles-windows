# Step 4

# Installing Scoop
Set-ExecutionPolicy RemoteSigned -scope CurrentUser 
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
# Installing apps
#scoop install aria2 wget curl grep sed less touch vim sudo which zip unzip

$apps = @(
		@{name = "aria2" }
		@{name = "wget" }
		@{name = "curl" }
		@{name = "grep" }
		@{name = "sed" }
		@{name = "less" }
		@{name = "touch" }
		@{name = "vim" }
		@{name = "which" }
		@{name = "zip" }
		@{name = "unzip" }
		@{name = "sudo" }
);
Foreach ($app in $apps) {
    #check if the app is already installed
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.name
        if ($app.source -ne $null) {
            scoop install $app.name
        }
    }
    else {
        Write-host "Skipping Install of " $app.name
    }
}