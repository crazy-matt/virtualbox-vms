# macOS VirtualBox VM Creation

## Procedure

> Current macOS version: [*Mojave (10.14)*](https://itunes.apple.com/us/app/macos-mojave/id1398502828?mt=12)

> Tested with VirtualBox:
>    * [*5.2.16-r123759*](https://download.virtualbox.org/virtualbox/5.2.16/VirtualBox-5.2.16-123759-OSX.dmg)
>    * [*6.0.6-r130049*](https://download.virtualbox.org/virtualbox/6.0.6/VirtualBox-6.0.6-130049-OSX.dmg)

To build a VM running macOS, follow the directions below:

  1. Download the installer of the macOS version you want from Apple Store (it should be available in the 'Purchases' section if you've acquired it previously). The installer will be placed in your Applications folder. (Should work for Yosemite, El Capitan, Sierra and High Sierra, Mojave - 10.10-10.14, Catalina)
      - **Note**: On newer hardware, you might not be able to download older OS releases that Apple doesn't support on the newer hardware (e.g. the 2016 MacBook Pro can only download 10.12 Sierra or later). In this case, you need to use an older Mac to download the older OS.
      - **[Mojave download](https://itunes.apple.com/us/app/macos-mojave/id1398502828?mt=12)** (just cancel the login process and click on the download button)
      - **[Catalina download](https://itunes.apple.com/gb/app/macos-catalina/id1466841314?ls=1&mt=12)** (just cancel the login process and click on the download button)

        ☝ Catalina creation needs to be tested
  2. Make the script executable and run it
        ```bash
        git clone git@github.com:adjogahm/macos-virtualbox-vm.git
        cd macos-virtualbox-vm
        chmod +x prepare-iso.sh
        ./prepare-iso.sh --help
        ./prepare-iso.sh -i "<my installer path>" -n "<my ISO file name>"
        ```
  3. Open VirtualBox and create a new VM.
  4. Set:
      - name: Choose a name
      - type: `Mac OS X`
      - version: `Mac OS X (64-bit)`
  5. Follow the rest of the VM creation wizard and either leave the defaults or adjust to your liking.
        - Hard disk file size: minimum `25 GB` for Mojave
  6. Go into the Settings for the new VM you created and:
    
        a. Under 'Display', increase the Video Memory to at least 128MB, otherwise macOS might not boot correctly, and display performance will be abysmal.
    
        b. Under 'Audio', uncheck 'Enable Audio', otherwise the VM may display 'choppy' performance.
  7. In Terminal, run the command:
        ```bash
        VBoxManage modifyvm "<VM Name>" --cpuidset 00000001 000306a9 00020800 80000201 178bfbff
        ```
        where `<VM Name>` is the exact name of the VM set in step 4) so the VM has the right CPU settings for macOS.
  8. Click 'Start' to boot the new VM.
  9. Select the iso created in step 2 when VirtualBox asks for it.
  10. In the installer, select your preferred language.
  11. Open Disk Utility and format the volume:
    
        a. Go to `Utilities > Disk Utility`, select the VirtualBox disk, and choose `Erase` to format it as:
        - For macOS < 10.13, choose `Mac OS Extended (Journaled)`
        - For macOS 10.13 and later, choose `APFS`

        b. Scheme: GUID Partition Map
  12. Quit Disk Utility, and then continue with installation as normal.


## Troubleshooting & Improvements

  - I've noticed that sometimes I need to go in and explicitly mark the iso as a Live CD in the VM settings in order to get the VM to boot from the image.
  - If you try to start your VM and it does not boot up at all, check to make sure you have enough RAM to run your VM.
  - Conversely, VirtualBox sometimes does not eject the virtual installer DVD after installation. If your VM boots into the installer again, remove the ISO in `Settings -> Storage`.
  - VirtualBox uses the left command key as the "host key" by default. If you want to use it for shortcuts like `command+c` or `command-v` (copy&paste), you need to remap or unset the "Host Key Combination" in `Preferences -> Input -> Virtual Machine`.
  - The default Video Memory of 16MB is far below Apple's official requirement of 128MB. Increasing this value may help if you run into problems and is also the most effective performance tuning.
  - Depending on your hardware, you may also want to increase RAM and the share of CPU power the VM is allowed to use.
  - If for High Sierra you can not find the VirtualBox disk created inside the Disk Utility select `View -> Show All Devices` and format the newly visible device ([Source: tinyapps.org](https://tinyapps.org/blog/mac/201710010700_high_sierra_disk_utility.html)).
  - If for High Sierra you encounter boot / EFI problems, restart the VM and hit `F12` to get to the VirtualBox boot manager. Select **EFI In-Terminal Shell** and run:
    ```bash
    Shell> fs1:
    FS1:\> cd "macOS Install Data"
    FS1:\macOS Install Data\> cd "Locked Files"
    FS1:\macOS Install Data\Locked Files\> cd "Boot Files"
    FS1:\macOS Install Data\Locked Files\Boot Files\> boot.efi
    ```
  - If for Mojave you can not find the VirtualBox disk created inside the Disk Utility and you encounter boot / EFI problems, the VM rebooting each time on the installer, restart the VM and hit `F12` to get to the VirtualBox boot manager. Select **Boot Manager** and **EFI Hard Drive**. (didn't work on VirtualBox6 with Mojave, need a fix)
  
    Then finish the installation process, shutdown the VM (or [create a snapshot](#vm-snapshot-creation)) and remove the Optical Drive from your storage settings.
  - If keyboard and mouse do not work inside the VM:
    1. Ensure the VirtualBox Extension Pack is installed:
        - [VirtualBox Extension Pack (5.2.16)](https://download.virtualbox.org/virtualbox/5.2.16/Oracle_VM_VirtualBox_Extension_Pack-5.2.16.vbox-extpack)
        - [VirtualBox Extension Pack (6.0.6)](https://download.virtualbox.org/virtualbox/6.0.6/Oracle_VM_VirtualBox_Extension_Pack-6.0.6.vbox-extpack)
    2. In the VM settings, under `Ports > USB`, select `USB 3.0 (xHCI) Control`.

## Larger VM Screen Resolution

To control the screen size of your macOS VM:

  1. Shutdown your VM
  2. Run the following VBoxManage command:
        ```bash
        VBoxManage setextradata "<VM Name>" VBoxInternal2/EfiGopMode N
        ```
        * Replace `<VM Name>` with the name of your Virtual Machine.
        * Replace `N` with one of 0,1,2,3,4,5. These numbers correspond to the screen resolutions:
            
            0. 640x480, 1. 800x600, 2. 1024x768, 3. 1280x1024, 4. 1440x900, 5. 1920x1200 screen resolution, respectively.
        
        It works also defining it that way:
        ```bash
        VBoxManage setextradata "<VM Name>" VBoxInternal2/EfiGraphicsResolution 1440x900
        ```

> The video mode can only be changed when the VM is powered off and remains persistent until changed. See more details in [this forum discussion](https://forums.virtualbox.org/viewtopic.php?f=22&t=54030).

## VM Snapshot Creation
When the installation is complete, and you have a fresh new macOS VM, you can shut it down and create a snapshot.

This way, you can go back to the initial state in the future. I use this technique to test the [`mac-dev-playbook`](https://github.com/geerlingguy/mac-dev-playbook), which I use to set up and configure my own Mac workstation for web and app development.

## Notes

  - The code for this example originally came from VirtualBox forums and especially [this article](http://sqar.blogspot.de/2014/10/installing-yosemite-in-virtualbox.html).
  - Subsequently updated to support Yosemite - Sierra based on [this thread](https://forums.virtualbox.org/viewtopic.php?f=22&t=77068&p=358865&hilit=elCapitan+iso#p358865), and High Sierra and beyond based on the work of a number of contributors (thanks!).
  - To install command line tools after macOS is booted, open a terminal window and enter `xcode-select --install` (or just try using `git`, `gcc`, or other tools that would be installed with CLI tools).

## Author

The source of this project was created in 2015 by [Jeff Geerling](https://github.com/geerlingguy/macos-virtualbox-vm).
