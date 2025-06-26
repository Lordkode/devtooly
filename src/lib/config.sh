#!/bin/bash

# Configuration générale
readonly APP_NAME="DevTooly"
readonly APP_VERSION="1.0.0"
readonly LOG_DIR="$HOME/.devtooly/logs"
readonly CACHE_DIR="$HOME/.devtooly/cache"

# Types de systèmes supportés
readonly OS_LINUX="linux"
readonly OS_MACOS="macos"
readonly OS_WINDOWS="windows"

# État des choix utilisateur
declare -A LANGUAGES_CHOICES
declare -A EDITORS_CHOICES
declare -A DATABASES_CHOICES
declare -A CONTAINERS_CHOICES
declare -A DEVTOOLS_CHOICES
declare -A UTILITIES_CHOICES

# Fonctions de configuration
init_config() {
    # Création des dossiers nécessaires
    mkdir -p "$LOG_DIR" "$CACHE_DIR"
    
    # Initialisation des choix par défaut
    for array in LANGUAGES_CHOICES EDITORS_CHOICES DATABASES_CHOICES \
                CONTAINERS_CHOICES DEVTOOLS_CHOICES UTILITIES_CHOICES; do
        declare -n choices=$array
        for choice in "${!choices[@]}"; do
            choices[$choice]="n"
        done
    done
}

# Export des variables et fonctions
export APP_NAME APP_VERSION LOG_DIR CACHE_DIR
export OS_LINUX OS_MACOS OS_WINDOWS
export -f init_config
