# =========================================================================
# 1. ระบบเช็ครหัสผ่านก่อนเข้าใช้งาน (Security Lock)
# แก้ไขรหัสผ่านที่คุณต้องการในเครื่องหมายอัญประกาศด้านล่างนี้ได้เลยครับ
$SecretKey = "POTAE-KUY"

# รหัสสี ANSI
$Esc = [char]27; $Cyan = "$Esc[96m"; $Yellow = "$Esc[93m"; $Red = "$Esc[91m"; $Gray = "$Esc[90m"; $ResetColor = "$Esc[0m"

Clear-Host
$host.UI.RawUI.WindowTitle = "[!] ACCESS LOCKED [!]"
Write-Host "${Red}==================================================${ResetColor}"
Write-Host "          ${Yellow}[!] SECURITY VERIFICATION [!]${ResetColor}"
Write-Host "${Red}==================================================${ResetColor}"
Write-Host "${Gray}Please enter your access key to proceed.${ResetColor}"
Write-Host ""

Write-Host -NoNewline "[>] Enter Key: "
$inputKey = ""
while ($true) {
    $char = [System.Console]::ReadKey($true)
    if ($char.Key -eq [System.ConsoleKey]::Enter) { Write-Host ""; break }
    elseif ($char.Key -eq [System.ConsoleKey]::Backspace) {
        if ($inputKey.Length -gt 0) {
            $inputKey = $inputKey.Substring(0, $inputKey.Length - 1)
            Write-Host -NoNewline "`b `b"
        }
    }
    else { $inputKey += $char.KeyChar; Write-Host -NoNewline "*" }
}

if ($inputKey -ne $SecretKey) {
    Write-Host "`n${Red}[-] ACCESS DENIED: Incorrect Access Key!${ResetColor}"
    Write-Host "${Gray}Closing program in 3 seconds...${ResetColor}"
    Start-Sleep -Seconds 3
    exit
}
Write-Host "`n${Cyan}[+] ACCESS GRANTED: Welcome to Setting Potae!${ResetColor}"
Start-Sleep -Seconds 1
# =========================================================================


# =========================================================================
# 2. คลังยัดไส้สูตร (ให้คุณเปิดไฟล์จริงของคุณ แล้วก๊อปเนื้อหามาวางแทนที่ข้อความภาษาไทยด้านล่างนี้ให้ตรงข้อครับ)
$TempDir = "$env:TEMP\SettingPotae"
if (-not (Test-Path $TempDir)) { New-Item -ItemType Directory -Path $TempDir -Force | Out-Null }

@'
Windows Registry Editor Version 5.00
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ godreg.reg ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\godreg.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ Key.reg ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\Key.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ Mouse god.reg ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\Mouse god.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ mouse op.reg ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\mouse op.reg" -Encoding utf8 -Force

@'
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ Network.cmd ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\Network.cmd" -Encoding utf8 -Force

@'
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ Networkretua.cmd ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\Networkretua.cmd" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ regeutua.reg ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\regeutua.reg" -Encoding utf8 -Force

@'
Windows Registry Editor Version 5.00
[เอาเนื้อหาพิมพ์โค้ดทั้งหมดที่อยู่ข้างในไฟล์ regretuagod.reg ของคุณมาวางตรงนี้]
'@ | Out-File -FilePath "$TempDir\regretuagod.reg" -Encoding utf8 -Force
# =========================================================================


# 3. กำหนดตัวแปรสำหรับผูกเมนูเข้ากับไฟล์จำลองเบื้องหลัง
$RegGodreg      = "$TempDir\godreg.reg"
$RegKey         = "$TempDir\Key.reg"
$RegMouseGod    = "$TempDir\Mouse god.reg"
$RegMouseOp     = "$TempDir\mouse op.reg"
$CmdNetwork     = "$TempDir\Network.cmd"
$CmdNetworkRetua= "$TempDir\Networkretua.cmd"
$RegRegeutua    = "$TempDir\regeutua.reg"
$RegRegretuagod = "$TempDir\regretuagod.reg"

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

# 5. ลูปคำสั่งคีย์บอร์ด
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
