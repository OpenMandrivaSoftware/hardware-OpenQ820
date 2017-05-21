. .\Utilities\messages.ps1
. .\Utilities\countdown.ps1
. .\Utilities\adbflash.ps1

# ================================================================
#     Script starts here
# ================================================================

function flash_Partitions() {
    info "Flashing Android"
    $filepath = ".\Android"

    send_fastboot 'reboot-bootloader'

    # Give the device time to reboot
    countdown 5

    flash_partition 'boot' 'boot.img'
    flash_partition 'cache' 'cache.img'
    flash_partition 'persist' 'persist.img'
    flash_partition 'recovery' 'recovery.img'
    flash_partition 'userdata' 'userdata.img'
    flash_partition 'system' 'system.img'
    flash_partition 'mdtp' 'mdtp.img'
}