#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Write-Host "=== CloutierClan Valheim Mod Installer ===" -ForegroundColor Cyan

#
# Always run from script directory
#

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptRoot


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
# Paths
#

$bepinexPath = Join-Path $valheimPath "BepInEx"
$pluginPath = Join-Path $bepinexPath "plugins"

$temp = Join-Path $env:TEMP "CloutierClanMods"


#
# Clean temp
#

if (Test-Path $temp) {
    Remove-Item $temp -Recurse -Force
}

New-Item $temp -ItemType Directory | Out-Null


#
# Download helper
#

function Download-ThunderstorePackage {

    param(
        [string]$Namespace,
        [string]$Name,
        [string]$Version
    )

    $url = "https://thunderstore.io/package/download/$Namespace/$Name/$Version/"
    $zip = Join-Path $temp "$Name.zip"

    Write-Host ""
    Write-Host "Downloading $Namespace/$Name $Version" -ForegroundColor Cyan

    Invoke-WebRequest `
        -Uri $url `
        -OutFile $zip

    return $zip
}


#
# Install BepInEx
#

if (-not (
    (Test-Path (Join-Path $valheimPath "winhttp.dll")) -and
    (Test-Path (Join-Path $bepinexPath "core"))
)) {

    Write-Host ""
    Write-Host "Installing BepInExPack..." -ForegroundColor Cyan

    $zip = Join-Path $temp "BepInExPack.zip"
    $extract = Join-Path $temp "BepInExExtract"

    Invoke-WebRequest `
        -Uri "https://thunderstore.io/package/download/denikson/BepInExPack_Valheim/5.4.2333/" `
        -OutFile $zip

    Expand-Archive `
        -Path $zip `
        -DestinationPath $extract `
        -Force


    $source = Join-Path $extract "BepInExPack_Valheim"

    Copy-Item `
        "$source\*" `
        $valheimPath `
        -Recurse `
        -Force
}
else {
    Write-Host "BepInEx already installed."
}


#
# Ensure folders exist
#

foreach ($folder in @(
    $pluginPath,
    (Join-Path $bepinexPath "config"),
    (Join-Path $bepinexPath "patchers")
)) {
    New-Item $folder -ItemType Directory -Force | Out-Null
}


#
# Load manifest
#

$manifestPath = Join-Path $scriptRoot "CloutierClan-Modpack.json"

if (-not (Test-Path $manifestPath)) {
    throw "Missing CloutierClan-Modpack.json"
}

$manifest = Get-Content $manifestPath | ConvertFrom-Json


Write-Host ""
Write-Host "Mods to install:" -ForegroundColor Cyan

foreach ($mod in $manifest.mods) {

    Write-Host "$($mod.namespace)/$($mod.name) $($mod.version)"
}


#
# Install mods
#

foreach ($mod in $manifest.mods) {

    $zip = Download-ThunderstorePackage `
        -Namespace $mod.namespace `
        -Name $mod.name `
        -Version $mod.version


    $extract = Join-Path $temp $mod.name


    Expand-Archive `
        -Path $zip `
        -DestinationPath $extract `
        -Force


    Write-Host ""
    Write-Host "Installing $($mod.name)..." -ForegroundColor Cyan


    #
    # Find BepInEx folder inside package
    #

    $sourceBep = Get-ChildItem `
        -Path $extract `
        -Directory `
        -Recurse `
        -Filter "BepInEx" |
        Select-Object -First 1


    if ($sourceBep) {

        Copy-Item `
            "$($sourceBep.FullName)\*" `
            $bepinexPath `
            -Recurse `
            -Force

        Write-Host "Merged BepInEx contents."
    }
    else {

        #
        # fallback: plugin folder only
        #

        $sourcePlugins = Get-ChildItem `
            -Path $extract `
            -Directory `
            -Recurse `
            -Filter "plugins" |
            Select-Object -First 1


        if ($sourcePlugins) {

            Copy-Item `
                "$($sourcePlugins.FullName)\*" `
                $pluginPath `
                -Force

            Write-Host "Installed plugins."
        }
       else {

    #
    # Fallback: root-level DLL package
    #

    $rootDlls = Get-ChildItem `
        -Path $extract `
        -Filter "*.dll" `
        -File


    if ($rootDlls) {

        foreach ($dll in $rootDlls) {

            Write-Host "Installing root DLL: $($dll.Name)"

            Copy-Item `
                $dll.FullName `
                $pluginPath `
                -Force
        }
    }
    else {
        Write-Warning "No BepInEx files found for $($mod.name)"
    }
    }
    }
}

if ($manifest.mods | Where-Object {
    $_.namespace -eq "RandyKnapp" -and
    $_.name -eq "EquipmentAndQuickSlots"
}) 
{

Write-Host "Copying EquipmentAndQuickSlots config file..." -ForegroundColor Cyan

Copy-Item ".\config\randyknapp.mods.equipmentandquickslots.cfg" `
          "$ValheimPath\BepInEx\config\" -Force

Write-Host "Copied EquipmentAndQuickSlots config file."
}

#
# Verify
#

Write-Host ""
Write-Host "Installed plugins:" -ForegroundColor Cyan

 Get-ChildItem `
    $pluginPath `
    -Filter "*.dll" |
    Select-Object Name




Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host "Launch Valheim and connect to CloutierClan."