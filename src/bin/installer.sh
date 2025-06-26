#!/bin/bash

# Source les fonctions d'installation
source "${BASH_SOURCE%/*}/../lib/utils.sh"
source "${BASH_SOURCE%/*}/modules/languages/functions.sh"
source "${BASH_SOURCE%/*}/modules/editors/functions.sh"
source "${BASH_SOURCE%/*}/modules/databases/functions.sh"
source "${BASH_SOURCE%/*}/modules/containers/functions.sh"
source "${BASH_SOURCE%/*}/modules/devtools/functions.sh"
source "${BASH_SOURCE%/*}/modules/utilities/functions.sh"

# Fonction principale d'installation
installer_main() {
    print_status "Installation de DevTooly $APP_VERSION..."
    
    # Mise à jour du système
    update_system
    
    # Installation des outils de base
    install_base_system
    
    # Installation des composants sélectionnés
    install_selected_components
    
    # Configuration post-installation
    post_install_config
    
    print_status "Installation terminée !"
}

# Mise à jour du système
update_system() {
    local os_type=$(get_os_type)
    
    case "$os_type" in
        "$OS_LINUX")
            if command -v apt &> /dev/null; then
                safe_exec "sudo apt update && sudo apt upgrade -y" "Mise à jour du système"
            elif command -v yum &> /dev/null; then
                safe_exec "sudo yum update -y" "Mise à jour du système"
            fi
            ;;
        "$OS_MACOS")
            if command -v brew &> /dev/null; then
                safe_exec "brew update && brew upgrade" "Mise à jour du système"
            fi
            ;;
    esac
}

# Installation des composants sélectionnés
install_selected_components() {
    # Langages
    for lang in "${!LANGUAGES_CHOICES[@]}"; do
        if [ "${LANGUAGES_CHOICES[$lang]}" = "y" ]; then
            install_language "$lang"
        fi
    done
    
    # Éditeurs
    for editor in "${!EDITORS_CHOICES[@]}"; do
        if [ "${EDITORS_CHOICES[$editor]}" = "y" ]; then
            install_editor "$editor"
        fi
    done
    
    # Bases de données
    for db in "${!DATABASES_CHOICES[@]}"; do
        if [ "${DATABASES_CHOICES[$db]}" = "y" ]; then
            install_database "$db"
        fi
    done
    
    # Conteneurs
    for container in "${!CONTAINERS_CHOICES[@]}"; do
        if [ "${CONTAINERS_CHOICES[$container]}" = "y" ]; then
            install_container "$container"
        fi
    done
    
    # Outils de développement
    for devtool in "${!DEVTOOLS_CHOICES[@]}"; do
        if [ "${DEVTOOLS_CHOICES[$devtool]}" = "y" ]; then
            install_devtool "$devtool"
        fi
    done
    
    # Utilitaires
    for utility in "${!UTILITIES_CHOICES[@]}"; do
        if [ "${UTILITIES_CHOICES[$utility]}" = "y" ]; then
            install_utility "$utility"
        fi
    done
}

# Export des fonctions
export -f installer_main update_system install_selected_components
