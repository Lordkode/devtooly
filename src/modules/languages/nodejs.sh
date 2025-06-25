#!/bin/bash

source "${BASH_SOURCE%/*}/../../core/utils/helpers.sh"

install_nodejs() {
    local pkg_manager="$1"
    local os_type="$2"
    
    print_status "Installation de Node.js..."
    
    if [ "$os_type" = "$OS_MACOS" ]; then
        if [ "$pkg_manager" = "$PKG_BREW" ]; then
            safe_exec "brew install node" \
                "Installation de Node.js via Homebrew"
        else
            print_error "Homebrew requis pour l'installation sur macOS"
        fi
    else
        # Configuration NodeSource
        safe_exec "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -" \
            "Configuration NodeSource"
            
        case "$pkg_manager" in
            "$PKG_APT")
                safe_exec "sudo apt install -y nodejs" \
                    "Installation de Node.js"
                ;;
            "$PKG_YUM")
                safe_exec "sudo yum install -y nodejs npm" \
                    "Installation de Node.js et npm"
                ;;
            "$PKG_BREW")
                safe_exec "brew install node" \
                    "Installation de Node.js via Homebrew"
                ;;
            *)
                print_error "Gestionnaire de paquets non supporté: $pkg_manager"
                ;;
        esac
    fi
    
    # Installation des packages npm globaux
    if command -v npm &> /dev/null; then
        local npm_packages="yarn pnpm typescript @angular/cli create-react-app vue-cli nodemon pm2"
        safe_exec "npm install -g $npm_packages" \
            "Installation des packages npm globaux"
    else
        print_warning "npm non disponible, saut des packages npm"
    fi
}

# Export des fonctions
export -f install_nodejs
