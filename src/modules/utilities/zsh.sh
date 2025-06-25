#!/bin/bash

source "${BASH_SOURCE%/*}/../../core/utils/helpers.sh"

install_zsh() {
    local pkg_manager="$1"
    local os_type="$2"
    
    print_status "Installation de Zsh..."
    
    case "$pkg_manager" in
        "$PKG_APT")
            safe_exec "sudo apt install -y zsh" \
                "Installation de Zsh"
            ;;
        "$PKG_YUM")
            safe_exec "sudo yum install -y zsh" \
                "Installation de Zsh"
            ;;
        "$PKG_BREW")
            safe_exec "brew install zsh" \
                "Installation de Zsh"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
    
    # Installation de oh-my-zsh
    if command -v zsh &> /dev/null; then
        safe_exec "sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"yes\"" \
            "Installation de oh-my-zsh"
            
        # Installation des plugins
        local plugins=(
            "git"
            "docker"
            "docker-compose"
            "kubernetes"
            "npm"
            "python"
            "ruby"
            "node"
        )
        
        local plugins_string=""
        for plugin in "${plugins[@]}"; do
            plugins_string+="$plugin "
        done
        
        # Configuration des plugins
        if [ -f "~/.zshrc" ]; then
            safe_exec "sed -i 's/^plugins=(.*)/plugins=($plugins_string)/' ~/.zshrc" \
                "Configuration des plugins oh-my-zsh"
        fi
    fi
    
    # Configuration de Zsh comme shell par défaut
    if [ "$os_type" = "$OS_LINUX" ]; then
        safe_exec "sudo chsh -s $(which zsh) $USER" \
            "Configuration de Zsh comme shell par défaut"
        print_warning "Veuillez vous déconnecter et reconnecter pour que les changements prennent effet"
    fi
}

install_terminal_tools() {
    local pkg_manager="$1"
    
    print_status "Installation des outils de terminal..."
    
    local tools=(
        "htop"
        "btop"
        "glances"
        "tree"
        "fd"
        "ripgrep"
        "bat"
        "exa"
        "zellij"
    )
    
    case "$pkg_manager" in
        "$PKG_APT")
            safe_exec "sudo apt install -y ${tools[*]}" \
                "Installation des outils de terminal"
            ;;
        "$PKG_YUM")
            safe_exec "sudo yum install -y ${tools[*]}" \
                "Installation des outils de terminal"
            ;;
        "$PKG_BREW")
            safe_exec "brew install ${tools[*]}" \
                "Installation des outils de terminal"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
}

# Export des fonctions
export -f install_zsh
export -f install_terminal_tools
