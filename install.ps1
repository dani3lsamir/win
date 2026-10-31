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

    Write-Host ''
    Write-Host '  ==========================' -ForegroundColor DarkMagenta
    Write-Host '       W I N   S E T U P' -ForegroundColor Magenta
    Write-Host '        by: dani3lsamir' -ForegroundColor DarkGray
    Write-Host '  ==========================' -ForegroundColor DarkMagenta
    Write-Host ''

    # ======================================================================
    #  Window
    # ======================================================================
    Add-Type -AssemblyName PresentationFramework

    $xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Win Setup" Width="1000" Height="740" MinWidth="780" MinHeight="520"
        WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="CanResize"
        Background="#141519" Foreground="#E6E6EA" FontFamily="Segoe UI" FontSize="13"
        UseLayoutRounding="True" TextOptions.TextFormattingMode="Display">
  <WindowChrome.WindowChrome>
    <WindowChrome CaptionHeight="72" ResizeBorderThickness="6" GlassFrameThickness="0" CornerRadius="0"/>
  </WindowChrome.WindowChrome>

  <Window.Resources>
    <SolidColorBrush x:Key="Accent" Color="#7C5CFF"/>
    <SolidColorBrush x:Key="Card"   Color="#1E1F26"/>
    <SolidColorBrush x:Key="Line"   Color="#2C2D37"/>
    <SolidColorBrush x:Key="Muted"  Color="#8B8D98"/>

    <!-- Checkbox: rounded box, violet when checked, dash when partially checked -->
    <Style TargetType="CheckBox">
      <Setter Property="Foreground" Value="#E6E6EA"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Margin" Value="0,5,0,5"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="CheckBox">
            <Grid Background="Transparent">
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
              </Grid.ColumnDefinitions>
              <Border x:Name="Box" Width="18" Height="18" CornerRadius="5" BorderThickness="1.5"
                      BorderBrush="#555764" Background="Transparent" VerticalAlignment="Top" Margin="0,1,0,0">
                <Grid>
                  <Path x:Name="Mark" Data="M 3 7.5 L 6.3 10.8 L 12 4.6" Stroke="White" StrokeThickness="2"
                        StrokeStartLineCap="Round" StrokeEndLineCap="Round" StrokeLineJoin="Round" Visibility="Collapsed"/>
                  <Rectangle x:Name="Dash" Width="8" Height="2" RadiusX="1" RadiusY="1" Fill="{StaticResource Accent}" Visibility="Collapsed"/>
                </Grid>
              </Border>
              <ContentPresenter Grid.Column="1" Margin="10,0,0,0" VerticalAlignment="Center"/>
            </Grid>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Box" Property="BorderBrush" Value="{StaticResource Accent}"/>
              </Trigger>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Box" Property="Background" Value="{StaticResource Accent}"/>
                <Setter TargetName="Box" Property="BorderBrush" Value="{StaticResource Accent}"/>
                <Setter TargetName="Mark" Property="Visibility" Value="Visible"/>
              </Trigger>
              <Trigger Property="IsChecked" Value="{x:Null}">
                <Setter TargetName="Box" Property="BorderBrush" Value="{StaticResource Accent}"/>
                <Setter TargetName="Dash" Property="Visibility" Value="Visible"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Buttons -->
    <Style x:Key="BtnBase" TargetType="Button">
      <Setter Property="Foreground" Value="#E6E6EA"/>
      <Setter Property="Background" Value="#262731"/>
      <Setter Property="Padding" Value="18,9"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="{TemplateBinding Background}" CornerRadius="8" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Opacity" Value="0.85"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False">
                <Setter TargetName="Bd" Property="Opacity" Value="0.35"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="Button" BasedOn="{StaticResource BtnBase}"/>
    <Style x:Key="Primary" TargetType="Button" BasedOn="{StaticResource BtnBase}">
      <Setter Property="Background" Value="{StaticResource Accent}"/>
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Padding" Value="22,9"/>
    </Style>
    <Style x:Key="Small" TargetType="Button" BasedOn="{StaticResource BtnBase}">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="{StaticResource Muted}"/>
      <Setter Property="Padding" Value="10,6"/>
      <Setter Property="Margin" Value="4,0,0,0"/>
      <Style.Triggers>
        <Trigger Property="IsMouseOver" Value="True">
          <Setter Property="Background" Value="#262731"/>
          <Setter Property="Foreground" Value="#E6E6EA"/>
        </Trigger>
      </Style.Triggers>
    </Style>
    <Style x:Key="Chrome" TargetType="Button" BasedOn="{StaticResource BtnBase}">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Foreground" Value="{StaticResource Muted}"/>
      <Setter Property="FontFamily" Value="Segoe MDL2 Assets"/>
      <Setter Property="FontSize" Value="10"/>
      <Setter Property="Width" Value="40"/>
      <Setter Property="Height" Value="32"/>
      <Setter Property="Padding" Value="0"/>
      <Setter Property="WindowChrome.IsHitTestVisibleInChrome" Value="True"/>
      <Style.Triggers>
        <Trigger Property="IsMouseOver" Value="True">
          <Setter Property="Background" Value="#262731"/>
          <Setter Property="Foreground" Value="White"/>
        </Trigger>
      </Style.Triggers>
    </Style>
    <Style x:Key="ChromeClose" TargetType="Button" BasedOn="{StaticResource Chrome}">
      <Style.Triggers>
        <Trigger Property="IsMouseOver" Value="True">
          <Setter Property="Background" Value="#E5484D"/>
          <Setter Property="Foreground" Value="White"/>
        </Trigger>
      </Style.Triggers>
    </Style>

    <!-- Tabs as pills -->
    <Style TargetType="TabControl">
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Padding" Value="0,14,0,0"/>
    </Style>
    <Style TargetType="TabItem">
      <Setter Property="Foreground" Value="{StaticResource Muted}"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="TabItem">
            <Border x:Name="Bd" Padding="18,8" Margin="0,0,6,0" CornerRadius="8" Background="Transparent">
              <ContentPresenter ContentSource="Header" TextElement.FontSize="14"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsSelected" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#262731"/>
                <Setter Property="Foreground" Value="White"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Slim dark scrollbar -->
    <Style TargetType="ScrollBar">
      <Setter Property="Width" Value="8"/>
      <Setter Property="MinWidth" Value="8"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ScrollBar">
            <Track x:Name="PART_Track" IsDirectionReversed="True">
              <Track.Thumb>
                <Thumb>
                  <Thumb.Template>
                    <ControlTemplate TargetType="Thumb">
                      <Border Background="#34353F" CornerRadius="4"/>
                    </ControlTemplate>
                  </Thumb.Template>
                </Thumb>
              </Track.Thumb>
            </Track>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Border BorderBrush="{StaticResource Line}" BorderThickness="1">
    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="72"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="Auto"/>
      </Grid.RowDefinitions>

      <!-- Header (also the draggable title bar) -->
      <Grid Grid.Row="0" Margin="24,0,8,0">
        <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
          <Border Width="40" Height="40" CornerRadius="10">
            <Border.Background>
              <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                <GradientStop Color="#9B7BFF" Offset="0"/>
                <GradientStop Color="#5B3FE0" Offset="1"/>
              </LinearGradientBrush>
            </Border.Background>
            <TextBlock Text="W" Foreground="White" FontSize="20" FontWeight="Bold"
                       HorizontalAlignment="Center" VerticalAlignment="Center"/>
          </Border>
          <StackPanel Margin="14,0,0,0" VerticalAlignment="Center">
            <TextBlock Text="Win Setup" FontSize="20" FontWeight="SemiBold" Foreground="White"/>
            <TextBlock x:Name="PcInfo" Foreground="{StaticResource Muted}" FontSize="12" Margin="0,1,0,0"/>
          </StackPanel>
        </StackPanel>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,8,0,0">
          <Button x:Name="BtnMin" Style="{StaticResource Chrome}" Content="&#xE921;"/>
          <Button x:Name="BtnClose" Style="{StaticResource ChromeClose}" Content="&#xE8BB;"/>
        </StackPanel>
      </Grid>

      <!-- Tabs -->
      <TabControl Grid.Row="1" Margin="24,0,24,0">
        <TabItem Header="Apps">
          <Grid>
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Margin="0,0,0,12">
              <Border Background="{StaticResource Card}" CornerRadius="8" BorderBrush="{StaticResource Line}"
                      BorderThickness="1" Width="300" HorizontalAlignment="Left">
                <Grid>
                  <TextBlock x:Name="SearchHint" Text="Search apps..." Foreground="#5F616C" Margin="12,0,0,0" VerticalAlignment="Center" IsHitTestVisible="False"/>
                  <TextBox x:Name="Search" Background="Transparent" BorderThickness="0" Foreground="#E6E6EA"
                           CaretBrush="White" Padding="9,8" VerticalContentAlignment="Center"/>
                </Grid>
              </Border>
              <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                <Button x:Name="AppsAll"  Style="{StaticResource Small}" Content="Select all"/>
                <Button x:Name="AppsNone" Style="{StaticResource Small}" Content="None"/>
              </StackPanel>
            </Grid>
            <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
              <StackPanel x:Name="AppsPanel" Margin="0,0,10,12"/>
            </ScrollViewer>
          </Grid>
        </TabItem>
        <TabItem Header="Settings">
          <Grid>
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Grid Margin="0,0,0,12">
              <TextBlock Text="Light tweaks only. Nothing gets uninstalled." Foreground="{StaticResource Muted}" VerticalAlignment="Center"/>
              <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                <Button x:Name="TweaksAll"  Style="{StaticResource Small}" Content="Select all"/>
                <Button x:Name="TweaksNone" Style="{StaticResource Small}" Content="None"/>
              </StackPanel>
            </Grid>
            <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
              <UniformGrid x:Name="TweaksPanel" Columns="2" Margin="0,0,10,12" VerticalAlignment="Top"/>
            </ScrollViewer>
          </Grid>
        </TabItem>
      </TabControl>

      <!-- Footer -->
      <Border Grid.Row="2" BorderBrush="{StaticResource Line}" BorderThickness="0,1,0,0" Padding="24,14">
        <Grid>
          <TextBlock x:Name="Credit" VerticalAlignment="Center" Cursor="Hand" ToolTip="github.com/dani3lsamir" Text="by: dani3lsamir">
            <TextBlock.Style>
              <Style TargetType="TextBlock">
                <Setter Property="Foreground" Value="#6E707B"/>
                <Style.Triggers>
                  <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Foreground" Value="#9B7BFF"/>
                    <Setter Property="TextDecorations" Value="Underline"/>
                  </Trigger>
                </Style.Triggers>
              </Style>
            </TextBlock.Style>
          </TextBlock>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
            <TextBlock x:Name="Count" Foreground="{StaticResource Muted}" VerticalAlignment="Center" Margin="0,0,16,0"/>
            <Button Content="Cancel" IsCancel="True" Margin="0,0,8,0"/>
            <Button x:Name="BtnInstall" Style="{StaticResource Primary}" Content="Install selected"/>
          </StackPanel>
        </Grid>
      </Border>
    </Grid>
  </Border>
