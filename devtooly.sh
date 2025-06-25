#!/bin/bash

# Source core utilities
source "src/core/utils/helpers.sh"
source "src/core/ui/interactive.sh"

# Global variables
DRY_RUN=false
AUTO_MODE=false

# Arrays pour stocker les choix
declare -A LANGUAGES_CHOICES
declare -A EDITORS_CHOICES
declare -A DATABASES_CHOICES
declare -A DEVTOOLS_CHOICES
declare -A CONTAINERS_CHOICES
declare -A UTILITIES_CHOICES

# Configuration des choix utilisateur
configure_choices() {
    # Mode interactif - demander les choix à l'utilisateur
    interactive_main
}

# Main function
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                echo "Usage: $0"
                echo "  --help    Afficher ce message d'aide"
                exit 0
                ;;
            *)
                echo "Option inconnue: $1"
                exit 1
                ;;
        esac
        shift
    done
    
    # Configure choices
    configure_choices
    
    # Run installation steps
    install_base_system
    install_languages
    install_editors
    install_databases
    install_containers
    install_devtools
    install_utilities
    
    echo -e "${BOLD}${GREEN}Installation terminée avec succès !${NC}"
}

# Error handling
trap 'echo -e "\n${BOLD}${RED}Installation interrompue${NC}"; exit 1' INT TERM

# Execute main
main "$@"
