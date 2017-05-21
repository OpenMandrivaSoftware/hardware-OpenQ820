@echo off
rem @echo VID_PID
set devcon=.\Utilities\devcon.exe

rem %devcon% listclass AndroidUsbDeviceClass
setlocal enableextensions enabledelayedexpansion

set found=0
set androiddevice=Unknown

for /f "delims="  %%i in ('%devcon% listclass AndroidUsbDeviceClass 2^>^&1') do (
    rem @echo %%i
    
    set "usbdevice=%%i"
    rem @echo Step 0 [!usbdevice!]
    
    set "str1=!usbdevice:There are no devices in setup class=!"
    rem @echo Step 1 [!str1!]
    
    if "!str1!"=="!usbdevice!" (
    
        set str2=!usbdevice:Listing=!
        rem @echo Step 2 !str2!
        if "!str2!"=="!usbdevice!" (
            set str3=!usbdevice:Android=!
            rem @echo Step 3 !str3!
            if not "!str3!"=="!usbdevice!" (
                rem @echo Found
                set found=1
                set "androiddevice=!usbdevice!"
                @echo Found a fully booted Device !androiddevice!
                endlocal
                exit /b 0
            )
        )
    ) else (
        rem @echo Step 5 No Devices Attached
        endlocal
        exit /b 1
    )
)

rem @echo "No devices attached in ADB mode"
endlocal
exit /b 2