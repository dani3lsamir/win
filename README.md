# Mi Setup

Instalador de mis apps y ajustes para Windows. Abre una ventana con casillas: marco lo que quiero y lo instala con winget, que siempre baja la última versión.

## Uso

En un Windows nuevo, abre PowerShell y ejecuta:

```powershell
irm dani3lsamir.github.io/win | iex
```

Si GitHub Pages no está activado, funciona igual con la dirección larga:

```powershell
irm https://raw.githubusercontent.com/dani3lsamir/win/main/install.ps1 | iex
```

## Agregar o quitar una app

1. Busca su ID: `winget search nombre-de-la-app`
2. Agrega una línea en la lista `$Apps` de `install.ps1`:
   ```powershell
   @{ Cat = 'Utilidades'; Id = 'Id.DeWinget'; Name = 'Nombre'; On = $true }
   ```
   `On = $true` hace que aparezca marcada por defecto.

## Comando corto

El comando corto se publica con GitHub Pages (activado en **Settings → Pages → Source: GitHub Actions**). Cada vez que edites `install.ps1` y hagas push, se actualiza solo.
