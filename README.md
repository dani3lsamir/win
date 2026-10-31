# Win Setup

My apps and settings installer for Windows. It opens a window with checkboxes: I pick what I want and it installs everything with winget, which always downloads the latest version.

## Usage

On a fresh Windows install, open PowerShell and run:

```powershell
irm dani3lsamir.github.io/win | iex
```

If GitHub Pages is not available, the long URL works too:

```powershell
irm https://raw.githubusercontent.com/dani3lsamir/win/main/install.ps1 | iex
```

## Adding or removing an app

1. Find its ID: `winget search app-name`
2. Add a line to the `$Apps` list in `install.ps1`:
   ```powershell
   @{ Cat = 'Utilities'; Id = 'Winget.Id'; Name = 'Name'; On = $true }
   ```
   `On = $true` makes it checked by default.

## Short command

The short command is published with GitHub Pages (**Settings → Pages → Source: GitHub Actions**). Every time `install.ps1` is pushed, it updates automatically.

---

Linux version: [dani3lsamir/lin](https://github.com/dani3lsamir/lin)

by: [dani3lsamir](https://github.com/dani3lsamir)
