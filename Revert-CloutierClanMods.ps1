#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Write-Host "=== CloutierClan Valheim Mod Revert ===" -ForegroundColor Cyan


#
# Find Valheim
#

$defaultPath = "C:\Program Files (x86)\Steam\steamapps\common\Valheim"

if (Test-Path $defaultPath) {
    $valheimPath = $defaultPath
}
else {
    Write-Host ""
    Write-Host "Default Valheim path not found." -ForegroundColor Yellow
    $valheimPath = Read-Host "Enter your Valheim install path"
}


if (-not (Test-Path $valheimPath)) {
    throw "Valheim path does not exist: $valheimPath"
}


Write-Host ""
Write-Host "Valheim found:"
Write-Host $valheimPath -ForegroundColor Green


#
# Files/folders installed by BepInEx
#

$removeItems = @(

    # BepInEx
    (Join-Path $valheimPath "BepInEx"),

    # Doorstop loader
    (Join-Path $valheimPath "winhttp.dll"),
    (Join-Path $valheimPath "doorstop_config.ini"),

    # BepInEx logs/config generated at root
    (Join-Path $valheimPath "BepInExLogOutput.log")

)


foreach ($item in $removeItems) {

    if (Test-Path $item) {

        Write-Host "Removing:"
        Write-Host $item

        Remove-Item `
            $item `
            -Recurse `
            -Force
    }
}


#
# Remove generated files
#

$extraFiles = @(
    "LogOutput.log",
    "HarmonyX.log"
)


foreach ($file in $extraFiles) {

    $path = Join-Path $valheimPath $file

    if (Test-Path $path) {
        Remove-Item $path -Force
    }
}


Write-Host ""
Write-Host "=== Revert Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Valheim has been returned to vanilla."
Write-Host "Your worlds and saves were not touched."