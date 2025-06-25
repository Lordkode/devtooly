#!/bin/bash

source "${BASH_SOURCE%/*}/../../core/utils/helpers.sh"

install_postgresql() {
    local pkg_manager="$1"
    
    print_status "Installation de PostgreSQL..."
    
    case "$pkg_manager" in
        "$PKG_APT")
            safe_exec "sudo apt install -y postgresql postgresql-contrib" \
                "Installation de PostgreSQL"
            ;;
        "$PKG_YUM")
            safe_exec "sudo yum install -y postgresql postgresql-server postgresql-contrib" \
                "Installation de PostgreSQL"
            ;;
        "$PKG_BREW")
            safe_exec "brew install postgresql@14" \
                "Installation de PostgreSQL via Homebrew"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
    
    # Initialisation du cluster PostgreSQL
    if [ "$pkg_manager" = "$PKG_BREW" ]; then
        safe_exec "brew services start postgresql@14" \
            "Démarrage du service PostgreSQL"
    else
        safe_exec "sudo systemctl enable postgresql" \
            "Activation du service PostgreSQL au démarrage"
        safe_exec "sudo systemctl start postgresql" \
            "Démarrage du service PostgreSQL"
    fi
    
    # Configuration initiale
    if command -v psql &> /dev/null; then
        # Création d'un utilisateur PostgreSQL
        safe_exec "sudo -u postgres createuser -s $USER" \
            "Création d'un utilisateur PostgreSQL"
        
        # Configuration de pg_hba.conf
        local pg_hba_conf="/etc/postgresql/14/main/pg_hba.conf"
        if [ -f "$pg_hba_conf" ]; then
            safe_exec "sudo sed -i 's/peer/trust/' $pg_hba_conf" \
                "Configuration de l'authentification PostgreSQL"
        fi
    fi
}

# Export des fonctions
export -f install_postgresql
