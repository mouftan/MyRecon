#!/bin/bash

# ANSI color codes
RED='\033[91m'
GREEN='\033[92m'
RESET='\033[0m'

# ASCII art
echo -e "${RED}"
cat << "EOF" 
 _      ____  _     _____ _____  ____  _     
/ \__/|/  _ \/ \ /\/    //__ __\/  _ \/ \  /|
| |\/||| / \|| | |||  __\  / \  | / \|| |\ ||
| |  ||| \_/|| \_/|| |     | |  | |-||| | \||
\_/  \|\____/\____/\_/     \_/  \_/ \|\_/  \|
                                             
EOF
echo -e "${RESET}"

# Help menu
display_help() {
    echo -e "MyRecon: A Powerful Automation Tool for Web Recon\n"
    echo -e "Usage: $0 [options]\n"
    echo "Options:"
    echo "  -h, --help              Display help information"
    echo "  -d, --domain <domain>   Single domain"
    echo "  -f, --file <filename>   File containing multiple domains"
    echo "  -o, --output <folder>   Specify output folder for scan results (default: ./output)"
    exit 0
}

# Default output folder
output_folder="./output"

# Get the current user's home directory
home_dir=$(eval echo ~"$USER")

# Excluded extensions
excluded_extensions="png,jpg,gif,jpeg,swf,woff,svg,pdf,json,css,js,webp,woff,woff2,eot,ttf,otf,mp4,txt"

# Check prerequisites
check_prerequisite() {
    local tool=$1
    local install_command=$2
    if ! command -v "$tool" &> /dev/null; then
        echo "Installing $tool..."
        eval "$install_command"
    fi
}

check_prerequisite "amass" "go install -v github.com/owasp-amass/amass/v3/...@master"
check_prerequisite "subfinder" "go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
check_prerequisite "assetfinder" "go install -v github.com/tomnomnom/assetfinder@latest"


# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            display_help
            ;;
        -d|--domain)
            domain="$2"
            shift
            shift
            ;;
        -f|--file)
            filename="$2"
            shift
            shift
            ;;
        -o|--output)
            output_folder="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $key"
            display_help
            ;;
    esac
done

# Validate input
if [ -z "$domain" ] && [ -z "$filename" ]; then
    echo -e "${RED}Error: Please provide a domain (-d) or a file (-f).${RESET}"
    display_help
fi

# Ensure output folder exists
mkdir -p "$output_folder"



# Step 1: Run URL collection tools
collect_urls() {
    local target=$1
    local output_file=$2


    if [ -n "$target" ]; then
        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using subfinder"
        ~/go/bin/subfinder -d "$target" -o "$output_file"
    
        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using assetfinder"
        ~/go/bin/assetfinder "$target" --subs-only >> "$output_file"
    
        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using amass"
        ~/go/bin/amass enum -d "$target" --passive -config ./config.ini >> "$output_file"
    
        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using assetfinder"
        ~/go/bin/assetfinder "$target" --subs-only >> "$output_file"
    
        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using subfinder"
        ~/go/bin/subfinder -d "$target" >> "$output_file"

        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using amass"
        ~/go/bin/amass enum -d "$target" --passive -config ./config.ini >> "$output_file"

        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using  assetfinder"
        ~/go/bin/assetfinder "$target" --subs-only >> "$output_file"

        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using  subfinder"
        ~/go/bin/subfinder -d "$target" >> "$output_file"

        echo -e "${GREEN}Collecting SubDomains for $target...${RESET} using amass"
        ~/go/bin/amass enum -d "$target" --passive -config ./config.ini >> "$output_file"
        
    else
        echo -e "${RED}Skipping invalid target: $target${RESET}"
    fi
}

if [ -n "$domain" ]; then
    collect_urls "$domain" "$output_folder/domainSubs.txt"
elif [ -n "$filename" ]; then
    while IFS= read -r line; do
        collect_urls "$line" "$output_folder/${line}_raw.txt"
        cat "$output_folder/${line}_raw.txt" >> "$output_folder/all_raw.txt"
    done < "$validated_file"
fi


if [ -n "$domain" ]; then
    sort "$output_folder/domainSubs.txt" | uniq > "$output_folder/domainSubss.txt"
    cat "$output_folder/domainSubss.txt" | ~/go/bin/httpx > "$output_folder/domainSubsLive.txt"
elif [ -n "$filename" ]; then
    sort "$output_folder/all_raw.txt" | uniq > "$output_folder/domainSubss.txt"
    cat "$output_folder/domainSubss.txt" | ~/go/bin/httpx > "$output_folder/domainSubsLive.txt"
fi


# Step 4: Completion message
echo -e "${RED}Scanning completed. Results are saved in $output_folder"
