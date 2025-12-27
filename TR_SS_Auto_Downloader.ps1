Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ReleaseCapture();
    [DllImport("user32.dll")]
    public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);
}
"@

function Set-Rounded($Control, $Radius) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $rect = New-Object System.Drawing.Rectangle(0,0,$Control.Width,$Control.Height)
    $d = $Radius * 2
    $path.AddArc($rect.X, $rect.Y, $d, $d, 180, 90)
    $path.AddArc($rect.Right - $d, $rect.Y, $d, $d, 270, 90)
    $path.AddArc($rect.Right - $d, $rect.Bottom - $d, $d, $d, 0, 90)
    $path.AddArc($rect.X, $rect.Bottom - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $Control.Region = New-Object System.Drawing.Region($path)
}

$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(760,480)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(16,16,22)
$form.ShowInTaskbar = $true

$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 48
$header.BackColor = [System.Drawing.Color]::FromArgb(24,24,34)
$form.Controls.Add($header)

$header.Add_MouseDown({
    [Win32]::ReleaseCapture() | Out-Null
    [Win32]::SendMessage($form.Handle,0xA1,0x2,0)
})

$title = New-Object System.Windows.Forms.Label
$title.Text = "TR SS Auto Downloader"
$title.Location = New-Object System.Drawing.Point(20, 0)
$title.Size = New-Object System.Drawing.Size(300, 48)
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold",16)
$title.ForeColor = [System.Drawing.Color]::FromArgb(180,120,255)
$title.TextAlign = "MiddleLeft"
$header.Controls.Add($title)

function New-WindowButton($iconChar, $hoverColor, $action) {
    $btn = New-Object System.Windows.Forms.Panel
    $btn.Size = New-Object System.Drawing.Size(50,34)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(40,40,55)
    $btn.Cursor = "Hand"
    $btn.Tag = $hoverColor

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $iconChar
    $lbl.Dock = "Fill"
    $lbl.Font = New-Object System.Drawing.Font("Segoe MDL2 Assets", 13)
    $lbl.ForeColor = [System.Drawing.Color]::White
    $lbl.TextAlign = "MiddleCenter"
    $lbl.Enabled = $false
    $btn.Controls.Add($lbl)

    $btn.Add_MouseEnter({ $this.BackColor = $this.Tag })
    $btn.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(40,40,55) })
    $btn.Add_Click($action)
    $header.Controls.Add($btn)
    return $btn
}

$btnClose = New-WindowButton ([char]0xE106) ([System.Drawing.Color]::FromArgb(200,60,60)) { $form.Close() }
$btnMin   = New-WindowButton ([char]0xE949) ([System.Drawing.Color]::FromArgb(120,70,200)) { $form.WindowState = "Minimized" }

$buttons = @()

function New-PurpleButton($text, $top, $action) {
    $btn = New-Object System.Windows.Forms.Panel
    $btn.Size = New-Object System.Drawing.Size(360,48)
    $btn.Location = New-Object System.Drawing.Point(200,$top)
    $btn.Cursor = "Hand"
    $btn.Tag = @{
        Normal = [System.Drawing.Color]::FromArgb(34,34,48)
        Hover  = [System.Drawing.Color]::FromArgb(90,60,140)
    }
    $btn.BackColor = $btn.Tag.Normal

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Dock = "Fill"
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI Semibold",11)
    $lbl.ForeColor = [System.Drawing.Color]::FromArgb(210,170,255)
    $lbl.TextAlign = "MiddleCenter"
    $lbl.Enabled = $false
    $btn.Controls.Add($lbl)

    $btn.Add_MouseEnter({ $this.BackColor = $this.Tag.Hover })
    $btn.Add_MouseLeave({ $this.BackColor = $this.Tag.Normal })
    if ($action) { $btn.Add_Click($action) }

    $form.Controls.Add($btn)
    $script:buttons += $btn
    return $btn
}

