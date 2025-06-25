#!/bin/bash

source "${BASH_SOURCE%/*}/../../core/utils/helpers.sh"

install_docker() {
    local pkg_manager="$1"
    local os_type="$2"
    
    print_status "Installation de Docker..."
    
    case "$os_type" in
        "$OS_LINUX")
            # Installation des dépendances
            safe_exec "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release" \
                "Installation des dépendances Docker"
            
            # Ajout de la clé GPG
            safe_exec "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg" \
                "Ajout de la clé GPG Docker"
            
            # Ajout du repository
            safe_exec "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null" \
                "Ajout du repository Docker"
            
            # Installation de Docker
            safe_exec "sudo apt-get update" \
                "Mise à jour des listes de paquets"
            safe_exec "sudo apt-get install -y docker-ce docker-ce-cli containerd.io" \
                "Installation de Docker"
            ;;
        "$OS_MACOS")
            if [ "$pkg_manager" = "$PKG_BREW" ]; then
                safe_exec "brew install --cask docker" \
                    "Installation de Docker Desktop"
            else
                print_error "Homebrew requis pour l'installation sur macOS"
            fi
            ;;
        *)
            print_error "OS non supporté: $os_type"
            ;;
    esac
    
    # Ajout de l'utilisateur au groupe docker
    if [ "$os_type" = "$OS_LINUX" ]; then
        safe_exec "sudo usermod -aG docker $USER" \
            "Ajout de l'utilisateur au groupe docker"
        print_warning "Veuillez vous déconnecter et reconnecter pour que les changements prennent effet"
    fi
    
    # Installation de Docker Compose
    if [ "$os_type" = "$OS_LINUX" ]; then
        local compose_version="1.29.2"
        safe_exec "sudo curl -L \"https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose" \
            "Installation de Docker Compose"
        safe_exec "sudo chmod +x /usr/local/bin/docker-compose" \
            "Configuration des permissions de Docker Compose"
    elif [ "$os_type" = "$OS_MACOS" ]; then
        safe_exec "brew install docker-compose" \
            "Installation de Docker Compose"
    fi
}

# Export des fonctions
export -f install_docker
