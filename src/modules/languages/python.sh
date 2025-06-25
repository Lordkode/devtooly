#!/bin/bash

source "${BASH_SOURCE%/*}/../../core/utils/helpers.sh"

install_python() {
    local pkg_manager="$1"
    
    print_status "Installation de Python..."
    
    case "$pkg_manager" in
        "$PKG_APT")
            safe_exec "sudo apt install -y python3 python3-pip python3-venv python3-dev" \
                "Installation des composants Python"
            ;;
        "$PKG_YUM")
            safe_exec "sudo yum install -y python3 python3-pip python3-devel" \
                "Installation des composants Python"
            ;;
        "$PKG_BREW")
            safe_exec "brew install python" \
                "Installation de Python"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
    
    # Installation des packages Python
    if command -v pip3 &> /dev/null; then
        local python_packages="virtualenv pipenv poetry requests flask django fastapi"
        safe_exec "pip3 install --user $python_packages" \
            "Installation des packages Python"
    else
        print_warning "pip3 non disponible, saut des packages Python"
    fi
}

# Export des fonctions
export -f install_python