New-PurpleButton "TR SS Tools" 120 {
    $dosyalar = @(
        @{ Url = "https://www.nirsoft.net/utils/winprefetchview-x64.zip"; Ad = "WinPrefetchView_x64.zip" }
        @{ Url = "https://dl.echo.ac/tool/journal"; Ad = "Journal.exe" }
        @{ Url = "https://github.com/winsiderss/si-builds/releases/download/3.2.25275.112/systeminformer-build-canary-setup.exe"; Ad = "SystemInformer_Canary_Setup.exe" }
        @{ Url = "https://www.nirsoft.net/utils/lastactivityview.zip"; Ad = "LastActivityView.zip" }
        @{ Url = "https://www.nirsoft.net/utils/usbdrivelog.zip"; Ad = "UsbDriveLog.zip" }
        @{ Url = "https://github.com/NotRequiem/InjGen/releases/download/v2.0/InjGen.exe"; Ad = "InjGen.exe" }
        @{ Url = "https://github.com/deathmarine/Luyten/releases/download/v0.5.4_Rebuilt_with_Latest_depenencies/luyten-0.5.4.exe"; Ad = "Luyten.exe" }
        @{ Url = "https://download.ericzimmermanstools.com/net9/TimelineExplorer.zip"; Ad = "TimelineExplorer.zip" }
        @{ Url = "https://www.nirsoft.net/utils/windeflogview.zip"; Ad = "WinDefLogView.zip" }
        @{ Url = "https://www.nirsoft.net/utils/shellbagsview.zip"; Ad = "ShellBagsView.zip" }
        @{ Url = "https://www.nirsoft.net/utils/uninstallview-x64.zip"; Ad = "UninstallView_x64.zip" }
        @{ Url = "https://www.nirsoft.net/utils/loadeddllsview-x64.zip"; Ad = "LoadedDllsView_x64.zip" }
        @{ Url = "https://dl.echo.ac/tool/userassist"; Ad = "UserAssist.exe" }
        @{ Url = "https://www.nirsoft.net/utils/jumplistsview.zip"; Ad = "JumpListsView.zip" }
        @{ Url = "https://download.ericzimmermanstools.com/SrumECmd.zip"; Ad = "SrumECmd.zip" }
        @{ Url = "https://download.ericzimmermanstools.com/AmcacheParser.zip"; Ad = "AmcacheParser.zip" }
        @{ Url = "https://download.ericzimmermanstools.com/net6/WxTCmd.zip"; Ad = "WxTCmd.zip" }
        @{ Url = "https://github.com/spokwn/BAM-parser/releases/download/v1.2.9/BAMParser.exe"; Ad = "BAMParser.exe" }
        @{ Url = "https://github.com/spokwn/prefetch-parser/releases/download/v1.5.5/PrefetchParser.exe"; Ad = "PrefetchParser.exe" }
        @{ Url = "https://github.com/spokwn/process-parser/releases/download/v0.5.5/ProcessParser.exe"; Ad = "ProcessParser.exe" }
        @{ Url = "https://github.com/spokwn/pcasvc-executed/releases/download/v0.8.7/PcaSvcExecuted.exe"; Ad = "PcaSvcExecuted.exe" }
        @{ Url = "https://github.com/spokwn/JournalTrace/releases/download/1.2/JournalTraceNormal.exe"; Ad = "JournalTraceNormal.exe" }
        @{ Url = "https://github.com/nay-cat/dpsanalyzer/releases/download/1.3/dpsanalyzer.exe"; Ad = "dpsanalyzer.exe" }
        @{ Url = "https://go.magnetforensics.com/e/52162/MagnetEncryptedDiskDetector/kpt9bg/1663239667/h/LtXFtTL-Soawv5C1oL3BIEghi7e1Lx93yesZLR--Ok0"; Ad = "MagnetEncryptedDiskDetector.exe" }
        @{ Url = "https://github.com/RRancio/Exec/raw/main/Files/Unicode.exe"; Ad = "Unicode.exe" }
        @{ Url = "https://archive.org/download/access-data-ftk-imager-4.7.1/AccessData_FTK_Imager_4.7.1.exe"; Ad = "FTK_Imager_4.7.1.exe" }
        @{ Url = "https://github.com/ItzIceHere/RedLotus-Mod-Analyzer/releases/download/RL/RedLotusModAnalyzer.exe"; Ad = "RedLotusModAnalyzer.exe" }
        @{ Url = "https://github.com/nay-cat/Jarabel/releases/download/light/Jarabel.Light.exe"; Ad = "Jarabel.Light.exe" }
        @{ Url = "https://github.com/spokwn/PathsParser/releases/download/v1.2/PathsParser.exe"; Ad = "PathsParser.exe" }
        @{ Url = "https://github.com/trSScommunity/PathDuzenleyiciV2/raw/refs/heads/main/PathDuzenleyicisiV2.exe"; Ad = "PathDuzenleyicisiV2.exe" }
        @{ Url = "https://github.com/spokwn/KernelLiveDumpTool/releases/download/v1.1/KernelLiveDumpTool.exe"; Ad = "KernelLiveDumpTool.exe" }
        @{ Url = "https://github.com/horsicq/DIE-engine/releases/download/3.09/die_win64_portable_3.09_x64.zip"; Ad = "DIE_engine_portable.zip" }
        @{ Url = "https://github.com/spokwn/Tool/releases/download/v1.1.2/espouken.exe"; Ad = "espouken.exe" }
        @{ Url = "https://win.cleverfiles.com/disk-drill-win5-full.exe"; Ad = "DiskDrill_win5_full.exe" }
        @{ Url = "https://github.com/santiagolin/TimeChangeDetect/releases/download/1.0/TimeChangeDetect.exe"; Ad = "TimeChangeDetect.exe" }
        @{ Url = "https://go.magnetforensics.com/e/52162/mail-utm-campaign-UTMC-0000044/llr4bg/1663358653/h/4kZ9Y4i2yPRqBzuQMrywA_v5bfkpG3rG8gEiSWrYU70"; Ad = "Magnet_tool.html" }
        @{ Url = "https://github.com/ponei/CachedProgramsList/releases/download/1.1/CachedProgramsList.exe"; Ad = "CachedProgramsList.exe" }
        @{ Url = "https://github.com/Yamato-Security/hayabusa/releases/download/v3.6.0/hayabusa-3.6.0-win-aarch64.zip"; Ad = "hayabusa-3.6.0-win-aarch64.zip" }
        @{ Url = "https://dl.echo.ac/tool/usb"; Ad = "UsbTool.exe" }
        @{ Url = "https://www.voidtools.com/Everything-1.4.1.1029.x86-Setup.exe"; Ad = "Everything-Setup.exe" }
        @{ Url = "https://github.com/Velocidex/velociraptor/releases/download/v0.75/velociraptor-v0.75.1-windows-amd64.exe"; Ad = "Velociraptor.exe" }
        @{ Url = "https://github.com/spokwn/BamDeletedKeys/releases/download/v1.0/BamDeletedKeys.exe"; Ad = "BamDeletedKeys.exe" }
        @{ Url = "https://downloads.appsvoid.com/latest/stream-detector/setup"; Ad = "StreamDetector_Setup.exe" }
        @{ Url = "https://github.com/trSScommunity/MZHunter/raw/refs/heads/main/MzHunter.exe"; Ad = "MzHunter.exe" }
        @{ Url = "https://download.ericzimmermanstools.com/net9/RegistryExplorer.zip"; Ad = "RegistryExplorer.zip" }
        @{ Url = "https://download.ericzimmermanstools.com/net9/MFTECmd.zip"; Ad = "MFTECmd.zip" }
        @{ Url = "https://www.nirsoft.net/utils/clipboardic.zip"; Ad = "Clipboardic.zip" }
        @{ Url = "https://github.com/ItzIceHere/RedLotus-Task-Sentinel/releases/download/RL/RedLotusTaskSentinel.exe"; Ad = "RedLotusTaskSentinel.exe" }
    )

    $downloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $klasor = Join-Path $downloadsPath "ScreenShareTools"
    New-Item -ItemType Directory -Path $klasor -Force | Out-Null

    $progressForm = New-Object System.Windows.Forms.Form
    $progressForm.Size = New-Object System.Drawing.Size(520,200)
    $progressForm.StartPosition = "CenterScreen"
    $progressForm.FormBorderStyle = "None"
    $progressForm.BackColor = [System.Drawing.Color]::FromArgb(16,16,22)
    $progressForm.TopMost = $true

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "TR SS Tools indiriliyor..."
    $titleLabel.Location = New-Object System.Drawing.Point(20,20)
    $titleLabel.Size = New-Object System.Drawing.Size(480,35)
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold",15)
    $titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(180,120,255)
    $progressForm.Controls.Add($titleLabel)

    $currentLabel = New-Object System.Windows.Forms.Label
    $currentLabel.Text = "Başlatiliyor..."
    $currentLabel.Location = New-Object System.Drawing.Point(20,70)
    $currentLabel.Size = New-Object System.Drawing.Size(480,30)
    $currentLabel.Font = New-Object System.Drawing.Font("Segoe UI",11)
    $currentLabel.ForeColor = [System.Drawing.Color]::White
    $progressForm.Controls.Add($currentLabel)

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(20,120)
    $progressBar.Size = New-Object System.Drawing.Size(480,30)
    $progressBar.Maximum = $dosyalar.Count
    $progressBar.Value = 0
    $progressForm.Controls.Add($progressBar)

    Set-Rounded $progressForm 18
    Set-Rounded $progressBar 10

    $progressForm.Show()
    [System.Windows.Forms.Application]::DoEvents()

    $i = 0
    foreach ($dosya in $dosyalar) {
        $i++
        $kayitYolu = Join-Path $klasor $dosya.Ad
        $currentLabel.Text = "$($dosya.Ad) indiriliyor... ($i/$($dosyalar.Count))"
        $progressBar.Value = $i - 1
        [System.Windows.Forms.Application]::DoEvents()
        try {
            Invoke-WebRequest -Uri $dosya.Url -OutFile $kayitYolu -UseBasicParsing -TimeoutSec 120 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        } catch {}
        $progressBar.Value = $i
        [System.Windows.Forms.Application]::DoEvents()
    }

    $currentLabel.Text = "Tum dosyalar indirildi!"
    Start-Sleep -Seconds 1
    $progressForm.Close()
    Start-Process explorer.exe $klasor
}
<# 
Aşağıda, orijinal kodunuzun güncellenmiş hali var.
Yeni eklemeler:

