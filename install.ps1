# Mi instalador de apps y ajustes para Windows.
# Uso (PowerShell):  irm https://dani3lsamir.github.io/win | iex
#
# Este archivo usa solo caracteres ASCII (sin tildes) a proposito:
# asi nunca se rompe por temas de codificacion al descargarlo con irm.

function Start-MiSetup {

    # Direccion desde donde se descarga este script (se usa para reabrirlo como administrador).
    $ScriptUrl = 'https://dani3lsamir.github.io/win'

    # ======================================================================
    #  APPS
    #  Id  = identificador de winget (buscalo con: winget search nombre)
    #  On  = $true si aparece marcada por defecto
    # ======================================================================
    $Apps = @(
        @{ Cat = 'IA y notas';         Id = 'Anthropic.Claude';                Name = 'Claude';                  On = $true }
        @{ Cat = 'IA y notas';         Id = 'OpenAI.ChatGPT';                  Name = 'ChatGPT';                 On = $true }
        @{ Cat = 'IA y notas';         Id = 'Granola.Granola';                 Name = 'Granola';                 On = $true }
        @{ Cat = 'IA y notas';         Id = 'cjpais.Handy';                    Name = 'Handy (voz a texto)';     On = $true }
        @{ Cat = 'IA y notas';         Id = 'Obsidian.Obsidian';               Name = 'Obsidian';                On = $true }

        @{ Cat = 'Utilidades';         Id = '7zip.7zip';                       Name = '7-Zip';                   On = $true }
        @{ Cat = 'Utilidades';         Id = 'RARLab.WinRAR';                   Name = 'WinRAR';                  On = $true }
        @{ Cat = 'Utilidades';         Id = 'Ghisler.TotalCommander';          Name = 'Total Commander';         On = $true }
        @{ Cat = 'Utilidades';         Id = 'LocalSend.LocalSend';             Name = 'LocalSend';               On = $true }
        @{ Cat = 'Utilidades';         Id = 'Tailscale.Tailscale';             Name = 'Tailscale';               On = $true }
        @{ Cat = 'Utilidades';         Id = 'ArtCraft.PdfCraft';               Name = 'PdfCraft';                On = $true }

        @{ Cat = 'Nube';               Id = 'Google.GoogleDrive';              Name = 'Google Drive';            On = $true }
        @{ Cat = 'Nube';               Id = 'Dropbox.Dropbox';                 Name = 'Dropbox';                 On = $true }
        @{ Cat = 'Nube';               Id = 'Nextcloud.NextcloudDesktop';      Name = 'Nextcloud';               On = $true }

        @{ Cat = 'Multimedia';         Id = 'VideoLAN.VLC';                    Name = 'VLC';                     On = $true }
        @{ Cat = 'Multimedia';         Id = 'AIMP.AIMP';                       Name = 'AIMP';                    On = $true }
        @{ Cat = 'Multimedia';         Id = 'OBSProject.OBSStudio';            Name = 'OBS Studio';              On = $true }
        @{ Cat = 'Multimedia';         Id = 'FlorianHeidenreich.Mp3tag';       Name = 'Mp3tag';                  On = $true }

        @{ Cat = 'Desarrollo';         Id = 'Git.Git';                         Name = 'Git';                     On = $true }
        @{ Cat = 'Desarrollo';         Id = 'OpenJS.NodeJS';                   Name = 'Node.js';                 On = $true }
        @{ Cat = 'Desarrollo';         Id = 'Python.Python.3.13';              Name = 'Python 3.13';             On = $true }
        @{ Cat = 'Desarrollo';         Id = 'Microsoft.PowerShell';            Name = 'PowerShell 7';            On = $true }
        @{ Cat = 'Desarrollo';         Id = 'Microsoft.OpenJDK.17';            Name = 'OpenJDK 17';              On = $true }
        @{ Cat = 'Desarrollo';         Id = 'Google.AndroidStudio';            Name = 'Android Studio';          On = $true }
        @{ Cat = 'Desarrollo';         Id = 'Google.PlatformTools';            Name = 'Android Platform Tools';  On = $true }

        @{ Cat = 'Impresora Epson';    Id = 'EPSON.EpsonScan2';                Name = 'Epson Scan 2';            On = $false }
        @{ Cat = 'Impresora Epson';    Id = 'EPSON.ScanSmart';                 Name = 'Epson ScanSmart';         On = $false }
        @{ Cat = 'Impresora Epson';    Id = 'EPSON.EventManager';              Name = 'Epson Event Manager';     On = $false }
        @{ Cat = 'Impresora Epson';    Id = 'EPSON.EpsonNetPrint';             Name = 'Epson Net Print';         On = $false }
        @{ Cat = 'Impresora Epson';    Id = 'EPSON.Scan.OCRComponent';         Name = 'Epson Scan OCR';          On = $false }
        @{ Cat = 'Impresora Epson';    Id = 'EPSON.Scan.PDFExtensions';        Name = 'Epson Scan PDF';          On = $false }

        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.VCRedist.2015+.x64';  Name = 'VC++ 2015+ x64';          On = $true }
        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.VCRedist.2015+.x86';  Name = 'VC++ 2015+ x86';          On = $true }
        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.VCRedist.2010.x64';   Name = 'VC++ 2010 x64';           On = $false }
        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.VCRedist.2010.x86';   Name = 'VC++ 2010 x86';           On = $false }
        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.DotNet.DesktopRuntime.8'; Name = '.NET Desktop 8';      On = $false }
        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.DotNet.DesktopRuntime.9'; Name = '.NET Desktop 9';      On = $false }
        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.DotNet.Runtime.8';    Name = '.NET Runtime 8';          On = $false }
        @{ Cat = 'Librerias (runtimes)'; Id = 'Microsoft.DotNet.AspNetCore.8'; Name = 'ASP.NET Core 8';          On = $false }
    )

    # ======================================================================
    #  AJUSTES (sacados de los tweaks de Chris Titus / winutil)
    # ======================================================================
    function Set-Reg($Path, $Name, $Value, $Type = 'DWord') {
        if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
    }

    $Tweaks = @(
        @{ Name = 'Modo oscuro'; On = $true
           Desc = 'Tema oscuro para Windows y las apps.'
           Run  = {
               Set-Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'AppsUseLightTheme' 0
               Set-Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'SystemUsesLightTheme' 0
           } }
        @{ Name = 'Mostrar extensiones de archivo'; On = $true
           Desc = 'Muestra .exe, .png, .pdf, etc. en el Explorador.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'HideFileExt' 0 } }
        @{ Name = 'Quitar Bing de la busqueda de Inicio'; On = $true
           Desc = 'La busqueda del menu Inicio solo busca en tu PC, sin resultados web.'
           Run  = {
               Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'BingSearchEnabled' 0
               Set-Reg 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' 'DisableSearchBoxSuggestions' 1
           } }
        @{ Name = 'Quitar recomendaciones del menu Inicio'; On = $true
           Desc = 'Oculta la seccion Recomendado. Ojo: tambien desactiva Windows Spotlight.'
           Run  = {
               Set-Reg 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start' 'HideRecommendedSection' 1
               Set-Reg 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Education' 'IsEducationEnvironment' 1
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' 'HideRecommendedSection' 1
           } }
        @{ Name = 'Iconos de la barra de tareas a la izquierda'; On = $true
           Desc = 'Como en Windows 10, en vez de centrados.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'TaskbarAl' 0 } }
        @{ Name = 'Ocultar el boton de busqueda de la barra de tareas'; On = $true
           Desc = 'Puedes seguir buscando con la tecla Windows y escribiendo.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'SearchboxTaskbarMode' 0 } }
        @{ Name = 'Ocultar el boton Vista de tareas'; On = $true
           Desc = 'Puedes seguir usando Win + Tab.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'ShowTaskViewButton' 0 } }
        @{ Name = 'Num Lock activado al encender'; On = $true
           Desc = 'El teclado numerico queda activo desde la pantalla de inicio de sesion.'
           Run  = {
               Set-Reg 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard' 'InitialKeyboardIndicators' '2' 'String'
               Set-Reg 'HKCU:\Control Panel\Keyboard' 'InitialKeyboardIndicators' '2' 'String'
           } }
        @{ Name = 'Desactivar Teclas especiales (Sticky Keys)'; On = $true
           Desc = 'Ya no sale el aviso al pulsar Shift 5 veces.'
           Run  = { Set-Reg 'HKCU:\Control Panel\Accessibility\StickyKeys' 'Flags' '58' 'String' } }
        @{ Name = 'Quitar el desenfoque de la pantalla de inicio de sesion'; On = $true
           Desc = 'El fondo se ve nitido al escribir la contrasena.'
           Run  = { Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'DisableAcrylicBackgroundOnLogon' 1 } }
        @{ Name = 'Ocultar la pagina Inicio de Configuracion'; On = $true
           Desc = 'Configuracion abre directo en Sistema.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' 'SettingsPageVisibility' 'hide:home' 'String' } }
        @{ Name = 'Porcentaje de bateria en la barra de tareas'; On = $true
           Desc = 'Muestra el numero junto al icono de bateria (solo laptops, en PC de escritorio no hace nada).'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'IsBatteryPercentageEnabled' 1 } }
        @{ Name = 'Finalizar tarea con clic derecho en la barra de tareas'; On = $true
           Desc = 'Cierra a la fuerza una app colgada sin abrir el Administrador de tareas.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' 'TaskbarEndTask' 1 } }
        @{ Name = 'Menu clasico del clic derecho'; On = $true
           Desc = 'Vuelve el menu completo de Windows 10, sin tener que pulsar "Mostrar mas opciones".'
           Run  = { New-Item -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Value '' -Force | Out-Null } }
        @{ Name = 'Quitar Widgets'; On = $true
           Desc = 'Quita el panel de noticias/clima de la barra de tareas (por directiva, sin desinstalar nada).'
           Run  = { Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' 'AllowNewsAndInterests' 0 } }
        @{ Name = 'No mostrar apps sugeridas de la Store al buscar'; On = $true
           Desc = 'La busqueda de Inicio deja de recomendar apps de la Microsoft Store.'
           Run  = {
               $db = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\store.db"
               if (Test-Path $db) { icacls $db /deny '*S-1-1-0:F' | Out-Null }
               else { Write-Host '   (la Store aun no se ha abierto en esta PC; vuelve a aplicarlo despues)' -ForegroundColor DarkYellow }
           } }
        @{ Name = 'Desactivar el historial de actividad'; On = $true
           Desc = 'Windows deja de guardar y subir lo que haces. El historial del portapapeles sigue funcionando.'
           Run  = {
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'EnableActivityFeed' 1
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'PublishUserActivities' 0
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'UploadUserActivities' 0
           } }
        @{ Name = 'No instalar apps promocionadas'; On = $true
           Desc = 'Evita que Windows instale solo juegos y apps sugeridas (Candy Crush, etc.).'
           Run  = { Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableWindowsConsumerFeatures' 1 } }
        @{ Name = 'Quitar Inicio y Galeria del Explorador'; On = $true
           Desc = 'El Explorador abre en "Este equipo".'
           Run  = {
               Set-Reg 'HKCU:\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}' 'System.IsPinnedToNameSpaceTree' 0
               Set-Reg 'HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' 'System.IsPinnedToNameSpaceTree' 0
               Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'LaunchTo' 1
           } }
        @{ Name = 'Desactivar la hibernacion'; On = $true
           Desc = 'Libera varios GB en el disco. En laptops quiza prefieras dejarla.'
           Run  = {
               powercfg.exe /hibernate off
               Set-Reg 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' 'ShowHibernateOption' 0
           } }
        @{ Name = 'Barras de desplazamiento siempre visibles'; On = $false
           Desc = 'Windows 11 esconde las barras de desplazamiento hasta que pasas el mouse. Esto las deja siempre a la vista.'
           Run  = { Set-Reg 'HKCU:\Control Panel\Accessibility' 'DynamicScrollbars' 0 } }
    )

    # ======================================================================
    #  Permisos de administrador
    # ======================================================================
    $principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host 'Pidiendo permisos de administrador...' -ForegroundColor Yellow
        $exe = if ($PSVersionTable.PSEdition -eq 'Core') { 'pwsh' } else { 'powershell' }
        $run = if ($PSCommandPath) { "-File `"$PSCommandPath`"" } else { "-Command `"irm '$ScriptUrl' | iex`"" }
        Start-Process $exe -Verb RunAs -ArgumentList "-NoProfile -NoExit -ExecutionPolicy Bypass $run"
        return
    }

    # ======================================================================
    #  Ventana con casillas
    # ======================================================================
    Add-Type -AssemblyName PresentationFramework

    $xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Mi Setup" Width="920" Height="680" WindowStartupLocation="CenterScreen"
        Background="#1E1E1E" Foreground="#EEEEEE" FontFamily="Segoe UI" FontSize="13">
  <Window.Resources>
    <Style TargetType="CheckBox">
      <Setter Property="Foreground" Value="#EEEEEE"/>
      <Setter Property="Margin" Value="0,4,0,4"/>
    </Style>
    <Style TargetType="Button">
      <Setter Property="Padding" Value="18,6"/>
      <Setter Property="Margin" Value="8,0,0,0"/>
    </Style>
  </Window.Resources>
  <DockPanel Margin="12">
    <StackPanel DockPanel.Dock="Bottom" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,12,0,0">
      <Button x:Name="BtnInstall" Content="Instalar lo marcado" IsDefault="True"/>
      <Button Content="Cancelar" IsCancel="True"/>
    </StackPanel>
    <TabControl Background="#252526" BorderBrush="#3C3C3C">
      <TabItem Header="  Apps  ">
        <ScrollViewer VerticalScrollBarVisibility="Auto" Background="#252526">
          <StackPanel x:Name="AppsPanel" Margin="12"/>
        </ScrollViewer>
      </TabItem>
      <TabItem Header="  Ajustes  ">
        <ScrollViewer VerticalScrollBarVisibility="Auto" Background="#252526">
          <StackPanel x:Name="TweaksPanel" Margin="12"/>
        </ScrollViewer>
      </TabItem>
    </TabControl>
  </DockPanel>
</Window>
'@
    $win = [System.Windows.Markup.XamlReader]::Parse($xaml)
    $appsPanel   = $win.FindName('AppsPanel')
    $tweaksPanel = $win.FindName('TweaksPanel')

    # Apps agrupadas por categoria; la casilla de la categoria marca/desmarca todas
    $appBoxes = @()
    foreach ($group in ($Apps | Group-Object { $_.Cat })) {
        $header = New-Object System.Windows.Controls.CheckBox
        $header.Content    = $group.Name
        $header.FontWeight = 'Bold'
        $header.FontSize   = 15
        $header.Margin     = '0,12,0,4'
        $header.IsChecked  = -not ($group.Group | Where-Object { -not $_.On })

        $wrap = New-Object System.Windows.Controls.WrapPanel
        $wrap.Margin = '22,0,0,0'
        foreach ($app in $group.Group) {
            $cb = New-Object System.Windows.Controls.CheckBox
            $cb.Content   = $app.Name
            $cb.IsChecked = $app.On
            $cb.Width     = 210
            $cb.ToolTip   = $app.Id
            $cb.Tag       = $app
            $wrap.Children.Add($cb) | Out-Null
            $appBoxes += $cb
        }
        $header.Tag = $wrap
        $header.Add_Click({ foreach ($c in $this.Tag.Children) { $c.IsChecked = $this.IsChecked } })

        $appsPanel.Children.Add($header) | Out-Null
        $appsPanel.Children.Add($wrap)   | Out-Null
    }

    $tweakBoxes = @()
    foreach ($t in $Tweaks) {
        $cb = New-Object System.Windows.Controls.CheckBox
        $cb.IsChecked = $t.On
        $cb.Tag       = $t
        $text = New-Object System.Windows.Controls.TextBlock
        $text.TextWrapping = 'Wrap'
        $text.Inlines.Add((New-Object System.Windows.Documents.Bold (New-Object System.Windows.Documents.Run $t.Name)))
        $desc = New-Object System.Windows.Documents.Run ("`n" + $t.Desc)
        $desc.Foreground = '#9E9E9E'
        $text.Inlines.Add($desc)
        $cb.Content = $text
        $cb.Margin  = '0,6,0,6'
        $tweaksPanel.Children.Add($cb) | Out-Null
        $tweakBoxes += $cb
    }

    $win.FindName('BtnInstall').Add_Click({
        $w = [System.Windows.Window]::GetWindow($this)
        $w.DialogResult = $true
    })

    if (-not $win.ShowDialog()) {
        Write-Host 'Cancelado.' -ForegroundColor Yellow
        return
    }

    $selApps   = @($appBoxes   | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })
    $selTweaks = @($tweakBoxes | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })

    # ======================================================================
    #  Instalar apps
    # ======================================================================
    $failed = @()
    if ($selApps.Count -gt 0) {
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Host 'Activando winget...' -ForegroundColor Yellow
            Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction SilentlyContinue
        }
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Host 'No se encontro winget. Abre la Microsoft Store, actualiza "Instalador de aplicacion" y vuelve a ejecutar.' -ForegroundColor Red
            return
        }

        $i = 0
        foreach ($app in $selApps) {
            $i++
            Write-Host ''
            Write-Host "[$i/$($selApps.Count)] $($app.Name)" -ForegroundColor Cyan
            winget install --id $app.Id --exact --source winget --silent `
                --accept-package-agreements --accept-source-agreements --disable-interactivity
            switch ($LASTEXITCODE) {
                0           { Write-Host '   Instalada' -ForegroundColor Green }
                3010        { Write-Host '   Instalada (pide reiniciar)' -ForegroundColor Green }
                -1978335189 { Write-Host '   Ya estaba instalada y al dia' -ForegroundColor DarkGray }
                -1978335135 { Write-Host '   Ya estaba instalada' -ForegroundColor DarkGray }
                default     { Write-Host "   Fallo (codigo $LASTEXITCODE)" -ForegroundColor Red; $failed += $app.Name }
            }
        }
    }

    # ======================================================================
    #  Aplicar ajustes
    # ======================================================================
    if ($selTweaks.Count -gt 0) {
        Write-Host ''
        Write-Host 'Aplicando ajustes...' -ForegroundColor Cyan
        foreach ($t in $selTweaks) {
            try {
                & $t.Run
                Write-Host "   OK  $($t.Name)" -ForegroundColor Green
            } catch {
                Write-Host "   ERROR  $($t.Name): $($_.Exception.Message)" -ForegroundColor Red
                $failed += $t.Name
            }
        }

        # Reiniciar el Explorador para que se vean los cambios
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer }
    }

    Write-Host ''
    if ($failed.Count -gt 0) {
        Write-Host "Termino con errores en: $($failed -join ', ')" -ForegroundColor Yellow
    } else {
        Write-Host 'Listo. Reinicia la PC para que todos los ajustes queden aplicados.' -ForegroundColor Green
    }
}

Start-MiSetup
