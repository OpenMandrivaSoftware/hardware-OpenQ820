set ANDROIDROOT=Android
set FASTBOOT_DIR=.\AdbFastboot

%FASTBOOT_DIR%\fastboot.exe flash boot %ANDROIDROOT%\boot.img
%FASTBOOT_DIR%\fastboot.exe flash cache %ANDROIDROOT%\cache.img
%FASTBOOT_DIR%\fastboot.exe flash persist %ANDROIDROOT%\persist.img
%FASTBOOT_DIR%\fastboot.exe flash recovery %ANDROIDROOT%\recovery.img
%FASTBOOT_DIR%\fastboot.exe flash userdata %ANDROIDROOT%\userdata.img
%FASTBOOT_DIR%\fastboot.exe flash system %ANDROIDROOT%\system.img
%FASTBOOT_DIR%\fastboot.exe flash mdtp %ANDROIDROOT%\mdtp.img