İkinci buton ("OPTION 2") artık "TR SS PowerShell Scripts" olarak adlandırıldı ve tıklanınca belirtilen PowerShell scriptlerini indirip çalıştırıyor.
Scriptler, İndirilenler > ScreenShareTools > PSScripts klasörüne kaydediliyor.
Her script indirildikten sonra otomatik olarak powershell.exe -ExecutionPolicy Bypass -File "dosya_yolu" ile çalıştırılıyor.
İndirme ilerlemesi aynı progress penceresinde gösteriliyor.
#>

# === 2. BUTON: PowerShell Scriptleri ===
New-PurpleButton "TR SS PowerShell Scripts" 175 {
    $psScripts = @(
        @{ Url = "https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Drive-Executions.ps1"; Ad = "Drive-Executions.ps1" }
        @{ Url = "https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/Services.ps1"; Ad = "Services.ps1" }
        @{ Url = "https://raw.githubusercontent.com/spokwn/powershells/refs/heads/main/Streams.ps1"; Ad = "Streams.ps1" }
        @{ Url = "https://raw.githubusercontent.com/bacanoicua/Screenshare/main/RedLotusPrefetchIntegrityAnalyzer.ps1"; Ad = "RedLotusPrefetchIntegrityAnalyzer.ps1" }
        @{ Url = "https://raw.githubusercontent.com/trSScommunity/BaglantiAnalizi/refs/heads/main/BaglantiAnalizi.ps1"; Ad = "BaglantiAnalizi.ps1" }
        @{ Url = "https://raw.githubusercontent.com/praiselily/lilith-ps/refs/heads/main/DoomsdayFinder.ps1"; Ad = "DoomsdayFinder.ps1" }
    )

    $downloadsPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $klasor = Join-Path $downloadsPath "ScreenShareTools\PSScripts"
    New-Item -ItemType Directory -Path $klasor -Force | Out-Null

    $progressForm = New-Object System.Windows.Forms.Form
    $progressForm.Size = New-Object System.Drawing.Size(520,200)
    $progressForm.StartPosition = "CenterScreen"
    $progressForm.FormBorderStyle = "None"
    $progressForm.BackColor = [System.Drawing.Color]::FromArgb(16,16,22)
    $progressForm.TopMost = $true

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "TR SS PowerShell Scripts indiriliyor ve çalıştırılıyor..."
    $titleLabel.Location = New-Object System.Drawing.Point(20,20)
    $titleLabel.Size = New-Object System.Drawing.Size(480,35)
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold",15)
    $titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(180,120,255)
    $progressForm.Controls.Add($titleLabel)

    $currentLabel = New-Object System.Windows.Forms.Label
    $currentLabel.Text = "Başlatılıyor..."
    $currentLabel.Location = New-Object System.Drawing.Point(20,70)
    $currentLabel.Size = New-Object System.Drawing.Size(480,30)
    $currentLabel.Font = New-Object System.Drawing.Font("Segoe UI",11)
    $currentLabel.ForeColor = [System.Drawing.Color]::White
    $progressForm.Controls.Add($currentLabel)

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(20,120)
    $progressBar.Size = New-Object System.Drawing.Size(480,30)
    $progressBar.Maximum = $psScripts.Count
    $progressBar.Value = 0
    $progressForm.Controls.Add($progressBar)

    Set-Rounded $progressForm 18
    Set-Rounded $progressBar 10

    $progressForm.Show()
    [System.Windows.Forms.Application]::DoEvents()

    $i = 0
    foreach ($script in $psScripts) {
        $i++
        $kayitYolu = Join-Path $klasor $script.Ad
        $currentLabel.Text = "$($script.Ad) indiriliyor ve çalıştırılıyor... ($i/$($psScripts.Count))"
        $progressBar.Value = $i - 1
        [System.Windows.Forms.Application]::DoEvents()

        try {
            Invoke-WebRequest -Uri $script.Url -OutFile $kayitYolu -UseBasicParsing -TimeoutSec 60 -UserAgent "Mozilla/5.0"
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$kayitYolu`""
        } catch {
            $currentLabel.Text = "$($script.Ad) indirilemedi veya çalıştırılamadı!"
            Start-Sleep -Seconds 2
        }

        $progressBar.Value = $i
        [System.Windows.Forms.Application]::DoEvents()
    }

    $currentLabel.Text = "Tüm scriptler indirildi ve çalıştırıldı!"
    Start-Sleep -Seconds 2
    $progressForm.Close()
    Start-Process explorer.exe $klasor
}

New-PurpleButton "Soon..." 230 $null
New-PurpleButton "Soon..." 285 $null
New-PurpleButton "Soon..." 340 $null

$form.Add_Shown({
    $btnClose.Location = New-Object System.Drawing.Point(($header.Width - 62), 7)
    $btnMin.Location = New-Object System.Drawing.Point(($header.Width - 120), 7)
    Set-Rounded $form 18
    Set-Rounded $btnClose 8
    Set-Rounded $btnMin 8
    foreach ($b in $buttons) {
        Set-Rounded $b 14
    }
})

[void]$form.ShowDialog()
# === FORM EVENTLERİ VE KAPATMA ===

# Form kapanırken kaynakları serbest bırak
$form.Add_FormClosing({
    foreach ($ctrl in $form.Controls) {
        $ctrl.Dispose()
    }
    $form.Dispose()
})

# Minimize butonuna tıklayınca
$btnMin.Add_Click({
    $form.WindowState = 'Minimized'
})

# Kapat butonuna tıklayınca
$btnClose.Add_Click({
    $form.Close()
})

# Header sürükleme
$dragging = $false
$offset = [System.Drawing.Point]::Empty

$header.Add_MouseDown({
    if ($_.Button -eq "Left") {
        $dragging = $true
        $offset = $_.Location
    }
})

$header.Add_MouseMove({
    if ($dragging) {
        $form.Location = [System.Drawing.Point]::new($_.X - $offset.X + $form.Location.X, $_.Y - $offset.Y + $form.Location.Y)
    }
})

$header.Add_MouseUp({
    $dragging = $false
})

# Form göster
[void]$form.ShowDialog()
