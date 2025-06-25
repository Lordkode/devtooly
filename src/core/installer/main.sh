#!/bin/bash

source "${BASH_SOURCE%/*}/../../utils/helpers.sh"

# Configuration des choix utilisateur
configure_choices() {
    print_status "Configuration des choix utilisateur..."
    
    # Langages
    configure_languages
    
    # Éditeurs
    configure_editors
    
    # Bases de données
    configure_databases
    
    # Conteneurs
    configure_containers
    
    # Outils de développement
    configure_devtools
    
    # Utilitaires
    configure_utilities
    
    # Affichage du résumé
    show_summary
}

# Installation des composants
install_components() {
    local pkg_manager="$1"
    local os_type="$2"
    
    print_status "Installation des composants..."
    
    # Mise à jour du système
    update_system "$pkg_manager"
    
    # Installation des outils de base
    install_base_tools "$pkg_manager"
    
    # Installation des langages
    if [ "${LANGUAGES_CHOICES[Python]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/languages/python.sh"
        install_python "$pkg_manager"
    fi
    
    if [ "${LANGUAGES_CHOICES[Node.js]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/languages/nodejs.sh"
        install_nodejs "$pkg_manager" "$os_type"
    fi
    
    # Installation des éditeurs
    if [ "${EDITORS_CHOICES[vscode]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/editors/vscode.sh"
        install_vscode "$pkg_manager"
    fi
    
    # Installation des bases de données
    if [ "${DATABASES_CHOICES[postgresql]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/databases/postgresql.sh"
        install_postgresql "$pkg_manager"
    fi
    
    # Installation des conteneurs
    if [ "${CONTAINERS_CHOICES[docker]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/containers/docker.sh"
        install_docker "$pkg_manager" "$os_type"
    fi
    
    # Installation des outils de développement
    if [ "${DEVTOOLS_CHOICES[git_tools]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/devtools/git.sh"
        install_git "$pkg_manager" "$os_type"
        install_github_cli "$pkg_manager"
    fi
    
    # Installation des utilitaires
    if [ "${UTILITIES_CHOICES[terminal_tools]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/utilities/zsh.sh"
        install_zsh "$pkg_manager" "$os_type"
        install_terminal_tools "$pkg_manager"
    fi
}

# Configuration post-installation
post_install() {
    print_status "Configuration post-installation..."
    
    # Création des répertoires de développement
    create_dev_directories
    
    # Configuration des alias shell
    setup_shell_aliases
    
    # Configuration post-installation
    post_install_config
    
    # Génération du rapport
    generate_report
}

# Fonction principale d'installation
installer_main() {
    # Détection de l'OS et du gestionnaire de paquets
    local os_type=$(get_os_type)
    local pkg_manager=$(detect_package_manager "$os_type")
    
    # Configuration des choix
    configure_choices
    
    # Installation des composants
    install_components "$pkg_manager" "$os_type"
    
    # Configuration post-installation
    post_install
}

# Export des fonctions
export -f installer_main
