# Untweak Script to Revert Windows Performance Changes

# Function to restore visual effects to default settings
function Restore-VisualEffects {
    Write-Host "Restoring visual effects to default settings..."

    # Restore Visual Effects to Windows defaults
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x9F, 0x12, 0x03, 0x80, 0x10, 0x00, 0x00, 0x00))
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewAlphaSelect' -Value 1
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value 1
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value 1

    Write-Host "Visual effects restored to default settings."
}

# Function to remove the Ultimate Performance plan
function Remove-UltimatePerformancePlan {
    Write-Host "Removing Ultimate Performance plan if it exists..."

    # Identify the Ultimate Performance plan GUID
    $ultimatePlanGuid = "e9a42b02-d5df-448d-aa00-03f14749eb61"

    # Check if the Ultimate Performance plan exists
    $existingPlan = powercfg -list | Select-String "Ultimate Performance"

    if ($existingPlan) {
        # Ultimate Performance plan exists; remove it
        powercfg -delete $ultimatePlanGuid | Out-Null
        Write-Host "Ultimate Performance plan removed."
    } else {
        Write-Host "Ultimate Performance plan does not exist."
    }

    # Restore to High Performance or Balanced plan
    powercfg -setactive "High performance" # Change to your preferred default plan
    Write-Host "Power options restored to High Performance."
}

# Clear temporary files if desired
function Clear-TempFiles {
    Write-Host "Clearing temporary files..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temp files cleared."
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
Restore-VisualEffects
Remove-UltimatePerformancePlan
Clear-TempFiles
Open-PerformanceOptions
# Pause before exiting
Write-Host "All tweaks have been successfully reverted!"

Read-Host -Prompt "Please Press Enter To disable Ultimate Performance and enable Balanced Pre"
Start-Process "powercfg.cpl"

