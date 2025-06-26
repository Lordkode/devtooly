#!/bin/bash

# Source les fonctions d'installation
source "${BASH_SOURCE%/*}/../../lib/utils.sh"

# Installation de Python
install_python() {
    local os_type=$(get_os_type)
    
    case "$os_type" in
        "$OS_LINUX")
            if command -v apt &> /dev/null; then
                safe_exec "sudo apt install -y python3 python3-pip" "Installation de Python"
                safe_exec "sudo apt install -y python3-venv" "Installation de venv"
            elif command -v yum &> /dev/null; then
                safe_exec "sudo yum install -y python3 python3-pip" "Installation de Python"
                safe_exec "sudo yum install -y python3-virtualenv" "Installation de venv"
            fi
            ;;
        "$OS_MACOS")
            if command -v brew &> /dev/null; then
                safe_exec "brew install python@3.11" "Installation de Python"
            fi
            ;;
    esac
    
    # Installation de pipx
    if ! command -v pipx &> /dev/null; then
        safe_exec "pip3 install --user pipx" "Installation de pipx"
        safe_exec "python3 -m pipx ensurepath" "Configuration de pipx"
    fi
}

# Export de la fonction
export -f install_python
