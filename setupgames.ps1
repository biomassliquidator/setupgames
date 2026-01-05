# ===== AUTO-DETECT SCRIPT LOCATION =====
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$IconPath  = Join-Path $ScriptDir "gamecontroller.ico"

# ===== TARGET FOLDER (User Profile Root) =====
$FolderPath = Join-Path $env:USERPROFILE "Games"

# ======================================

# 1. Create the folder if it doesn't exist
if (-not (Test-Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath -Force | Out-Null
}

# 2. Create desktop.ini to set the folder icon
$DesktopIniPath = Join-Path $FolderPath "desktop.ini"

$DesktopIniContent = @"
[.ShellClassInfo]
IconResource=$IconPath,0
"@

Set-Content -Path $DesktopIniPath -Value $DesktopIniContent -Encoding ASCII

# 3. Set required attributes
attrib +s "$FolderPath"
attrib +h "$DesktopIniPath"
attrib +s +h "$DesktopIniPath"

# 4. Pin folder to Quick Access
$shell  = New-Object -ComObject Shell.Application
$parent = $shell.Namespace((Split-Path $FolderPath))
$item   = $parent.ParseName((Split-Path $FolderPath -Leaf))

$item.InvokeVerb("pintohome")

# 5. Restart Explorer so icon applies immediately
Stop-Process -Name explorer -Force
Start-Process explorer
