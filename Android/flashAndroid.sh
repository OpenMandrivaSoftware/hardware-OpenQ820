ANDROIDROOT=Android
FASTBOOT_DIR=./AdbFastboot

$FASTBOOT_DIR/fastboot flash boot $ANDROIDROOT/boot.img
$FASTBOOT_DIR/fastboot flash cache $ANDROIDROOT/cache.img
$FASTBOOT_DIR/fastboot flash persist $ANDROIDROOT/persist.img
$FASTBOOT_DIR/fastboot flash recovery $ANDROIDROOT/recovery.img
$FASTBOOT_DIR/fastboot flash userdata $ANDROIDROOT/userdata.img
$FASTBOOT_DIR/fastboot flash system $ANDROIDROOT/system.img
$FASTBOOT_DIR/fastboot flash mdtp $ANDROIDROOT/mdtp.img
