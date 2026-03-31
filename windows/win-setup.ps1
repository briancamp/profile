# powershell -ExecutionPolicy Bypass -File .\win-setup.ps1

# Unhide all icons in systray
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0

# Hide the search box
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

# Disable Bing search
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Value 0

# Disable Task View
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

# Move Taskbar left
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0

# Disable widgets
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Force | Set-ItemProperty -Name "AllowNewsAndInterests" -Value 0

# Swap Caps & Esc
$hex = [byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                0x03,0x00,0x00,0x00,
                0x01,0x00,0x3A,0x00,
                0x3A,0x00,0x01,0x00,
                0x00,0x00,0x00,0x00)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Value $hex -Type Binary

# Restart explorer
Stop-Process -Name explorer -Force
