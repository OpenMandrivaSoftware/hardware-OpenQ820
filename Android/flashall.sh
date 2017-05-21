OUTROOT=.
adb reboot bootloader
fastboot flash boot $OUTROOT/boot.img
fastboot flash cache $OUTROOT/cache.img
fastboot flash userdata $OUTROOT/userdata.img
fastboot flash system $OUTROOT/system.img
fastboot flash recovery $OUTROOT/recovery.img
fastboot reboot

