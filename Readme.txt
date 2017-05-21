Jflash instructions for Intrinsyc Open-Q dev kit
Readme Version: V 1.1
Date: Nov 8th, 2016
===================================

From the command line type the following commands:

For Windows batch file
	jflash.bat from command shell or from file explore window
    
For developere familiar with Windows Powershell
    Before running the powershell script, the ExecutionPolicy needs to be set
    once only.
        1. Open a command terminal window as administrator
        2. powershell Set-ExecutionPolicy RemoteSigned
        
    Open a powershell window.
    
        Windows PowerShell
        Copyright (C) 2015 Microsoft Corporation. All rights reserved.

        PS Z:\>cd <to location of files>
        PS <location of files>.\jflash.ps1

    From File Explorer, right click and select "Run with PowerShell". Otherwise,
    an editor will open.  Windows is not generally configured to run PowerShell
    scripts like the older batch files.

For Linux
	chmod +x jflash.sh
	./jflash.sh

Do not modify product.txt, this file is used by jflash.sh, jflash.ps1 and jflash.bat.
The information within product.txt is used to open the zip flle and
check for a valid device in fastboot mode prior to flashing.

Directory AdbFastboot, contains the executables for both Windows and Linux.
These are included to ensure the appropriate version of fastboot.  Not all
fastboot versions, support fragmenting large files.

The provided zip file is password protected and requires the jflash.jar file
to open and extract its contents into RAM space.

flashAndroid.(bat/sh) are used to flash the files contained within the Android
directory.

See log in jflash.log

If you have any questions contact support@intrinsyc.com



