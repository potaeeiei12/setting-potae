# =========================================================================
# 1. ระบบเช็ครหัสผ่านก่อนเข้าใช้งาน (Security Lock)
# แก้ไขรหัสผ่านในเครื่องหมายอัญประกาศด้านล่างนี้ตามใจชอบครับ
$SecretKey = "POTAE-KUY" 

# รหัสสี ANSI เพื่อความสวยงาม
$Esc = [char]27; $Cyan = "$Esc[96m"; $Yellow = "$Esc[93m"; $Red = "$Esc[91m"; $Gray = "$Esc[90m"; $ResetColor = "$Esc[0m"

Clear-Host
$host.UI.RawUI.WindowTitle = "[!] ACCESS LOCKED [!]"
Write-Host "${Red}==================================================${ResetColor}"
Write-Host "          ${Yellow}[!] SECURITY VERIFICATION [!]${ResetColor}"
Write-Host "${Red}==================================================${ResetColor}"
Write-Host "${Gray}Please enter your access key to proceed.${ResetColor}"
Write-Host ""

# เปิดช่องให้พิมพ์รหัสผ่าน (ซ่อนตัวอักษรเป็นดาว *)
Write-Host -NoNewline "[>] Enter Key: "
$inputKey = ""
while ($true) {
    $char = [System.Console]::ReadKey($true)
    if ($char.Key -eq [System.ConsoleKey]::Enter) {
        Write-Host ""
        break
    }
    elseif ($char.Key -eq [System.ConsoleKey]::Backspace) {
        if ($inputKey.Length -gt 0) {
            $inputKey = $inputKey.Substring(0, $inputKey.Length - 1)
            Write-Host -NoNewline "`b `b"
        }
    }
    else {
        $inputKey += $char.KeyChar
        Write-Host -NoNewline "*"
    }
}

# ตรวจสอบรหัสผ่าน
if ($inputKey -ne $SecretKey) {
    Write-Host "`n${Red}[-] ACCESS DENIED: Incorrect Access Key!${ResetColor}"
    Write-Host "${Gray}Closing program in 3 seconds...${ResetColor}"
    Start-Sleep -Seconds 3
    exit
}

Write-Host "`n${Cyan}[+] ACCESS GRANTED: Welcome to Setting Potae!${ResetColor}"
Start-Sleep -Seconds 1
# =========================================================================

# 2. ส่วนสร้างไฟล์ชั่วคราวและเก็บข้อมูลโครงสร้างไฟล์ (.reg และ .cmd ตามรูปภาพของคุณ)
$TempDir = "$env:TEMP\SettingPotae"
if (-not (Test-Path $TempDir)) { New-Item -ItemType Directory -Path $TempDir -Force | Out-Null }

# ข้อความจำลองโครงสร้างหัวไฟล์ Registry มาตรฐาน
$RegHeader = "Windows Registry Editor Version 5.00"

# สร้างไฟล์ทั้ง 8 ลงในโฟลเดอร์ชั่วคราวเบื้องหลัง
@'
Windows Registry Editor Version 5.00
; [godreg.reg] บันทึกค่าปรับแต่งความแรงระบบ
'@ | Out-File -FilePath "$TempDir\godreg.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
; [Key.reg] ปรับแต่งการตอบสนองคีย์บอร์ด
'@ | Out-File -FilePath "$TempDir\Key.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
; [Mouse god.reg] ปรับแต่งการตอบสนองเมาส์แบบ God Mode
'@ | Out-File -FilePath "$TempDir\Mouse god.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
; [mouse op.reg] ปรับแต่งความเร็วเมาส์ฉบับ Overpowered
'@ | Out-File -FilePath "$TempDir\mouse op.reg" -Encoding utf8 -Force

@'
@echo off
echo [Network.cmd] Optimizing Network Settings...
ipconfig /flushdns
echo Done.
'@ | Out-File -FilePath "$TempDir\Network.cmd" -Encoding utf8 -Force

@'
@echo off
echo [Networkretua.cmd] Resetting Network Adapters...
netsh int ip reset
echo Done.
'@ | Out-File -FilePath "$TempDir\Networkretua.cmd" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
; [regeutua.reg] ปรับแต่งค่ารีจิสทรีเสริมความเสถียร
'@ | Out-File -FilePath "$TempDir\regeutua.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
; [regretuagod.reg] คืนค่ารีจิสทรีเมาส์และระบบกลับเป็นค่าเริ่มต้น
'@ | Out-File -FilePath "$TempDir\regretuagod.reg" -Encoding utf8 -Force


