# Tweak Script to Optimize Windows Performance

# Function to set visual effects for best performance
function Set-VisualEffects {
    Write-Host "Setting visual effects for best performance..."

    # Adjust Visual Effects
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
    Write-Host "Creating and setting Ultimate Performance plan..."

    # Duplicate the Ultimate Performance plan if it doesn't exist
    $ultimatePlanGuid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    
    # Check if the Ultimate Performance plan already exists
    $existingPlan = powercfg -list | Select-String "Ultimate Performance"

    if (-not $existingPlan) {
        # Ultimate Performance plan does not exist; create it
        powercfg -duplicatescheme $ultimatePlanGuid | Out-Null
        Write-Host "Ultimate Performance plan created."
    } else {
        Write-Host "Ultimate Performance plan already exists."
    }

    # Set the Ultimate Performance plan as active
    powercfg -setactive $ultimatePlanGuid

    # Verify if Ultimate Performance plan is set
    $activePlan = powercfg -getactivescheme
    if ($activePlan -match "Ultimate Performance") {
        Write-Host "Power options successfully set to Ultimate Performance."
    } else {
        Write-Host "Failed to set Ultimate Performance. Current active plan: $activePlan"
    }
}

# Clear temporary files
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
Clear-TempFiles
Set-VisualEffects
Set-UltimatePerformancePlan
Open-PerformanceOptions

Write-Host "All tweaks have been successfully created!"

# Pause before exiting
Read-Host -Prompt "Please Press Enter To Enable Ultimate Performance"
Start-Process "powercfg.cpl"

