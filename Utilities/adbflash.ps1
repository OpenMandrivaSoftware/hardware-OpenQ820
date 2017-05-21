. .\Utilities\messages.ps1
. .\Utilities\countdown.ps1

# ================================================================
#     Flash file operation
# ================================================================ 
function flash_partition ([string] $partition, [string] $file) {
    message "Flash $partition"
    $fastboot = '.\AdbFastboot\fastboot.exe'
    $flashcmd = 'flash'
    $pathfile = "$filepath\$file"

    [string]$flashresult = & $fastboot $flashcmd $partition $pathfile 2>&1
    
    if ( $flashresult.contains("FAILED") ) {
        error "Failed to flash partition $partition"
        exit
    }
}

function send_fastboot ([string] $fastbootcmd, [string] $fastbootarg="") {
    $fastboot = '.\AdbFastboot\fastboot.exe'
    [string[]]$fastbootresult = & $fastboot $fastbootcmd $fastbootarg 2>&1
    return $fastbootresult    
}

function erase_partition ([string]$partition) {
    message "Erase Partition $partition"
    $result = send_fastboot 'erase' $partition
}

# ================================================================
#     ADB Commands
# ================================================================ 
function send_adb ([string] $adbcmd, [string[]] $adbarg="", [bool] $echoOutput=$false) {
    $adb = '.\AdbFastboot\adb.exe'
    if ( $echoOutput -eq $False ) {
        [string[]]$adbresult = & $adb $adbcmd $adbarg 2>&1
        return $adbresult    
    } else {
        & $adb $adbcmd $adbarg
    }
}

function waitdevice () {
    $response = send_adb 'wait-for-device'
}

# ================================================================
#     Set to root mode
# ================================================================ 
function setroot() {
    info ("Setting to Root Mode")
    $response = send_adb 'root'
    waitdevice
    
    info ("Root Response " + $response)
    if ($response -And -Not $response.contains("adbd is already running as root" )){
        send_adb 'wait-for-device'
        countdown (5)
    }
    $response = send_adb 'remount'
}