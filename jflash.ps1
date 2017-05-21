Set-Location -Path $PSScriptRoot

. .\Utilities\messages.ps1
. .\Utilities\countdown.ps1
. .\Utilities\adbflash.ps1
. .\Android\flashAndroid.ps1

function List-UsbDevices(){
    return gwmi Win32_USBControllerDevice |%{[wmi]($_.Dependent)};
}

function USBDevices(){
    $device = List-UsbDevices | Where-Object {$_.Description -like '*Android*' -or $_.Description -like '*Google*'} | Select DeviceID

    if ($device -eq $null) {
        warning "No Android Devices Attached "
    } else {
        Write-host "Device in ADB mode Attached " $device
    }
}


# ================================================================
#     Check for the presense of java its version
# ================================================================
function checkjava () {
    Write-Host
    info 'Checking for java and minimum java version'
    try {
        # check for java
        [string]$cmd = 'java'
        [string]$arg = '-version'
        [string]$result = & $cmd $arg  2>&1

        info "Java version $result"
        
        [string]$cmd = 'java'
        [string]$arg = '-fullversion'
        [string]$result = & $cmd $arg  2>&1

        [int]$version = [convert]::ToInt32(((($result.split('"')[1]).split('-')[0]).replace('.','')).replace('_',''),10)

        if ($version -lt 17079) {
            Write-host 
            warning "The current version of Java is from an older release: version $result"
        } else {
            return 1
        }
    } catch {
        Write-host
        error "Java does not appear to be installed on this computer"
    }
    
    error "Please install at a minimum SE Runtime Environment 1.7.xxx"
    Write-host 
    warning "JDK can be found here:"
    warning "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
    Write-host    
    return 0
}


# ================================================================
#     Script starts here
# ================================================================

# Read information regarding this flash operation
$content = (Get-Content ".\Product.txt") -split ' '

# ================================================================
#     MODIFY THE ZIP FILENAME AND PRODUCT INFORMATION
# ================================================================

$ZipName= $content[0]
$BuildVersion= $content[1]
$Product= $content[2]

info "Windows Version"
[System.Environment]::OSVersion.Version
(Get-WmiObject -Class Win32_ComputerSystem).SystemType
 
Write-host
Write-host "Intrinsyc Technologies Corporation"  -foreground green
Write-host "JFlash Updater for the " -foreground green -NoNewline
Write-host $Product -foreground white
Write-host "Build Version " -foreground green -NoNewLine
Write-host $BuildVersion -foreground white

if (checkjava -eq 1 ) {
    Write-host

    USBDevices

    message "Rebooting the device into fastboot mode."
    warning "Ignore <error: no devices found> potentially in fastboot already"
    
    [string[]]$result = send_adb 'devices'
    
    foreach ($response in $result) {
        if ( -Not $response.contains("attached" )) {
            if ( -Not $response.contains("server" )) {
                if ( -Not $response.contains("successfully" )) {
                    if ( $response.contains("device" )) {
                            info "Device Build Information"
                            send_adb 'shell' 'getprop ro.build.description'
                            
                            Write-host
                            info "Rebooting to Fastboot mode"
                            send_adb reboot-bootloader

                            # Give the device some time to reboot
                            Write-host
                            warning2 "Giving the device some time to reboot. Press Enter if already in" "  in fastboot mode."
                            countdown 10
                    }                
                }
            }
        }
    }

    USBDevices

    
    [string[]]$result = send_fastboot 'devices'

    if ($result) {
        if ( $result.Length -ne 0 ) {
            foreach ($response in $result) {
                if ($response.contains("fastboot") ) {
                    $response = send_fastboot 'getvar' 'product'

                    if ($response -Match $Product ){
                        success "Attached Model is Correct : $Product"
                        info "Flashing Meta Files"

                        # Flash the Meta files
                        java -Xms1G -Xmx1G -jar jflash.jar .\$ZipName$BuildVersion.zip NoPrompt
                        flash_Partitions
                        info "Rebooting the device"
                        send_fastboot 'reboot'
                    }
                } else {
                    warning "No device attached"
                }
            }
        }
        else {
            error "No Devices Found"
        }
    } else {
        error "No Devices Found"
    }
}
