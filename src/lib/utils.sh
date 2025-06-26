#!/bin/bash

# Source la configuration
source "${BASH_SOURCE%/*}/config.sh"

# Fonctions de logging
print_status() {
    echo -e "\e[32m[✓] $1\e[0m"
}

print_warning() {
    echo -e "\e[33m[!] $1\e[0m"
}

print_error() {
    echo -e "\e[31m[✗] $1\e[0m"
}

# Fonctions système
get_os_type() {
    local os_type=""
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os_type="$OS_LINUX"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os_type="$OS_MACOS"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
        os_type="$OS_WINDOWS"
    else
        print_error "Système d'exploitation non supporté: $OSTYPE"
        exit 1
    fi
    
    echo "$os_type"
}

safe_exec() {
    local cmd="$1"
    local msg="$2"
    
    if eval "$cmd"; then
        print_status "$msg"
    else
        print_error "$msg a échoué"
        exit 1
    fi
}

# Fonctions d'installation
install_package() {
    local pkg_manager="$1"
    local package="$2"
    
    case "$pkg_manager" in
        "apt")
            safe_exec "sudo apt install -y $package" "Installation de $package"
            ;;
        "yum")
            safe_exec "sudo yum install -y $package" "Installation de $package"
            ;;
        "brew")
            safe_exec "brew install $package" "Installation de $package"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
}

# Export des fonctions
export -f print_status print_warning print_error
export -f get_os_type safe_exec install_package
