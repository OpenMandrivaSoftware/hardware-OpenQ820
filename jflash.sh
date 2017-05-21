#!/bin/bash

JFLASH_DIR="$(pwd)"
source $JFLASH_DIR/Utilities/messages.sh

echo_cyn "Linux Version"
uname -a
echo_cyn "Linux Shell"
echo_info $SHELL


function listUSBDevices () {
    lsusb
}

function findQualcommDevice () {
# a device in full Android mode should display something like ths.
# Bus 001 Device 097: ID 05c6:9025 Qualcomm, Inc.
    listUSBDevices

    androiddevice="unknown"
    set -f

    IFS=$'\n'

    result=$(lsusb 2>&1)

    usblist=(${result//$\n/})
    found=0
    for index in "${!usblist[@]}"
    do
        if [[ ${usblist[index]} = *"Qualcomm"* ]]; then
            #echo "${usblist[index]}"
            androiddevice="${usblist[index]}"
            found=1
            break
        fi

    done
    echo
    if [ $found == 0 ]; then
        warning "No devices attached in ADB mode"
    else
        success "Found a fully booted Device $androiddevice"
    fi
}

function findGoogleDevice () {
# a device in fastboot mode should display something like ths.
# Bus 001 Device 098: ID 18d1:d00d Google Inc.
    googledevice="unknown"

    listUSBDevices

    set -f

    IFS=$'\n'

    result=$(lsusb 2>&1)

    usblist=(${result//$\n/})
    found=0
    for index in "${!usblist[@]}"
    do
        if [[ ${usblist[index]} = *"Google"* ]]; then
#            echo "${usblist[index]}"
            googledevice="${usblist[index]}"
            found=1
            break
        fi

    done
    echo
    if [ $found == 0 ]; then
        echo_error "No device found in Fastboot mode"
        exit 1
    fi
    success "Found a device in Fastboot mode $googledevice"
}


# ================================================================
#     MODIFY THE ZIP FILENAME AND PRODUCT INFORMATION
# ================================================================

textString=$(cat Product.txt)

list=($textString)
ZipName=${list[0]}
BuildVersion=${list[1]}
ProductMatch=${list[2]}

echo
echo_grn "Intrinsyc Technologies Corporation"
echo_grn "JFlash Updater for the $ProductMatch"
echo_grn "Build Version $BuildVersion"
echo


chmod 777 ./AdbFastboot/adb
chmod 777 ./AdbFastboot/fastboot
chmod 777 ./Android/flashAndroid.sh

java -fullversion

if [ $? != 0 ]; then
    echo
    warning2 "Java does not appear to be installed on this computer"  "Please install at a minimum OpenJDK Java 1.7.xxx x64"
    echo
    warning2 "JDK can be found here:" "http://openjdk.java.net/install/"
    echo
else
    JVER=4

    version=$("java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo_grn "Java Version"
    java -version

    version=${version%_*}
    result=

    IFS="._"

    for num in $version;do
        result+=$num
    done

    #echo "Java version $result"

    if (( $result < 170 )); then
        echo
        warning2 "The current version of Java is from an older release." "Please install at a minimum OpenJDK Java 1.7.xxx x64"
        echo
        warning2 "JDK can be found here:" "http://openjdk.java.net/install/"
        echo
    else
        message "Rebooting the device into fastboot mode."
        warning "Ignore <error: no devices found> potentially in fastboot already"

        findQualcommDevice

        IFS=$'\n'

        usbid=$("./AdbFastboot/adb" devices 2>&1)

        response=(${usbid//\n/})
        
        for i in "${response[@]}"
        do
            if [[ $i != *"attached"* ]]; then
                if [[ $i != *"server"* ]]; then
                    if [[ $i != *"successfully"* ]]; then
                        if [[ $i == *"device"* ]]; then
                            echo
                            echo_info "Device Build Information"
                            ./AdbFastboot/adb shell getprop ro.build.description

                            echo
                            message "Rebooting to Fastboot mode"
                            response=$("./AdbFastboot/adb" reboot-bootloader 2>&1)

                            warning2 "Giving the device some time to reboot. Press Enter if already in" "  in fastboot mode."
                            sleep 2
                        fi
                    fi
                fi
            fi
        done

        findGoogleDevice

        usbid=$("./AdbFastboot/fastboot" devices 2>&1 | awk -F ' ' '{print $1}')    
        echo

        if [ -n "${usbid}" ]; then
            message "Attached USB device ID $usbid"

            modelid=$("./AdbFastboot/fastboot" getvar product 2>&1 | awk -F ': ' '{print $2}')
            message "Looking for {$ProductMatch}"

            productid=$(echo "$modelid"|tr '\n' ' ' | awk -F ' ' '{print $1}')
            message "productid {$productid}"
            if [ -n "${productid}" ]; then

                if [ "${productid}" = "${ProductMatch}" ]; then
                    success "Correct product"
                    echo
                    message "Running jflash utility"
                    java -Xms1G -Xmx1G -jar jflash.jar ./"$ZipName$BuildVersion".zip NoPrompt
                    message "Flashing Android"
                    ./Android/flashAndroid.sh
                    message "Rebooting the device"
                    ./AdbFastboot/fastboot reboot
                else
                    error "Not the correct device"
                fi
            else
                error "Did not get a product id from the device"
            fi
        else
            warning "No Devices Attached"
        fi
    fi
fi
