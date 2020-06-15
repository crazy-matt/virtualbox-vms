#!/usr/bin/env bash
#
# This script will create a bootable ISO image from the installer app for:
#
#   - Yosemite (10.10)
#   - El Capitan (10.11)
#   - Sierra (10.12)
#   - High Sierra (10.13)
#   - Mojave (10.14)
#   - Catalina (10.15)


#
# COLOR CODES
#

# Reset
Color_Off="\033[0m"       # Text Reset
# Regular Colors
Black="\033[0;30m"        # Black
Red="\033[0;31m"          # Red
Green="\033[0;32m"        # Green
Yellow="\033[0;33m"       # Yellow
Blue="\033[0;34m"         # Blue
Purple="\033[0;35m"       # Purple
Cyan="\033[0;36m"         # Cyan
White="\033[0;37m"        # White
# Bold
BBlack="\033[1;30m"       # Black
BRed="\033[1;31m"         # Red
BGreen="\033[1;32m"       # Green
BYellow="\033[1;33m"      # Yellow
BBlue="\033[1;34m"        # Blue
BPurple="\033[1;35m"      # Purple
BCyan="\033[1;36m"        # Cyan
BWhite="\033[1;37m"       # White
# Underline
UBlack="\033[4;30m"       # Black
URed="\033[4;31m"         # Red
UGreen="\033[4;32m"       # Green
UYellow="\033[4;33m"      # Yellow
UBlue="\033[4;34m"        # Blue
UPurple="\033[4;35m"      # Purple
UCyan="\033[4;36m"        # Cyan
UWhite="\033[4;37m"       # White
# Background
On_Black="\033[40m"       # Black
On_Red="\033[41m"         # Red
On_Green="\033[42m"       # Green
On_Yellow="\033[43m"      # Yellow
On_Blue="\033[44m"        # Blue
On_Purple="\033[45m"      # Purple
On_Cyan="\033[46m"        # Cyan
On_White="\033[47m"       # White
# High Intensty backgrounds
On_IBlack="\033[0;100m"   # Black
On_IRed="\033[0;101m"     # Red
On_IGreen="\033[0;102m"   # Green
On_IYellow="\033[0;103m"  # Yellow
On_IBlue="\033[0;104m"    # Blue
On_IPurple="\033[10;95m"  # Purple
On_ICyan="\033[0;106m"    # Cyan
On_IWhite="\033[0;107m"   # White
# Custom
OK=${BGreen}
WARNING=${BYellow}
ERROR=${BRed}
ALERT=${BWhite}${On_Red} # Bold White on red background
TITLE1=${BWhite}${On_Blue}
TITLE2=${BWhite}${UBlue}
TITLE3=${Blue}
QUERY=${Green}${On_IBlack}


#
# ARGUMENTS HELPER
#

# ARG_OPTIONAL_SINGLE([installer-path],[i],[Path of your Mac OS installer])
# ARG_OPTIONAL_SINGLE([iso-name],[n],[Name you want for the ISO file which will be created in 'Documents/ISOs/'])
# ARG_HELP([This script will create a VirtualBox iso file from the provided installer for you to create a Mac OS VM.])
# ARGBASH_GO()
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}

begins_with_short_option()
{
	local first_option all_short_options='inh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_installer_path=
_arg_iso_name=

print_help()
{
  echo -e "${BYellow}This script will create a VirtualBox iso file from the provided installer for you to create a Mac OS VM.${Color_Off}"
  echo -e "${UWhite}Usage${Color_Off}: $0 [-i|--installer-path <arg>] [-n|--iso-name <arg>] [-h|--help]\n"
	printf '\t%s\n' "-i, --installer-path: Path of your Mac OS installer (no default)"
	printf '\t%s\n' "-n, --iso-name: Name you want for the ISO file which will be created in 'Documents/ISOs/' (no default)"
	printf '\t%s\n' "-h, --help: Prints help"
}

parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-i|--installer-path)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_installer_path="$2"
				shift
				;;
			--installer-path=*)
				_arg_installer_path="${_key##--installer-path=}"
				;;
			-i*)
				_arg_installer_path="${_key##-i}"
				;;
			-n|--iso-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_iso_name="$2"
				shift
				;;
			--iso-name=*)
				_arg_iso_name="${_key##--iso-name=}"
				;;
			-n*)
				_arg_iso_name="${_key##-n}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

has_error=0
[[ ! -d "${_arg_installer_path}" ]] && echo -e "${ERROR}You must provide a valid macOS installer path${Color_Off}" && has_error=1
[[ -z "${_arg_iso_name}" ]] && echo -e "${ERROR}You must provide a name for your ISO which will be plugged as a VM optical disc${Color_Off}" && has_error=1
(($has_error)) && exit 1

set -e

