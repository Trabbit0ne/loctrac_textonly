#!/bin/bash

 ##################################################################
 # WARNING: This Tool Is Made For Pentesters And Ethical Purposes #
 ##################################################################

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------------------------------
# Youtube: TrabbitOne
# BuyMeACoffee: trabbit0ne
# Bitcoin: bc1qehnsx5tdwkulamttzla96dmv82ty9ak8l5yy40
# ----------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------------------------------
# IP Location Tracking software
# Author: Trabbit
# Date: 2024-07-13
# ----------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Variables
version="1.4.0"
proxy=$(curl -s http://ip-api.com/json/$ip?fields=proxy | jq -r '.proxy')

# Set color code shortcuts
red="\e[1;31m"    # Red text code
green="\e[32m"    # Green text code
yellow="\e[33m"   # Yellow text code
blue="\e[34m"     # Blue text code
purple="\e[35m"   # Purple text code
cyan="\e[36m"     # Cyan txt code
bgred="\e[41m"    # Red background color code
bggreen="\e[42m"  # Green background color code
bgyellow="\e[43m" # Yellow background color code
bgblue="\e[44m"   # Blue background color code
bgpurple="\e[45m"   # Blue background color code
bgcyan="\e[46m"   # Blue background color code
clean="\e[0m"     # cleared color (empty)

# Default theme color
text_color="$red" # Default text color
bg_color="$bgred" # Default background

# Function to write text with text writing effect
write() {
    local text="$1"
    local delay=${2:-0.02}  # Default delay of 0.02 seconds

    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo  # Print a newline at the end
}

# Function to handle errors
handle_error() {
    local exit_code=$1
    local msg="$2"
    if [ $exit_code -ne 0 ]; then
        echo -e "${red}[ERROR]${clean} $msg" >&2
        exit $exit_code
    fi
}

# Function to install necessary packages if not installed
install_package() {
    if ! command -v "$1" &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y "$1"
        handle_error $? "Failed to install package: $1"
    fi
}

# Clear the screen
clear

# Check and install necessary packages
required_commands=("curl" "jq")
for cmd in "${required_commands[@]}"; do
    command -v "$cmd" &> /dev/null
    handle_error $? "$cmd is required but not installed. Please install it before running the script."
done

# Function to get public IP address
get_public_ip() {
    local result=$(curl -s -w "%{http_code}" https://api.ipify.org)
    local http_code="${result: -3}"
    if [ "$http_code" -ne 200 ]; then
        handle_error 1 "Failed to retrieve public IP address."
    fi
    echo "${result:0:${#result}-3}"
}

# Function to check if a port is open
check_port() {
    local ip=$1
    local port=$2
    timeout 1 bash -c "</dev/tcp/$ip/$port" &>/dev/null && return 0 || return 1
}

# Function to determine the type of IP address
determine_ip_type() {
    local ip=$1
    local type="unknown"

    # Check common ports
    if check_port $ip 80 || check_port $ip 443 || check_port $ip 8080; then
        # Try to get the HTTP headers
        response=$(curl -s -I http://$ip)
        if [[ $response == *"HTTP/"* ]]; then
            type="web server"
        fi
    else
        type="unknown"
    fi

    echo "$type"
}

# Function to get IP location details
get_ip_location() {
    local ip="$1"
    local location_ipapi=$(curl -s "http://ip-api.com/json/$ip")
    handle_error $? "Failed to retrieve IP location details."

    local latitude=$(echo "$location_ipapi" | jq -r '.lat')
    local longitude=$(echo "$location_ipapi" | jq -r '.lon')
    local zip_code=$(echo "$location_ipapi" | jq -r '.zip')
    local device_type=$(determine_ip_type "$ip")

    # Display IP location information
    echo -e "     |     \_|)   _   _ _|_  ,_   _,   _        "
    echo -e "  --(+)--    |   / \_/   |  /  | / |  /         "
    echo -e "     |      (\__/\_/ \__/|_/   |/\/|_/\__/      "
    echo
    echo -e "${bg_color}       PENTAGONE GROUP - LOCTRAC SOFTWARE       ${clean}"
    echo
    echo -e "${text_color}[INFO]${clean} [+] IP Address   => $ip    "
    echo -e "${text_color}[INFO]${clean} [+] Country      => $(echo "$location_ipapi" | jq -r '.country')"
    echo -e "${text_color}[INFO]${clean} [+] Date & Time  => $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${text_color}[INFO]${clean} [+] Region code  => $(echo "$location_ipapi" | jq -r '.region')"
    echo -e "${text_color}[INFO]${clean} [+] Region       => $(echo "$location_ipapi" | jq -r '.regionName')"
    echo -e "${text_color}[INFO]${clean} [+] City         => $(echo "$location_ipapi" | jq -r '.city')"
    echo -e "${text_color}[INFO]${clean} [+] Zip code     => $zip_code"
    echo -e "${text_color}[INFO]${clean} [+] Time zone    => $(echo "$location_ipapi" | jq -r '.timezone')"
    echo -e "${text_color}[INFO]${clean} [+] ISP          => $(echo "$location_ipapi" | jq -r '.isp')"
    echo -e "${text_color}[INFO]${clean} [+] Organization => $(echo "$location_ipapi" | jq -r '.org')"
    echo -e "${text_color}[INFO]${clean} [+] ASN          => $(echo "$location_ipapi" | jq -r '.as')"
    echo -e "${text_color}[INFO]${clean} [+] Latitude     => $latitude"
    echo -e "${text_color}[INFO]${clean} [+] Longitude    => $longitude"
    echo -e "${text_color}[INFO]${clean} [+] Location     => $latitude,$longitude"
    echo -e "${text_color}[INFO]${clean} [+] Proxy/VPN    => $proxy"
    echo -e "${text_color}[INFO]${clean} [+] Type         => $device_type"
}

# Function to display help
show_help() {
    echo -e "${bg_color}        .:: Loctrac Program Usage ::.        ${clean}"
    echo -e "---------------------------------------------         "
    echo -e "Options:                                              "
    echo -e "  [-m] | Track your own public IP                     "
    echo -e "  [IP] | Track a custom IP address                    "
    echo -e "  [-h] | Show help and usage information              "
    echo -e "  [-v] | Show current version of the program          "
    echo
    echo -e "---------------------------------------------         "
    echo -e "Examples:                                             "
    echo -e "  [1. loctrac -m ]   Every scans made                 "
    echo -e "  [2. loctrac 8.8.8.8 ]   Track a specific IP         "
    echo -e "  [3. loctrac -h ]   Show help                        "
    echo -e "  [4. loctrac -v ]   Show version                     "
}

# Main script logic
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

while getopts "mhv" opt; do
    case $opt in
        m)
            public_ip=$(get_public_ip)
            get_ip_location "$public_ip"
            ;;
        h)
            show_help
            ;;
        v)
            echo "        _____             "
            echo "    ,-:\' \;',\'-.        "
            echo "  .'-;_,;  ':-;_,.'       "
            echo " /;   '/    ,  _'.-\      "
            echo "| ''. ('     /' ' \'|     "
            echo "|:.  '\'-.   \_   / |     "
            echo "|     (   ',  .'\ ;'|     "
            echo " \     | .'     '-'/      "
            echo "  '.   ;/        .'       "
            echo "    ''-._____..-'         "
            echo
            echo -e "${text_color}Loctrac Software${clean} version ${bg_color}$version${clean}    "
            echo
            ;;
        *)
            show_help
            ;;
    esac
    exit 0
done

if [ $# -eq 1 ]; then
    get_ip_location "$1"
fi
