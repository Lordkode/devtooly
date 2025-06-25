#!/bin/bash

# Source constants
source "${BASH_SOURCE%/*}/constants.sh"

# Logging functions
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                        🛠️  DEVTOOLY 🛠️                        ║"
    echo "║          Script d'installation interactive pour devs         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_category() {
    echo -e "\n${BOLD}${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BOLD}${BLUE} 📦 $1${NC}"
    echo -e "${BOLD}${BLUE}════════════════════════════════════════${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$DEFAULT_LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$DEFAULT_LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$DEFAULT_LOG_FILE"
    exit $ERROR
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$DEFAULT_LOG_FILE"
}

# Input validation
validate_input() {
    local input="$1"
    local pattern="$2"
    
    if ! [[ "$input" =~ $pattern ]]; then
        print_error "Input validation failed: $input does not match pattern: $pattern"
    fi
}

# OS detection
get_os_type() {
    local os_type=""
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os_type="$OS_LINUX"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os_type="$OS_MACOS"
    else
        print_error "Unsupported OS: $OSTYPE"
    fi
    
    echo "$os_type"
}

# Package manager detection
detect_package_manager() {
    local os_type="$1"
    local pkg_manager=""
    
    case "$os_type" in
        "$OS_LINUX")
            if command -v apt &> /dev/null; then
                pkg_manager="$PKG_APT"
            elif command -v yum &> /dev/null; then
                pkg_manager="$PKG_YUM"
            else
                print_error "No supported package manager found for Linux"
            fi
            ;;
        "$OS_MACOS")
            if command -v brew &> /dev/null; then
                pkg_manager="$PKG_BREW"
            else
                print_error "Homebrew not found. Please install Homebrew first."
            fi
            ;;
        *)
            print_error "Unsupported OS type: $os_type"
            ;;
    esac
    
    echo "$pkg_manager"
}

# Command execution with error handling
safe_exec() {
    local cmd="$1"
    local msg="$2"
    
    if [ "$DEFAULT_DRY_RUN" = true ]; then
        print_status "[DRY-RUN] Would execute: $cmd"
        return $SUCCESS
    fi
    
    print_status "$msg"
    
    if ! eval "$cmd"; then
        print_error "Failed to execute: $cmd"
    fi
}

# User interaction
ask_yes_no() {
    local question="$1"
    local default="$2"
    local response=""
    
    if [ "$AUTO_MODE" = true ]; then
        echo -e "${YELLOW}[AUTO]${NC} $question -> $default"
        echo "$default"
        return
    fi
    
    while true; do
        read -p "$question [y/n] (default: $default): " response
        
        if [ -z "$response" ]; then
            response="$default"
        fi
        
        case $response in
            [Yy]* ) echo "y"; break;;
            [Oo]* ) echo "y"; break;;  # Support for French "oui"
            [Nn]* ) echo "n"; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Export all functions
export -f print_banner
export -f print_category
export -f print_status
export -f print_success
export -f print_error
export -f print_warning
export -f validate_input
export -f get_os_type
export -f detect_package_manager
export -f safe_exec
export -f ask_yes_no
