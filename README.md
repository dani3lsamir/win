# Win Setup

My apps and settings installer for Windows and Linux. It opens a window with checkboxes: I pick what I want and it installs everything with winget, which always downloads the latest version.

## Windows

On a fresh Windows install, open PowerShell and run:

```powershell
irm dani3lsamir.github.io/win | iex
```

If GitHub Pages is not available, the long URL works too:

```powershell
irm https://raw.githubusercontent.com/dani3lsamir/win/main/install.ps1 | iex
```

## Linux

Open a terminal and run:

```bash
curl -fsSL dani3lsamir.github.io/win/linux | bash
```

Long URL:

```bash
curl -fsSL https://raw.githubusercontent.com/dani3lsamir/win/main/linux.sh | bash
```

Two menus with checkboxes (apps, then settings). Works on Debian/Ubuntu/Mint, Fedora, Arch and openSUSE. Desktop apps come from Flathub, the browser is [Brave Origin](https://brave.com/origin/linux/) (free on Linux), and settings support GNOME and KDE.

## Adding or removing an app

1. Find its ID: `winget search app-name`
2. Add a line to the `$Apps` list in `install.ps1`:
   ```powershell
   @{ Cat = 'Utilities'; Id = 'Winget.Id'; Name = 'Name'; On = $true }
   ```
   `On = $true` makes it checked by default.

On Linux, add a line to `APPS` in `linux.sh`. For a Flathub app (find the id on flathub.org):
```bash
"key|Category|Name|flatpak|org.example.App|1"
```

## Short command

The short command is published with GitHub Pages (**Settings → Pages → Source: GitHub Actions**). Every time `install.ps1` or `linux.sh` is pushed, it updates automatically.

---

by: [dani3lsamir](https://github.com/dani3lsamir)
