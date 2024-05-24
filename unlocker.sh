#!/bin/sh

# Step 1: Warning message
echo "WARNING: This script must run only on Gl.iNet devices. Running it on other devices may cause malfunction or even brick the device."

# Step 2: Confirm device type
read -p "Is this script running on a Gl.iNet device? (y/n): " confirm_device
if [ "$confirm_device"!= "${confirm_device#[Yy]}" ]; then
    echo "Proceeding..."
else
    echo "Aborting due to incorrect device."
    exit 1
fi

# Step 3: Double confirmation
read -p "Are you sure about proceeding? (y/n): " double_confirm
if [ "$double_confirm"!= "${double_confirm#[Yy]}" ]; then
    echo "Continuing..."
else
    echo "Operation cancelled."
    exit 1
fi

# Step 4: Choose method
read -p "Which method would you like to use? (1 (recommended), 2 (AX1800), 3 (GL-MT2500), 4 (GL-MT3000), 5 (DE, NOT RECOMMENDED), 6 (NOT RECOMMENDED)): " method_choice

case $method_choice in
    1)
        # Method 1 steps
        echo "US" > /tmp/country_code
        mount --bind /tmp/country_code /proc/gl-hw-info/country_code
        cat /proc/gl-hw-info/country_code
        
        echo "WARNING: You must now open the web interface and check if the country code has changed."
        read -p "Has the country code changed? (y/n): " country_changed
        if [ "$country_changed"!= "${country_changed#[Yy]}" ]; then
            echo "Continuing..."
        else
            echo "Please verify the country code change before proceeding."
            exit 1
        fi
        
        read -p "Are you sure the country code has changed? (y/n): " sure_country_changed
        if [ "$sure_country_changed"!= "${sure_country_changed#[Yy]}" ]; then
            sed -i '1iecho US > /tmp/country_code\nmount --bind /tmp/country_code /proc/gl-hw-info/country_code' /etc/rc.local
            cat /etc/rc.local
        else
            echo "Operation cancelled."
            exit 1
        fi
        ;;
    2)
        # Method 2 steps
        echo "WARNING: This method is not recommended unless specifically required for AX1800 models."
        read -p "Do you want to continue? (y/n): " continue_method_2
        if [ "$continue_method_2"!= "${continue_method_2#[Yy]}" ]; then
            echo "US" | dd of=/dev/mtdblock8 bs=1 seek=152
            sync
        else
            echo "Method 2 aborted."
            exit 1
        fi
        ;;
    3)
        # Method 3 steps
        echo "WARNING: This method is only for GL-MT2500 models."
        read -p "Do you want to continue? (y/n): " continue_method_3
        if [ "$continue_method_3"!= "${continue_method_3#[Yy]}" ]; then
            echo 0 > /sys/block/mmcblk0boot1/force_ro
            echo "US" | dd of=/dev/mmcblk0boot1 bs=1 seek=136
            sync
        else
            echo "Method 3 aborted."
            exit 1
        fi
        ;;
    4)
        # Method 4 steps
        echo "WARNING: This method is only for GL-MT3000 models."
        read -p "Do you want to continue? (y/n): " continue_method_4
        if [ "$continue_method_4"!= "${continue_method_4#[Yy]}" ]; then
            echo "US" | dd of=/dev/mtdblock3 bs=1 seek=136
            sync
        else
            echo "Method 4 aborted."
            exit 1
        fi
        ;;
    5)
        # Method 5 steps
        echo "WARNING: This method sets the DE country code and is NOT RECOMMENDED!"
        read -p "Do you want to continue? (y/n): " continue_method_5
        if [ "$continue_method_5"!= "${continue_method_5#[Yy]}" ]; then
            echo -n "DE" | dd of=/dev/mtdblock3 bs=1 seek=136
            sync
        else
            echo "Method 5 aborted."
            exit 1
        fi
        ;;
    6)
        # Method 6 steps
        echo "WARNING: This method is NOT RECOMMENDED."
        read -p "Do you want to continue? (y/n): " continue_method_6
        if [ "$continue_method_6"!= "${continue_method_6#[Yy]}" ]; then
            echo "US" | dd of=/dev/mmcblk0p2 conv=notrunc bs=1 seek=136
            sync
        else
            echo "Method 6 aborted."
            exit 1
        fi
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Script execution completed successfully."
echo "-/-/-/-"
echo "If any malfunctions occur, please refer to the following resources:"
echo "- Firmware downloads: https://dl.gl-inet.com/"
echo "- Model identification guide: https://docs.gl-inet.com/router/en/3/tutorials/how_to_find_model/"
echo "- Uboot debricking manual: https://docs.gl-inet.com/router/en/4/faq/debrick/"
echo "-/-/-/-"
echo "Don't forget to remove this script after operation to save space on router!"