#
# createISO
#
# This function creates the ISO image for the user.
# Inputs:  $1 = The path of the installer - should be located in your Applications folder
#          $2 = The Name of the ISO you want created.
#          $3 = The version of MacOS embedded in your installer.
function createISO()
{
  if [ $# -eq 3 ] ; then
    local _installer_path="$1"
    local _iso_name="$2"
    local _version="$3"
    local _timestamp=$(echo $(date +%F | tr -d '-')-$(date +%T | tr -d ':'))

    echo -e "${WARNING}Mounting the installer image...${Color_Off}"
    [[ -d "/Volumes/install_app" ]] && umount -f /Volumes/install_app
    echo -e "${QUERY}$ hdiutil attach \"${_installer_path}/Contents/SharedSupport/InstallESD.dmg\" -noverify -nobrowse -mountpoint /Volumes/install_app${Color_Off}"
    hdiutil attach "${_installer_path}/Contents/SharedSupport/InstallESD.dmg" -noverify -nobrowse -mountpoint /Volumes/install_app

    echo -e "${WARNING}Creating ${_iso_name} blank ISO image with a Single Partition - Apple Partition Map...${Color_Off}"
    [[ -f "/tmp/${_iso_name}.sparseimage" ]] && rm -f "/tmp/${_iso_name}.sparseimage"
    echo -e "${QUERY}$ hdiutil create -o /tmp/${_iso_name} -size 8g -layout SPUD -fs HFS+J -type SPARSE${Color_Off}"
    hdiutil create -o /tmp/${_iso_name} -size 8g -layout SPUD -fs HFS+J -type SPARSE

    echo -e "${WARNING}Mounting the sparse bundle for package addition...${Color_Off}"
    [[ -d "/Volumes/install_build" ]] && umount -f /Volumes/install_build
    echo -e "${QUERY}$ hdiutil attach /tmp/${_iso_name}.sparseimage -noverify -nobrowse -mountpoint /Volumes/install_build${Color_Off}"
    hdiutil attach /tmp/${_iso_name}.sparseimage -noverify -nobrowse -mountpoint /Volumes/install_build

    case "${version}" in
      "HighSierra"|"Mojave"|"Catalina")
        echo -e "${WARNING}Restoring the Base System into the ${_iso_name} ISO image...${Color_Off}"
        echo -e "${QUERY}$ asr restore -source \"${_installer_path}/Contents/SharedSupport/BaseSystem.dmg\" -target /Volumes/install_build -noprompt -noverify -erase${Color_Off}"
        asr restore -source "${_installer_path}/Contents/SharedSupport/BaseSystem.dmg" -target /Volumes/install_build -noprompt -noverify -erase
        echo -e "${WARNING}Removing Package link and replace with actual files...${Color_Off}"
        echo -e "${QUERY}$ ditto -V \"/Volumes/install_app/Packages\" \"/Volumes/macOS Base System/System/Installation/\"${Color_Off}"
        ditto -V "/Volumes/install_app/Packages" "/Volumes/macOS Base System/System/Installation/"
        echo -e "${WARNING}Copying macOS ${_iso_name} installer dependencies...${Color_Off}"
        echo -e "${QUERY}$ ditto -V \"${_installer_path}/Contents/SharedSupport/BaseSystem.chunklist\" \"/Volumes/macOS Base System/BaseSystem.chunklist\"${Color_Off}"
        ditto -V "${_installer_path}/Contents/SharedSupport/BaseSystem.chunklist" "/Volumes/macOS Base System/BaseSystem.chunklist"
        echo -e "${QUERY}$ ditto -V \"${_installer_path}/Contents/SharedSupport/BaseSystem.dmg\" \"/Volumes/macOS Base System/BaseSystem.dmg\"${Color_Off}"
        ditto -V "${_installer_path}/Contents/SharedSupport/BaseSystem.dmg" "/Volumes/macOS Base System/BaseSystem.dmg"
        echo -e "${WARNING}Unmounting the sparse bundle...${Color_Off}"
        echo -e "${QUERY}$ hdiutil detach \"/Volumes/macOS Base System/\"${Color_Off}"
        hdiutil detach "/Volumes/macOS Base System/"
        ;;
      *)
        echo -e "${WARNING}Restoring the Base System into the ${_iso_name} ISO image...${Color_Off}"
        echo -e "${QUERY}$ asr restore -source /Volumes/install_app/BaseSystem.dmg -target /Volumes/install_build -noprompt -noverify -erase${Color_Off}"
        asr restore -source /Volumes/install_app/BaseSystem.dmg -target /Volumes/install_build -noprompt -noverify -erase
        echo -e "${WARNING}Removing Package link and replace with actual files...${Color_Off}"
        echo -e "${QUERY}$ rm \"/Volumes/OS X Base System/System/Installation/Packages\"${Color_Off}"
        rm "/Volumes/OS X Base System/System/Installation/Packages"
        echo 
        echo -e "${QUERY}$ cp -rp \"/Volumes/install_app/Packages\" \"/Volumes/OS X Base System/System/Installation/\"${Color_Off}"
        cp -rp "/Volumes/install_app/Packages" "/Volumes/OS X Base System/System/Installation/"
        echo -e "${WARNING}Copying macOS ${_iso_name} installer dependencies...${Color_Off}"
        echo -e "${QUERY}$ cp -rp \"/Volumes/install_app/BaseSystem.chunklist\" \"/Volumes/OS X Base System/BaseSystem.chunklist\"${Color_Off}"
        cp -rp "/Volumes/install_app/BaseSystem.chunklist" "/Volumes/OS X Base System/BaseSystem.chunklist"
        echo -e "${QUERY}$ cp -rp \"/Volumes/install_app/BaseSystem.dmg\" \"/Volumes/OS X Base System/BaseSystem.dmg\"${Color_Off}"
        cp -rp "/Volumes/install_app/BaseSystem.dmg" "/Volumes/OS X Base System/BaseSystem.dmg"
        echo -e "${WARNING}Unmounting the sparse bundle...${Color_Off}"
        echo -e "${QUERY}$ hdiutil detach \"/Volumes/OS X Base System/\"${Color_Off}"
        hdiutil detach "/Volumes/OS X Base System/"
        ;;
    esac
    
    echo -e "${WARNING}Unmounting the installer image...${Color_Off}"
    echo -e "${QUERY}$ hdiutil detach /Volumes/install_app${Color_Off}"
    hdiutil detach /Volumes/install_app

    echo -e "${WARNING}Resizing the partition in the sparse bundle to remove any free space...${Color_Off}"
    echo -e "${QUERY}$ hdiutil resize -size `hdiutil resize -limits /tmp/${_iso_name}.sparseimage | tail -n 1 | awk '{ print $1 }'`b /tmp/${_iso_name}.sparseimage${Color_Off}"
    hdiutil resize -size `hdiutil resize -limits /tmp/${_iso_name}.sparseimage | tail -n 1 | awk '{ print $1 }'`b /tmp/${_iso_name}.sparseimage

    echo -e "${WARNING}Converting the ${_iso_name} sparse bundle to ISO/CD master...${Color_Off}"
    echo -e "${QUERY}$ hdiutil convert /tmp/${_iso_name}.sparseimage -format UDTO -o /tmp/${_iso_name}${Color_Off}"
    hdiutil convert /tmp/${_iso_name}.sparseimage -format UDTO -o /tmp/${_iso_name}

    echo -e "${WARNING}Removing the sparse bundle...${Color_Off}"
    echo -e "${QUERY}$ rm /tmp/${_iso_name}.sparseimage${Color_Off}"
    rm /tmp/${_iso_name}.sparseimage

    echo -e "${WARNING}Renaming the ISO and move it to Documents/ISOs...${Color_Off}"
    echo -e "${QUERY}$ mkdir -p \"$HOME/Documents/ISOs\" && mv \"/tmp/${_iso_name}.cdr\" \"$HOME/Documents/ISOs/${_iso_name}_${_timestamp}.iso\"${Color_Off}"
    mkdir -p "$HOME/Documents/ISOs" && mv "/tmp/${_iso_name}.cdr" "$HOME/Documents/ISOs/${_iso_name}_${_timestamp}.iso"

    echo -e "${OK}ISO created here: '$HOME/Documents/ISOs/${_iso_name}_${_timestamp}.iso'${Color_Off}"
  else
    echo -e "${ERROR}Wrong argument number for ${FUNCNAME[0]}()${Color_Off}" && exit 1
  fi
}


#                  #
# Main script code #
#                  #
# Eject installer disk in case it was opened after download from App Store
for disk in $(hdiutil info | grep /dev/disk | grep partition | cut -f 1); do
  hdiutil detach -force ${disk}
done

installer_file_name=$(basename "${_arg_installer_path}")
version=""

if [[ "${installer_file_name}" == *"Catalina"* ]]; then
  version="Catalina"
elif [[ "${installer_file_name}" == *"Mojave"* ]]; then
  version="Mojave"
elif [[ "${installer_file_name}" == *"High Sierra"* ]]; then
  version="HighSierra"
elif [[ "${installer_file_name}" == *"Sierra"* ]]; then
  version="Sierra"
elif [[ "${installer_file_name}" == *"El Capitan"* ]]; then
  version="ElCapitan"
elif [[ "${installer_file_name}" == *"Yosemite"* ]]; then
  version="Yosemite"
else
  echo -e "${ERROR}Installer macOS version unidentified${Color_Off}" && exit 1
fi

createISO "${_arg_installer_path}" "${_arg_iso_name}" "${version}"
