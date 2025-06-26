#!/bin/bash

# Source les fonctions de configuration
source "${BASH_SOURCE%/*}/../lib/utils.sh"
source "${BASH_SOURCE%/*}/../lib/config.sh"

# Fonction de configuration
configurator_main() {
    print_status "Configuration de DevTooly $APP_VERSION..."
    
    # Affichage du menu de configuration
    show_config_menu
    
    # Sauvegarde des choix
    save_choices
    
    print_status "Configuration terminée !"
}

# Affichage du menu de configuration
show_config_menu() {
    while true; do
        clear
        echo "===================="
        echo " Configuration DevTooly "
        echo "===================="
        echo ""
        
        # Affichage des sections
        show_section "Langages" "LANGUAGES_CHOICES"
        show_section "Éditeurs" "EDITORS_CHOICES"
        show_section "Bases de données" "DATABASES_CHOICES"
        show_section "Conteneurs" "CONTAINERS_CHOICES"
        show_section "Outils de développement" "DEVTOOLS_CHOICES"
        show_section "Utilitaires" "UTILITIES_CHOICES"
        
        echo ""
        echo "0. Sauvegarder et quitter"
        
        read -p "Choisissez une option : " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            handle_choice "$choice"
        else
            print_warning "Option invalide"
        fi
    done
}

# Affichage d'une section
show_section() {
    local title="$1"
    local array_name="$2"
    
    echo ""
    echo "$title"
    echo "$(printf '%0.s=' {1..${#title}})"
    
    declare -n choices=$array_name
    local index=1
    
    for choice in "${!choices[@]}"; do
        echo "$index. $choice (${choices[$choice]})"
        ((index++))
    done
}

# Gestion d'une option
handle_choice() {
    local choice="$1"
    
    case "$choice" in
        0)
            break
            ;;
        *)
            # TODO: Implémenter la logique de sélection
            ;;
    esac
}

# Sauvegarde des choix
save_choices() {
    # TODO: Implémenter la sauvegarde des choix
    print_status "Sauvegarde des choix..."
}

# Export des fonctions
export -f configurator_main show_config_menu show_section handle_choice save_choices
