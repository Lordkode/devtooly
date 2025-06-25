#!/bin/bash

source "${BASH_SOURCE%/*}/../../core/utils/helpers.sh"

install_vscode() {
    local pkg_manager="$1"
    
    print_status "Installation de Visual Studio Code..."
    
    case "$pkg_manager" in
        "$PKG_APT")
            # Ajout du repository Microsoft
            safe_exec "curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg" \
                "Ajout de la clé Microsoft"
            safe_exec "sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/" \
                "Installation de la clé"
            safe_exec "sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'" \
                "Ajout du repository VSCode"
            safe_exec "sudo apt update" \
                "Mise à jour des listes de paquets"
            safe_exec "sudo apt install -y code" \
                "Installation de VSCode"
            ;;
        "$PKG_YUM")
            safe_exec "sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc" \
                "Ajout de la clé Microsoft"
            safe_exec "sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'" \
                "Ajout du repository VSCode"
            safe_exec "sudo yum check-update" \
                "Mise à jour des listes de paquets"
            safe_exec "sudo yum install -y code" \
                "Installation de VSCode"
            ;;
        "$PKG_BREW")
            safe_exec "brew install --cask visual-studio-code" \
                "Installation de VSCode via Homebrew"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
    
    # Installation des extensions VSCode
    if command -v code &> /dev/null; then
        local extensions=(
            "ms-python.python"
            "ms-python.vscode-pylance"
            "ms-python.black-formatter"
            "ms-python.isort"
            "ms-python.flake8"
            "ms-python.mypy-type-checker"
            "ms-python.debugpy"
            "ms-python.vscode-jupyter"
            "ms-python.vscode-jupyter-cell-tags"
            "ms-python.vscode-jupyter-slideshow"
            "ms-python.vscode-pylance"
            "ms-python.vscode-django"
            "ms-python.vscode-pylance"
            "ms-python.vscode-django"
            "ms-python.vscode-pylance"
            "ms-python.vscode-django"
            "ms-python.vscode-pylance"
            "ms-python.vscode-django"
        )
        
        for ext in "${extensions[@]}"; do
            safe_exec "code --install-extension $ext" \
                "Installation de l'extension: $ext"
        done
    fi
}

# Export des fonctions
export -f install_vscode
