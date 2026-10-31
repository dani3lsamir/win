# Win Setup - my apps and settings installer for Windows.
# by: dani3lsamir
#
# Usage (PowerShell):  irm dani3lsamir.github.io/win | iex

function Start-WinSetup {

    # Where this script is downloaded from (used to relaunch it as administrator).
    $ScriptUrl = 'https://dani3lsamir.github.io/win'

    # ======================================================================
    #  APPS
    #  Id = winget identifier (find it with: winget search name)
    #  On = $true if it is checked by default
    # ======================================================================
    $Apps = @(
        @{ Cat = 'AI & Notes';         Id = 'Anthropic.Claude';                Name = 'Claude';                  On = $true }
        @{ Cat = 'AI & Notes';         Id = 'OpenAI.ChatGPT';                  Name = 'ChatGPT';                 On = $true }
        @{ Cat = 'AI & Notes';         Id = 'Granola.Granola';                 Name = 'Granola';                 On = $true }
        @{ Cat = 'AI & Notes';         Id = 'cjpais.Handy';                    Name = 'Handy (speech to text)';  On = $true }
        @{ Cat = 'AI & Notes';         Id = 'Obsidian.Obsidian';               Name = 'Obsidian';                On = $true }

        @{ Cat = 'Utilities';          Id = '7zip.7zip';                       Name = '7-Zip';                   On = $true }
        @{ Cat = 'Utilities';          Id = 'RARLab.WinRAR';                   Name = 'WinRAR';                  On = $true }
        @{ Cat = 'Utilities';          Id = 'Ghisler.TotalCommander';          Name = 'Total Commander';         On = $true }
        @{ Cat = 'Utilities';          Id = 'LocalSend.LocalSend';             Name = 'LocalSend';               On = $true }
        @{ Cat = 'Utilities';          Id = 'Tailscale.Tailscale';             Name = 'Tailscale';               On = $true }
        @{ Cat = 'Utilities';          Id = 'ArtCraft.PdfCraft';               Name = 'PdfCraft';                On = $true }

        @{ Cat = 'Cloud';              Id = 'Google.GoogleDrive';              Name = 'Google Drive';            On = $true }
        @{ Cat = 'Cloud';              Id = 'Dropbox.Dropbox';                 Name = 'Dropbox';                 On = $true }
        @{ Cat = 'Cloud';              Id = 'Nextcloud.NextcloudDesktop';      Name = 'Nextcloud';               On = $true }

        @{ Cat = 'Media';              Id = 'VideoLAN.VLC';                    Name = 'VLC';                     On = $true }
        @{ Cat = 'Media';              Id = 'AIMP.AIMP';                       Name = 'AIMP';                    On = $true }
        @{ Cat = 'Media';              Id = 'OBSProject.OBSStudio';            Name = 'OBS Studio';              On = $true }
        @{ Cat = 'Media';              Id = 'FlorianHeidenreich.Mp3tag';       Name = 'Mp3tag';                  On = $true }

        @{ Cat = 'Development';        Id = 'Git.Git';                         Name = 'Git';                     On = $true }
        @{ Cat = 'Development';        Id = 'OpenJS.NodeJS';                   Name = 'Node.js';                 On = $true }
        @{ Cat = 'Development';        Id = 'Python.Python.3.13';              Name = 'Python 3.13';             On = $true }
        @{ Cat = 'Development';        Id = 'Microsoft.PowerShell';            Name = 'PowerShell 7';            On = $true }
        @{ Cat = 'Development';        Id = 'Microsoft.OpenJDK.17';            Name = 'OpenJDK 17';              On = $true }
        @{ Cat = 'Development';        Id = 'Google.AndroidStudio';            Name = 'Android Studio';          On = $true }
        @{ Cat = 'Development';        Id = 'Google.PlatformTools';            Name = 'Android Platform Tools';  On = $true }

        @{ Cat = 'Epson Printer';      Id = 'EPSON.EpsonScan2';                Name = 'Epson Scan 2';            On = $false }
        @{ Cat = 'Epson Printer';      Id = 'EPSON.ScanSmart';                 Name = 'Epson ScanSmart';         On = $false }
        @{ Cat = 'Epson Printer';      Id = 'EPSON.EventManager';              Name = 'Epson Event Manager';     On = $false }
        @{ Cat = 'Epson Printer';      Id = 'EPSON.EpsonNetPrint';             Name = 'Epson Net Print';         On = $false }
        @{ Cat = 'Epson Printer';      Id = 'EPSON.Scan.OCRComponent';         Name = 'Epson Scan OCR';          On = $false }
        @{ Cat = 'Epson Printer';      Id = 'EPSON.Scan.PDFExtensions';        Name = 'Epson Scan PDF';          On = $false }

        @{ Cat = 'Runtimes';           Id = 'Microsoft.VCRedist.2015+.x64';    Name = 'VC++ 2015+ x64';          On = $true }
        @{ Cat = 'Runtimes';           Id = 'Microsoft.VCRedist.2015+.x86';    Name = 'VC++ 2015+ x86';          On = $true }
        @{ Cat = 'Runtimes';           Id = 'Microsoft.VCRedist.2010.x64';     Name = 'VC++ 2010 x64';           On = $false }
        @{ Cat = 'Runtimes';           Id = 'Microsoft.VCRedist.2010.x86';     Name = 'VC++ 2010 x86';           On = $false }
        @{ Cat = 'Runtimes';           Id = 'Microsoft.DotNet.DesktopRuntime.8'; Name = '.NET Desktop 8';        On = $false }
        @{ Cat = 'Runtimes';           Id = 'Microsoft.DotNet.DesktopRuntime.9'; Name = '.NET Desktop 9';        On = $false }
        @{ Cat = 'Runtimes';           Id = 'Microsoft.DotNet.Runtime.8';      Name = '.NET Runtime 8';          On = $false }
        @{ Cat = 'Runtimes';           Id = 'Microsoft.DotNet.AspNetCore.8';   Name = 'ASP.NET Core 8';          On = $false }
    )

    # ======================================================================
    #  SETTINGS (based on Chris Titus' winutil tweaks)
    # ======================================================================
    function Set-Reg($Path, $Name, $Value, $Type = 'DWord') {
        if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
    }

    $Tweaks = @(
        @{ Name = 'Dark mode'; On = $true
           Desc = 'Dark theme for Windows and apps.'
           Run  = {
               Set-Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'AppsUseLightTheme' 0
               Set-Reg 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' 'SystemUsesLightTheme' 0
           } }
        @{ Name = 'Show file extensions'; On = $true
           Desc = 'Shows .exe, .png, .pdf, etc. in File Explorer.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'HideFileExt' 0 } }
        @{ Name = 'Remove Bing from Start search'; On = $true
           Desc = 'Start menu search only looks on your PC, no web results.'
           Run  = {
               Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'BingSearchEnabled' 0
               Set-Reg 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' 'DisableSearchBoxSuggestions' 1
           } }
        @{ Name = 'Remove Start menu recommendations'; On = $true
           Desc = 'Hides the Recommended section. Note: this also disables Windows Spotlight.'
           Run  = {
               Set-Reg 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start' 'HideRecommendedSection' 1
               Set-Reg 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Education' 'IsEducationEnvironment' 1
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' 'HideRecommendedSection' 1
           } }
        @{ Name = 'Left-aligned taskbar icons'; On = $true
           Desc = 'Like Windows 10, instead of centered.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'TaskbarAl' 0 } }
        @{ Name = 'Hide taskbar search button'; On = $true
           Desc = 'You can still search by pressing the Windows key and typing.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'SearchboxTaskbarMode' 0 } }
        @{ Name = 'Hide Task View button'; On = $true
           Desc = 'You can still use Win + Tab.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'ShowTaskViewButton' 0 } }
        @{ Name = 'Num Lock on at startup'; On = $true
           Desc = 'The numeric keypad is active from the sign-in screen.'
           Run  = {
               Set-Reg 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard' 'InitialKeyboardIndicators' '2' 'String'
               Set-Reg 'HKCU:\Control Panel\Keyboard' 'InitialKeyboardIndicators' '2' 'String'
           } }
        @{ Name = 'Disable Sticky Keys'; On = $true
           Desc = 'No more popup after pressing Shift 5 times.'
           Run  = { Set-Reg 'HKCU:\Control Panel\Accessibility\StickyKeys' 'Flags' '58' 'String' } }
        @{ Name = 'Remove sign-in screen blur'; On = $true
           Desc = 'The background stays sharp while you type your password.'
           Run  = { Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'DisableAcrylicBackgroundOnLogon' 1 } }
        @{ Name = 'Hide Settings Home page'; On = $true
           Desc = 'Settings opens straight to System.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' 'SettingsPageVisibility' 'hide:home' 'String' } }
        @{ Name = 'Battery percentage on the taskbar'; On = $true
           Desc = 'Shows the number next to the battery icon (laptops only, does nothing on desktops).'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'IsBatteryPercentageEnabled' 1 } }
        @{ Name = 'End Task on taskbar right-click'; On = $true
           Desc = 'Force-close a frozen app without opening Task Manager.'
           Run  = { Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' 'TaskbarEndTask' 1 } }
        @{ Name = 'Classic right-click menu'; On = $true
           Desc = 'Brings back the full Windows 10 menu, no need to click "Show more options".'
           Run  = { New-Item -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Value '' -Force | Out-Null } }
        @{ Name = 'Remove Widgets'; On = $true
           Desc = 'Removes the news/weather panel from the taskbar (via policy, nothing is uninstalled).'
           Run  = { Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Dsh' 'AllowNewsAndInterests' 0 } }
        @{ Name = 'No Store app suggestions in search'; On = $true
           Desc = 'Start search stops recommending Microsoft Store apps.'
           Run  = {
               $db = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\store.db"
               if (Test-Path $db) { icacls $db /deny '*S-1-1-0:F' | Out-Null }
               else { Write-Host '   (the Store has not been opened on this PC yet; run this again later)' -ForegroundColor DarkYellow }
           } }
        @{ Name = 'Disable Activity History'; On = $true
           Desc = 'Windows stops saving and uploading what you do. Clipboard history keeps working.'
           Run  = {
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'EnableActivityFeed' 1
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'PublishUserActivities' 0
               Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' 'UploadUserActivities' 0
           } }
        @{ Name = 'No promoted app installs'; On = $true
           Desc = 'Stops Windows from installing suggested games and apps on its own (Candy Crush, etc.).'
           Run  = { Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableWindowsConsumerFeatures' 1 } }
        @{ Name = 'Remove Home and Gallery from File Explorer'; On = $true
           Desc = 'File Explorer opens to "This PC".'
           Run  = {
               Set-Reg 'HKCU:\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}' 'System.IsPinnedToNameSpaceTree' 0
               Set-Reg 'HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' 'System.IsPinnedToNameSpaceTree' 0
               Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'LaunchTo' 1
           } }
        @{ Name = 'Disable hibernation'; On = $true
           Desc = 'Frees several GB of disk space. On laptops you may want to keep it.'
           Run  = {
               powercfg.exe /hibernate off
               Set-Reg 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings' 'ShowHibernateOption' 0
           } }
        @{ Name = 'Always show scrollbars'; On = $false
           Desc = 'Windows 11 hides scrollbars until you hover over them. This keeps them always visible.'
           Run  = { Set-Reg 'HKCU:\Control Panel\Accessibility' 'DynamicScrollbars' 0 } }
    )

    # ======================================================================
    #  Administrator rights
    # ======================================================================
    $principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host 'Requesting administrator rights...' -ForegroundColor Yellow
        $exe = if ($PSVersionTable.PSEdition -eq 'Core') { 'pwsh' } else { 'powershell' }
        $run = if ($PSCommandPath) { "-File `"$PSCommandPath`"" } else { "-Command `"irm '$ScriptUrl' | iex`"" }
        Start-Process $exe -Verb RunAs -ArgumentList "-NoProfile -NoExit -ExecutionPolicy Bypass $run"
        return
    }

    # ======================================================================
    #  Window with checkboxes
    # ======================================================================
    Add-Type -AssemblyName PresentationFramework

    $xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Win Setup" Width="920" Height="680" WindowStartupLocation="CenterScreen"
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
    <DockPanel DockPanel.Dock="Bottom" Margin="0,12,0,0">
      <TextBlock x:Name="Credit" DockPanel.Dock="Left" VerticalAlignment="Center"
                 Foreground="#8A8A8A" Cursor="Hand" ToolTip="github.com/dani3lsamir">by: dani3lsamir</TextBlock>
      <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
        <Button x:Name="BtnInstall" Content="Install selected" IsDefault="True"/>
        <Button Content="Cancel" IsCancel="True"/>
      </StackPanel>
    </DockPanel>
    <TabControl Background="#252526" BorderBrush="#3C3C3C">
      <TabItem Header="  Apps  ">
        <ScrollViewer VerticalScrollBarVisibility="Auto" Background="#252526">
          <StackPanel x:Name="AppsPanel" Margin="12"/>
        </ScrollViewer>
      </TabItem>
      <TabItem Header="  Settings  ">
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

    # Apps grouped by category; the category checkbox checks/unchecks all of them
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

    $win.FindName('Credit').Add_MouseLeftButtonUp({ Start-Process 'https://github.com/dani3lsamir' })
    $win.FindName('BtnInstall').Add_Click({
        $w = [System.Windows.Window]::GetWindow($this)
        $w.DialogResult = $true
    })

    if (-not $win.ShowDialog()) {
        Write-Host 'Cancelled.' -ForegroundColor Yellow
        return
    }

    $selApps   = @($appBoxes   | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })
    $selTweaks = @($tweakBoxes | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })

    # ======================================================================
    #  Install apps
    # ======================================================================
    $failed = @()
    if ($selApps.Count -gt 0) {
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Host 'Enabling winget...' -ForegroundColor Yellow
            Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -ErrorAction SilentlyContinue
        }
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            Write-Host 'winget not found. Open the Microsoft Store, update "App Installer" and run this again.' -ForegroundColor Red
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
                0           { Write-Host '   Installed' -ForegroundColor Green }
                3010        { Write-Host '   Installed (restart required)' -ForegroundColor Green }
                -1978335189 { Write-Host '   Already installed and up to date' -ForegroundColor DarkGray }
                -1978335135 { Write-Host '   Already installed' -ForegroundColor DarkGray }
                default     { Write-Host "   Failed (code $LASTEXITCODE)" -ForegroundColor Red; $failed += $app.Name }
            }
        }
    }

    # ======================================================================
    #  Apply settings
    # ======================================================================
    if ($selTweaks.Count -gt 0) {
        Write-Host ''
        Write-Host 'Applying settings...' -ForegroundColor Cyan
        foreach ($t in $selTweaks) {
            try {
                & $t.Run
                Write-Host "   OK  $($t.Name)" -ForegroundColor Green
            } catch {
                Write-Host "   ERROR  $($t.Name): $($_.Exception.Message)" -ForegroundColor Red
                $failed += $t.Name
            }
        }

        # Restart File Explorer so the changes show up
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer }
    }

    Write-Host ''
    if ($failed.Count -gt 0) {
        Write-Host "Finished with errors in: $($failed -join ', ')" -ForegroundColor Yellow
    } else {
        Write-Host 'Done. Restart your PC so all settings take effect.' -ForegroundColor Green
    }
}

Start-WinSetup
