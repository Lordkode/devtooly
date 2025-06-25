#!/bin/bash

# Export des fonctions nécessaires
export -f show_category_options
export -f show_choices_summary
export -f confirm_choices
export -f interactive_main

# Import des fonctions nécessaires
source "${BASH_SOURCE%/*}/../../../utils/helpers.sh"
source "${BASH_SOURCE%/*}/../../../installer/functions.sh"

# Fonction pour afficher une catégorie avec ses options
show_category_options() {
    local category="$1"
    local options=($2)
    local default_values=($3)
    
    echo -e "${BOLD}${BLUE}=== $category ===${NC}\n"
    
    local i=0
    for option in "${options[@]}"; do
        local default=${default_values[$i]}
        
        # Poser la question
        echo -e "${BOLD}${YELLOW} Installer $option ?${NC}"
        local response=$(ask_yes_no "" "$default")
        
        # Stocker la réponse
        case $category in
            "LANGUAGES")
                LANGUAGES_CHOICES[$option]="$response"
                ;;
            "EDITORS")
                EDITORS_CHOICES[$option]="$response"
                ;;
            "DATABASES")
                DATABASES_CHOICES[$option]="$response"
                ;;
            "CONTAINERS")
                CONTAINERS_CHOICES[$option]="$response"
                ;;
            "DEVTOOLS")
                DEVTOOLS_CHOICES[$option]="$response"
                ;;
            "UTILITIES")
                UTILITIES_CHOICES[$option]="$response"
                ;;
        esac
        
        echo
        ((i++))
    done
}

# Fonction pour afficher le résumé des choix
show_choices_summary() {
    echo -e "${BOLD}${BLUE}=== RÉCAPITULATIF DES CHOIX ===${NC}\n"
    
    # Fonction pour afficher une catégorie
    show_category() {
        local category="$1"
        local choices=$2
        
        echo -e "${BOLD}${BLUE}  $category:${NC}"
        
        # Récupérer les clés du tableau associatif
        case $category in
            "LANGUAGES")
                for choice in "${!LANGUAGES_CHOICES[@]}"; do
                    if [ "${LANGUAGES_CHOICES[$choice]}" = "y" ]; then
                        echo -e "    ${GREEN}✓${NC} $choice"
                    fi
                done
                ;;
            "EDITORS")
                for choice in "${!EDITORS_CHOICES[@]}"; do
                    if [ "${EDITORS_CHOICES[$choice]}" = "y" ]; then
                        echo -e "    ${GREEN}✓${NC} $choice"
                    fi
                done
                ;;
            "DATABASES")
                for choice in "${!DATABASES_CHOICES[@]}"; do
                    if [ "${DATABASES_CHOICES[$choice]}" = "y" ]; then
                        echo -e "    ${GREEN}✓${NC} $choice"
                    fi
                done
                ;;
            "CONTAINERS")
                for choice in "${!CONTAINERS_CHOICES[@]}"; do
                    if [ "${CONTAINERS_CHOICES[$choice]}" = "y" ]; then
                        echo -e "    ${GREEN}✓${NC} $choice"
                    fi
                done
                ;;
            "DEVTOOLS")
                for choice in "${!DEVTOOLS_CHOICES[@]}"; do
                    if [ "${DEVTOOLS_CHOICES[$choice]}" = "y" ]; then
                        echo -e "    ${GREEN}✓${NC} $choice"
                    fi
                done
                ;;
            "UTILITIES")
                for choice in "${!UTILITIES_CHOICES[@]}"; do
                    if [ "${UTILITIES_CHOICES[$choice]}" = "y" ]; then
                        echo -e "    ${GREEN}✓${NC} $choice"
                    fi
                done
                ;;
        esac
        echo
    }
    
    # Afficher toutes les catégories
    show_category "LANGUAGES" "${!LANGUAGES_CHOICES[@]}"
    show_category "EDITORS" "${!EDITORS_CHOICES[@]}"
    show_category "DATABASES" "${!DATABASES_CHOICES[@]}"
    show_category "CONTAINERS" "${!CONTAINERS_CHOICES[@]}"
    show_category "DEVTOOLS" "${!DEVTOOLS_CHOICES[@]}"
    show_category "UTILITIES" "${!UTILITIES_CHOICES[@]}"
}

# Fonction pour confirmer les choix
confirm_choices() {
    echo -e "${BOLD}${BLUE}=== CONFIRMATION ===${NC}\n"
    
    # Afficher le résumé
    show_choices_summary
    
    # Demander confirmation
    local confirm=$(ask_yes_no "Confirmez-vous ces choix ?" "y")
    
    if [ "$confirm" = "n" ]; then
        echo -e "${BOLD}${RED}Installation annulée. Redémarrez le script pour modifier vos choix.${NC}"
        exit 1
    fi
}

# Fonction principale d'interface utilisateur
interactive_main() {
    # Langages
    local languages=(
        "Python" "Node.js" "PHP" "Java" "Go" "Rust" "Ruby" ".NET"
    )
    local languages_defaults=(
        "n" "n" "n" "n" "n" "n" "n" "n"
    )
    
    # Éditeurs
    local editors=(
        "vscode" "vim" "sublime" "atom" "intellij" "webstorm"
    )
    local editors_defaults=(
        "n" "n" "n" "n" "n" "n"
    )
    
    # Bases de données
    local databases=(
        "mysql" "postgresql" "mongodb" "redis" "sqlite" "mariadb"
    )
    local databases_defaults=(
        "n" "n" "n" "n" "n" "n"
    )
    
    # Conteneurs
    local containers=(
        "docker" "docker_compose" "kubernetes" "vagrant" "virtualbox"
    )
    local containers_defaults=(
        "n" "n" "n" "n" "n"
    )
    
    # Outils de développement
    local devtools=(
        "git_tools" "postman" "insomnia" "terraform" "ansible" "jenkins" "build_tools"
    )
    local devtools_defaults=(
        "n" "n" "n" "n" "n" "n" "n"
    )
    
    # Utilitaires
    local utilities=(
        "terminal_tools" "monitoring" "network_tools" "file_tools" "media_tools" "compression"
    )
    local utilities_defaults=(
        "n" "n" "n" "n" "n" "n"
    )
    
    # Afficher chaque catégorie
    echo -e "${BOLD}${BLUE}=== CONFIGURATION DES CHOIX ===${NC}\n"
    show_category_options "LANGUAGES" "${languages[*]}" "${languages_defaults[*]}"
    show_category_options "EDITORS" "${editors[*]}" "${editors_defaults[*]}"
    show_category_options "DATABASES" "${databases[*]}" "${databases_defaults[*]}"
    show_category_options "CONTAINERS" "${containers[*]}" "${containers_defaults[*]}"
    show_category_options "DEVTOOLS" "${devtools[*]}" "${devtools_defaults[*]}"
    show_category_options "UTILITIES" "${utilities[*]}" "${utilities_defaults[*]}"
    
    # Confirmer les choix
    confirm_choices
}

# Export des fonctions
export -f show_category_options
export -f show_choices_summary
export -f confirm_choices
export -f interactive_main
