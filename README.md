# CloutierClan Valheim Mod Pack

A one-click PowerShell installer for the CloutierClan Valheim server.

This installer automatically downloads and installs all required client-side mods directly from Thunderstore, so players don't need to install a mod manager or manually manage dependencies.

---

## Features

- ✅ Automatically installs BepInEx
- ✅ Downloads all required mods from Thunderstore
- ✅ Installs dependencies automatically
- ✅ Supports vanilla Valheim installations
- ✅ Supports custom Steam library locations
- ✅ Includes a revert script to return to vanilla
- ✅ No Thunderstore Mod Manager required

---

## Requirements

- Windows
- PowerShell 5.1 or newer
- Steam
- Valheim

---

## Installation

1. Clone this repository or download it as a ZIP.

2. Open **PowerShell as Administrator**.

   - Open the Start Menu
   - Search for **PowerShell**
   - Right-click **Windows PowerShell**
   - Select **Run as administrator**

3. Navigate to the repository folder:

   ```powershell
   cd C:\Path\To\CloutierClan-Valheim-ModPack
   ```

4. Run the installer:

   ```powershell
   .\Install-ModPack.ps1
   ```

5. If Valheim is installed in the default Steam location, the installer will detect it automatically.

   If not, you'll be prompted to enter your Valheim installation folder.

   Example:

   ```
   F:\SteamLibrary\steamapps\common\Valheim
   ```

6. Launch Valheim and connect to the CloutierClan server.

---

## Permissions

The installer requires administrator privileges because it modifies the Valheim installation directory.

Running without administrator privileges may result in:

- Permission denied errors
- Mods not being copied
- BepInEx files not being updated
- Configuration changes failing

Always run the installer from an elevated PowerShell window.

---

## Returning to Vanilla

Run:

```powershell
.\Revert-To-Vanilla.ps1
```

This removes all installed mods and restores your Valheim installation to a clean state.

---

## Updating

Simply run the installer again.

The installer will download newer versions of mods when the mod pack is updated.

---

## Troubleshooting

### "Incompatible Version"

Make sure you've run the latest installer from this repository.

If the server has recently been updated, run the installer again to receive the latest mod versions.

---

### Installer can't find Valheim

Enter your Valheim installation directory when prompted.

Example:

```
F:\SteamLibrary\steamapps\common\Valheim
```

---

### Windows blocks PowerShell scripts

Run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Then rerun the installer.

---

### Antivirus warning

The installer downloads files directly from Thunderstore and copies them into your Valheim installation.

Some antivirus software may briefly inspect these downloads. This is expected.

---

## Server Mods

The server currently uses:

- Epic Loot
- AzuCraftyBoxes
- PlantEverything

Additional client-side quality-of-life mods may be added over time.

---

## Contributing

Issues and pull requests are welcome.

If a mod update breaks compatibility, please open an issue with:

- Valheim version
- Installer output
- Any BepInEx log messages

---

## Disclaimer

This project is not affiliated with Iron Gate AB or Thunderstore.

All mods remain the property of their respective authors.