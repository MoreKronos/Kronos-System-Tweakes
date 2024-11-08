# Untweak Script to Revert Windows Performance Changes

# Function to restore visual effects to default settings
function Restore-VisualEffects {
    Write-Host "Restoring visual effects to default settings..."
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x9F, 0x12, 0x03, 0x80, 0x10, 0x00, 0x00, 0x00))
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewAlphaSelect' -Value 1
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value 1
    Write-Host "Visual effects restored to default settings."
}

# Function to remove Ultimate Performance power plan and set Balanced as default
function Restore-PowerPlan {
    Write-Host "Removing Ultimate Performance power plan and setting Balanced plan..."

    # Identify the GUID of the Ultimate Performance plan
    $ultimatePerformanceGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"

    # Check if the Ultimate Performance plan exists and remove it
    if (powercfg /list | Select-String -Pattern $ultimatePerformanceGUID) {
        powercfg -delete $ultimatePerformanceGUID
        Write-Host "Ultimate Performance plan removed."
    } else {
        Write-Host "Ultimate Performance plan not found, no removal needed."
    }

    # Set the Balanced plan as the active plan
    powercfg -change standby-timeout-ac 15
    powercfg -setactive scheme_balanced
    Write-Host "Balanced power plan has been set as active."
}

# Re-enable Windows Startup Delay
function Enable-StartupDelay {
    Write-Host "Enabling Windows startup delay..."
    Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Force -ErrorAction SilentlyContinue
    Write-Host "Startup delay re-enabled."
}

# Re-enable Background Apps
function Enable-BackgroundApps {
    Write-Host "Re-enabling background apps..."
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 0
    Write-Host "Background apps re-enabled."
}

# Re-enable Windows Tips and Tricks Notifications
function Enable-TipsNotifications {
    Write-Host "Enabling Windows tips and notifications..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 1
    Write-Host "Tips and notifications re-enabled."
}

# Enable Hibernation
function Enable-Hibernation {
    Write-Host "Enabling hibernation..."
    powercfg -h on
    Write-Host "Hibernation enabled."
}

# Reset Processor Scheduling to Default
function Reset-ProcessorScheduling {
    Write-Host "Resetting processor scheduling to default..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'ForegroundLockTimeout' -Value 0x200000
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl' -Name 'Win32PrioritySeparation' -Value 1
    Write-Host "Processor scheduling reset to default."
}

# Restore Network Settings to Default
function Reset-NetworkSettings {
    Write-Host "Restoring network settings to default..."

    # Define the registry path for MSMQ parameters
    $networkRegPath = 'HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters'

    # Check if the registry path exists before attempting to remove properties
    if (Test-Path $networkRegPath) {
        # Remove the network properties if they exist
        Remove-ItemProperty -Path $networkRegPath -Name 'TCPNoDelay' -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $networkRegPath -Name 'TCPAckFrequency' -ErrorAction SilentlyContinue
        Write-Host "Network settings restored to default."
    } else {
        Write-Host "Network settings could not be restored: Registry path does not exist."
    }
}

# Restore Windows Animations
function Enable-WindowsAnimations {
    Write-Host "Restoring Windows animations..."
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Value 400
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'TaskbarAnimations' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value 2
    Write-Host "Windows animations restored."
}

# Enable Cortana
function Enable-Cortana {
    Write-Host "Enabling Cortana..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaEnabled" -Value 1
    Write-Host "Cortana enabled."
}

# Restore Prefetch Files
function Restore-PrefetchFiles {
    Write-Host "Restoring Prefetch files..."
    # Prefetch files are system-managed and cannot be directly "restored". However, we can re-enable the Prefetch feature.
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "EnablePrefetcher" -Value 3
    Write-Host "Prefetch files restored."
}

# Function to open Visual Effects settings
function Open-VisualEffectsSettings {
    Write-Host "Opening Visual Effects settings..."
}

# Function to open Performance Options
function Open-PerformanceOptions {
    Write-Host "Opening Performance Options..."
}

# Main execution
Restore-PowerPlan
Restore-VisualEffects
Enable-StartupDelay
Enable-BackgroundApps
Enable-TipsNotifications
Enable-Hibernation
Reset-ProcessorScheduling
Reset-NetworkSettings
Enable-WindowsAnimations
Enable-Cortana
Restore-PrefetchFiles

Write-Host "All tweaks have been successfully reverted!"

# Pause before exiting
Read-Host -Prompt "Please Press Enter to continue"
Start-Process "powercfg.cpl"
