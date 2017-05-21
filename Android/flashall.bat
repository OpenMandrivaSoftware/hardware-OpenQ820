@echo off

@echo Upgrading device...
adb reboot bootloader
fastboot flash boot boot.img
fastboot flash cache cache.img
fastboot flash userdata userdata.img
fastboot flash system system.img
fastboot flash recovery recovery.img
fastboot reboot

