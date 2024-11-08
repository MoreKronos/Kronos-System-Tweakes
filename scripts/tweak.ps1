# Tweak Script to Optimize Windows Performance

# Function to set visual effects for best performance
function Set-VisualEffects {
    Write-Host "Setting visual effects for best performance..."
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 2
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90, 0x12, 0x03, 0x80, 0x10, 0x00, 0x00, 0x00))
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewAlphaSelect' -Value 0
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 0
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value 0
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value 0
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value 0
    Write-Host "Visual effects optimized for best performance."
}

# Function to create and set Ultimate Performance plan
function Set-UltimatePerformancePlan {
    Write-Host "Restoring default power schemes and removing custom plans..."
    powercfg -restoredefaultschemes  # Restore default schemes

    Write-Host "Creating Ultimate Performance plan..."
    # Define the GUID for Ultimate Performance plan
    $ultimatePerformanceGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"

    # Create the Ultimate Performance plan
    powercfg -duplicatescheme $ultimatePerformanceGUID
    Write-Host "Ultimate Performance plan created!"
}

# Clear temporary files
function Clear-TempFiles {
    Write-Host "Clearing temporary files..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temp files cleared."
}

# Disable Windows Startup Delay
function Disable-StartupDelay {
    Write-Host "Disabling Windows startup delay..."
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayInMSec" -Value 0 -Type DWord
    Write-Host "Startup delay disabled."
}

# Disable Background Apps
function Disable-BackgroundApps {
    Write-Host "Disabling background apps..."
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 1
    Write-Host "Background apps disabled."
}

# Disable Windows Tips and Tricks Notifications
function Disable-TipsNotifications {
    Write-Host "Disabling Windows tips and notifications..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0
    Write-Host "Tips and notifications disabled."
}

# Disable Hibernation (Optional)
function Disable-Hibernation {
    Write-Host "Disabling hibernation..."
    powercfg -h off
    Write-Host "Hibernation disabled."
}

# Adjust Processor Scheduling for Best Performance
function Set-ProcessorScheduling {
    Write-Host "Setting processor scheduling for best performance of programs..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'ForegroundLockTimeout' -Value 0x30d40
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl' -Name 'Win32PrioritySeparation' -Value 2
    Write-Host "Processor scheduling optimized for programs."
}

# Optimize Network Settings for Low Latency
function Optimize-NetworkSettings {
    Write-Host "Optimizing network settings for low latency..."

    # Check if the registry path exists
    $networkRegPath = 'HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters'

    if (Test-Path $networkRegPath) {
        # Set low latency settings if the path exists
        New-ItemProperty -Path $networkRegPath -Name 'TCPNoDelay' -PropertyType DWord -Value 1 -Force | Out-Null
        New-ItemProperty -Path $networkRegPath -Name 'TCPAckFrequency' -PropertyType DWord -Value 1 -Force | Out-Null
        Write-Host "Network settings optimized."
    } else {
        Write-Host "Network settings could not be optimized: Registry path does not exist."
    }
}

# Disable Windows Animations
function Disable-WindowsAnimations {
    Write-Host "Disabling Windows animations..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Value 0
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'TaskbarAnimations' -Value 0
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value 0
    Write-Host "Windows animations disabled."
}

# Disable Cortana (Use cautiously)
function Disable-Cortana {
    Write-Host "Disabling Cortana..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaEnabled" -Value 0
    Write-Host "Cortana disabled."
}

# Clear Prefetch Files
function Clear-PrefetchFiles {
    Write-Host "Clearing Prefetch files..."
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force
    Write-Host "Prefetch files cleared."
}

# Main execution
Clear-TempFiles
Set-VisualEffects
Set-UltimatePerformancePlan
Disable-StartupDelay
Disable-BackgroundApps
Disable-TipsNotifications
Disable-Hibernation
Set-ProcessorScheduling
Optimize-NetworkSettings
Disable-WindowsAnimations
Disable-Cortana
Clear-PrefetchFiles

Write-Host "All tweaks have been successfully created!"

# Pause before exiting
Read-Host -Prompt "Press Enter To Enable Ultimate Preformance Plan"
Start-Process "powercfg.cpl"
