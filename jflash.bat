echo Off
cls

set echomsg=.\Utilities\echomsg.exe
set countdown=.\Utilities\countdown.exe
set adbcmd=.\AdbFastboot\adb.exe
set fastbootcmd=.\AdbFastboot\fastboot.exe

setlocal enableextensions enabledelayedexpansion

for /F "tokens=1,2,3 delims= " %%i in (Product.txt) do (
    set ZipName=%%i
    set BuildVersion=%%j
    set Product=%%k
)

%echomsg% CYAN "Windows Version"
ver
wmic os get osarchitecture


rem ================================================================
rem     MODIFY THE ZIP FILENAME AND PRODUCT INFORMATION
rem ================================================================

@echo.
%echomsg% GREEN "Intrinsyc Technologies Corporation"
%echomsg% GREEN "JFlash Updater for the %Product%"
%echomsg% GREEN "Build Version %BuildVersion%"
@echo. 

%echomsg% CYAN "Checking for Java"

java -fullversion

set jver=0

if %ERRORLEVEL% GEQ 1 (
    @echo. 
    %echomsg% WARNING "Java does not appear to be installed on this computer"
    %echomsg% WARNING "Please install at a minimum SE Runtime Environment 1.7.xxx"
    @echo. 
    %echomsg% WARNING "JDK can be found here:"
    %echomsg% WARNING "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
    @echo. 
) else (
    @echo.
    %echomsg% CYAN "Java Information"
    java -version
    
    for /f tokens^=2-5^ delims^=.-_^" %%i in ('java -fullversion 2^>^&1') do set "jver=%%i%%j%%k"
    
    if  !jver! LSS 170 (
        @echo. 
        %echomsg% WARNING "The current version of Java is from an older release: version %jver%"
        %echomsg% WARNING "Please install at a minimumm SE Runtime Environment 1.7.xxx"
        @echo. 
        %echomsg% WARNING "JDK can be found here:"
        %echomsg% WARNING "http://www.oracle.com/technetwork/java/javase/downloads/index.html"
        @echo. 
    ) else (

        @echo.
        %echomsg% CYAN "Rebooting the device into fastboot mode."
        @echo.
        %echomsg% WARNING "Ignore <error: no devices found> potentially in fastboot already"

        for /f "delims="  %%i in ('%adbcmd% devices 2^>^&1') do (
            rem @echo %%i

            set "adevice=%%i"
            set str=!adevice:attached=!

            if "!str!"=="!adevice!" (
                set str1=!adevice:server=!
                if "!str1!"=="!adevice!" (
                    set str2=!adevice:successfully=!
                    if "!str2!"=="!adevice!" (
                        set str3=!adevice:device=!
                        if not "!str3!"=="!adevice!" (
                            echo.
                            %echomsg% INFO "Device Build Information"
                            %adbcmd% shell getprop ro.build.description
                            echo.
                            %echomsg% INFO "Rebooting to Fastboot mode"
                            %adbcmd% reboot-bootloader

                            rem Give the device some time to reboot
                            echo.
                            %echomsg% WARNING "Giving the device some time to reboot. Press Enter if already in"
                            %echomsg% WARNING "  in fastboot mode."
                            %countdown% 10

                        )
                    )
                )
            )
        )

        rem Get ready to analyze results

        rem set fdevice=0
        set model=0        

        rem Process the "fastboot devices" response to see if a device is attached.
        for /f "delims="  %%i in ('%fastbootcmd% devices 2^>^&1') do (
            set "fdevice=%%i"
            set str=!fdevice:fastboot=!

            if not "!str!"=="!VAR!" (
                %echomsg% CYAN "Attached USB device ID [!fdevice!]"

                rem Determine if the unit is what we need

                for /F "tokens=2 delims=: " %%i in ('"%fastbootcmd% getvar product 2>&1"') do (
                    set model=%%i
                    %echomsg% INFO "Attached Model :!model!"
                    if !model! == !Product! (
                        @echo.
                        %echomsg% INFO "Running jflash utility"

                        rem Flash the Meta files
                        java -Xms1G -Xmx1G -jar jflash.jar .\!ZipName!!BuildVersion!.zip NoPrompt
                        %echomsg% INFO "Flashing Android"
                        call .\Android\flashAndroid.bat

                        %echomsg% INFO "Rebooting the device"
                        %fastbootcmd% reboot

                        goto :found
                    ) else (
                         %echomsg% ERROR "Not the correct device"
                        goto :found
                    )
                )

            ) else (
                %echomsg% ERROR "No devices attached in fastboot mode"
                goto :found
            )
        )
        %echomsg% ERROR "No devices attached"
    )
)

:found
@echo. 
%echomsg% GREEN "Done"
@echo. 
:done
endlocal
echo ON
