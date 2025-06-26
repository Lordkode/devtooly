#!/bin/bash

# Source les bibliothèques
source "${BASH_SOURCE%/*}/../lib/config.sh"
source "${BASH_SOURCE%/*}/../lib/utils.sh"

# Initialisation
init_config

# Fonction principale
devtooly_main() {
    local cmd="$1"
    
    case "$cmd" in
        "install")
            source "${BASH_SOURCE%/*}/installer.sh"
            installer_main
            ;;
        "config")
            source "${BASH_SOURCE%/*}/configurator.sh"
            configurator_main
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Commande inconnue: $cmd"
            show_help
            ;;
    esac
}

# Affichage de l'aide
show_help() {
    echo "Usage: devtooly [command]"
    echo ""
    echo "Commandes disponibles:"
    echo "  install    Installer les outils de développement"
    echo "  config     Configurer les choix d'installation"
    echo "  help       Afficher ce message d'aide"
}

# Exécution du script
devtooly_main "$@"