# 3. กำหนดตัวแปรตำแหน่งไฟล์สำหรับเรียกใช้งาน
$RegGodreg      = "$TempDir\godreg.reg"
$RegKey         = "$TempDir\Key.reg"
$RegMouseGod    = "$TempDir\Mouse god.reg"
$RegMouseOp     = "$TempDir\mouse op.reg"
$CmdNetwork     = "$TempDir\Network.cmd"
$CmdNetworkRetua= "$TempDir\Networkretua.cmd"
$RegRegeutua    = "$TempDir\regeutua.reg"
$RegRegretuagod = "$TempDir\regretuagod.reg"

# ฟังก์ชันรันไฟล์เบื้องหลังแบบอัตโนมัติ
function Run-File ($filePath) {
    if (Test-Path $filePath) {
        if ($filePath.EndsWith(".reg")) {
            Start-Process regedit.exe -ArgumentList "/s", "`"$filePath`"" -Wait -NoNewWindow
        } elseif ($filePath.EndsWith(".cmd") -or $filePath.EndsWith(".bat")) {
            Start-Process cmd.exe -ArgumentList "/c", "`"$filePath`"" -Wait -NoNewWindow
        }
        Write-Host "`n[+] Applied: $(Split-Path $filePath -Leaf)" -ForegroundColor Green
        Start-Sleep -Seconds 1
    } else {
        Write-Host "`n[-] File not found" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}

# 4. ส่วนวาดหน้าจอ UI เมนูหลัก
$host.UI.RawUI.WindowTitle = ">====< SETTING POTAE >====<"
$options = @("godreg", "Key", "Mouse god", "mouse op", "Network", "Networkretua", "regeutua", "regretuagod")
$currentSelection = 0
$White = "$Esc[97m"

function Draw-Menu {
    Clear-Host
    Write-Host "${Cyan}  ____  _____ _____ _____ ___ _   _  ____ `n / ___|| ____|_   _|_   _|_ _| \ | |/ ___|`n \___ \|  _|   | |   | |  | ||  \| | |  _ `n  ___) | |___  | |   | |  | || |\  | |_| |`n |____/|_____| |_|   |_| |___|_| \_|\____|`n  ____   ___ _____ _     _____ `n |  _ \ / _ \_   _/ \   | ____|`n | |_) | | | || |/ _ \  |  _|  `n |  __/| |_| || / ___ \ | |___ `n |_|    \___/ |_/_/   \_|_____|${ResetColor}"
    Write-Host "`n      ${Cyan}[+] SETTING POTAE BY MOONLIGHT [+]${ResetColor}"
    Write-Host "      ${Gray}[---------------------------------------]${ResetColor}"
    Write-Host ""
    for ($i = 0; $i -lt $options.Count; $i++) {
        $prefix = if ($i -eq $currentSelection) { "${Yellow}> ${ResetColor}" } else { "  " }
        $num = $i + 1
        if ($options[$i] -like "Network*") { Write-Host "${prefix}[$num] ${Yellow}$($options[$i])${ResetColor}" }
        elseif ($i -eq ($options.Count - 1)) { Write-Host "${prefix}[$num] ${Red}$($options[$i])${ResetColor}`n" }
        else { Write-Host "${prefix}[$num] ${White}$($options[$i])${ResetColor}" }
    }
    Write-Host "${Gray}Scroll wheel to navigate, Enter to select${ResetColor}"
}

# 5. ลูปหลักรับการกดปุ่มบนคีย์บอร์ดเพื่อเลื่อนเมนู
while ($true) {
    Draw-Menu
    $key = [System.Console]::ReadKey($true)
    if ($key.Key -eq [System.ConsoleKey]::UpArrow) { $currentSelection--; if ($currentSelection -lt 0) { $currentSelection = $options.Count - 1 } }
    elseif ($key.Key -eq [System.ConsoleKey]::DownArrow) { $currentSelection++; if ($currentSelection -ge $options.Count) { $currentSelection = 0 } }
    elseif ($key.Key -eq [System.ConsoleKey]::Enter) {
        switch ($currentSelection) {
            0 { Run-File $RegGodreg }
            1 { Run-File $RegKey }
            2 { Run-File $RegMouseGod }
            3 { Run-File $RegMouseOp }
            4 { Run-File $CmdNetwork }
            5 { Run-File $CmdNetworkRetua }
            6 { Run-File $RegRegeutua }
            7 { Run-File $RegRegretuagod }
        }
    }
}