</Window>
'@
    $win = [System.Windows.Markup.XamlReader]::Parse($xaml)

    # Everything the event handlers need lives in $ui
    $ui = @{
        AppBoxes   = New-Object System.Collections.Generic.List[object]
        TweakBoxes = New-Object System.Collections.Generic.List[object]
        Cards      = New-Object System.Collections.Generic.List[object]
    }
    foreach ($n in 'PcInfo', 'Search', 'SearchHint', 'AppsPanel', 'TweaksPanel', 'AppsAll', 'AppsNone',
                   'TweaksAll', 'TweaksNone', 'Credit', 'Count', 'BtnInstall', 'BtnMin', 'BtnClose') {
        $ui[$n] = $win.FindName($n)
    }

    $os = (Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue).Caption -replace '^Microsoft\s+', ''
    $ui.PcInfo.Text = "$env:COMPUTERNAME  -  $os"

    # Updates the per-category counters, the category checkboxes and the footer total
    $ui.Refresh = {
        foreach ($card in $ui.Cards) {
            $kids = @($card.Wrap.Children)
            $on = @($kids | Where-Object { $_.IsChecked }).Count
            $card.Count.Text = "$on/$($kids.Count)"
            if ($on -eq $kids.Count) { $card.Header.IsChecked = $true }
            elseif ($on -eq 0)      { $card.Header.IsChecked = $false }
            else                    { $card.Header.IsChecked = $null }
        }
        $a = @($ui.AppBoxes   | Where-Object { $_.IsChecked }).Count
        $t = @($ui.TweakBoxes | Where-Object { $_.IsChecked }).Count
        $ui.Count.Text = "$a apps  /  $t settings"
        $ui.BtnInstall.IsEnabled = ($a + $t) -gt 0
    }.GetNewClosure()
    $onChange = { & $ui.Refresh }.GetNewClosure()

    # One card per category; the category checkbox checks/unchecks all of its apps
    foreach ($group in ($Apps | Group-Object { $_.Cat })) {
        $card = New-Object System.Windows.Controls.Border
        $card.Background      = '#1E1F26'
        $card.CornerRadius    = '10'
        $card.Padding         = '16,12,16,10'
        $card.Margin          = '0,0,0,10'

        $headRow = New-Object System.Windows.Controls.DockPanel
        $count = New-Object System.Windows.Controls.TextBlock
        $count.Foreground = '#8B8D98'
        $count.VerticalAlignment = 'Center'
        [System.Windows.Controls.DockPanel]::SetDock($count, 'Right')
        $headRow.Children.Add($count) | Out-Null

        $header = New-Object System.Windows.Controls.CheckBox
        $header.Content    = $group.Name
        $header.FontWeight = 'SemiBold'
        $header.FontSize   = 15
        $headRow.Children.Add($header) | Out-Null

        $wrap = New-Object System.Windows.Controls.WrapPanel
        $wrap.Margin = '28,6,0,0'
        foreach ($app in $group.Group) {
            $cb = New-Object System.Windows.Controls.CheckBox
            $cb.Content   = $app.Name
            $cb.IsChecked = $app.On
            $cb.Width     = 210
            $cb.ToolTip   = $app.Id
            $cb.Tag       = $app
            $cb.Add_Checked($onChange)
            $cb.Add_Unchecked($onChange)
            $wrap.Children.Add($cb) | Out-Null
            $ui.AppBoxes.Add($cb)
        }
        $header.Tag = $wrap
        $header.Add_Click({
            $value = [bool]$this.IsChecked
            foreach ($c in $this.Tag.Children) { if ($c.Visibility -eq 'Visible') { $c.IsChecked = $value } }
        })

        $stack = New-Object System.Windows.Controls.StackPanel
        $stack.Children.Add($headRow) | Out-Null
        $stack.Children.Add($wrap)    | Out-Null
        $card.Child = $stack
        $ui.AppsPanel.Children.Add($card) | Out-Null
        $ui.Cards.Add(@{ Border = $card; Header = $header; Wrap = $wrap; Count = $count })
    }

    # One small card per setting, in two columns
    foreach ($t in $Tweaks) {
        $cb = New-Object System.Windows.Controls.CheckBox
        $cb.IsChecked = $t.On
        $cb.Tag       = $t
        $cb.Margin    = '0'
        $text = New-Object System.Windows.Controls.TextBlock
        $text.TextWrapping = 'Wrap'
        $title = New-Object System.Windows.Documents.Run $t.Name
        $title.FontWeight = 'SemiBold'
        $text.Inlines.Add($title)
        $desc = New-Object System.Windows.Documents.Run ("`n" + $t.Desc)
        $desc.Foreground = '#8B8D98'
        $desc.FontSize   = 12
        $text.Inlines.Add($desc)
        $cb.Content = $text
        $cb.Add_Checked($onChange)
        $cb.Add_Unchecked($onChange)

        $card = New-Object System.Windows.Controls.Border
        $card.Background   = '#1E1F26'
        $card.CornerRadius = '10'
        $card.Padding      = '14,12'
        $card.Margin       = '0,0,10,10'
        $card.Child = $cb
        $ui.TweaksPanel.Children.Add($card) | Out-Null
        $ui.TweakBoxes.Add($cb)
    }

    # Search filters the app list by name or winget id
    $ui.Search.Add_TextChanged({
        $q = $ui.Search.Text.Trim()
        $ui.SearchHint.Visibility = if ($q) { 'Collapsed' } else { 'Visible' }
        foreach ($card in $ui.Cards) {
            $any = $false
            foreach ($c in $card.Wrap.Children) {
                $show = (-not $q) -or
                        $c.Tag.Name.IndexOf($q, [StringComparison]::OrdinalIgnoreCase) -ge 0 -or
                        $c.Tag.Id.IndexOf($q, [StringComparison]::OrdinalIgnoreCase) -ge 0
                $c.Visibility = if ($show) { 'Visible' } else { 'Collapsed' }
                if ($show) { $any = $true }
            }
            $card.Border.Visibility = if ($any) { 'Visible' } else { 'Collapsed' }
        }
    }.GetNewClosure())

    $ui.AppsAll.Add_Click({ foreach ($c in $ui.AppBoxes) { if ($c.Visibility -eq 'Visible') { $c.IsChecked = $true } } }.GetNewClosure())
    $ui.AppsNone.Add_Click({ foreach ($c in $ui.AppBoxes) { if ($c.Visibility -eq 'Visible') { $c.IsChecked = $false } } }.GetNewClosure())
    $ui.TweaksAll.Add_Click({ foreach ($c in $ui.TweakBoxes) { $c.IsChecked = $true } }.GetNewClosure())
    $ui.TweaksNone.Add_Click({ foreach ($c in $ui.TweakBoxes) { $c.IsChecked = $false } }.GetNewClosure())

    $ui.Credit.Add_MouseLeftButtonUp({ Start-Process 'https://github.com/dani3lsamir' })
    $ui.BtnMin.Add_Click({
        $w = [System.Windows.Window]::GetWindow($this)
        $w.WindowState = 'Minimized'
    })
    $ui.BtnClose.Add_Click({
        $w = [System.Windows.Window]::GetWindow($this)
        $w.Close()
    })
    $ui.BtnInstall.Add_Click({
        $w = [System.Windows.Window]::GetWindow($this)
        $w.DialogResult = $true
    })

    & $ui.Refresh

    if (-not $win.ShowDialog()) {
        Write-Host 'Cancelled.' -ForegroundColor Yellow
        return
    }

    $selApps   = @($ui.AppBoxes   | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })
    $selTweaks = @($ui.TweakBoxes | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })

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
