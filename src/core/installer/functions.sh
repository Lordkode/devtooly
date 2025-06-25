#!/bin/bash

# Source helpers
source "${BASH_SOURCE%/*}/../../../utils/helpers.sh"

# Export des fonctions d'installation
export -f install_base_system
export -f install_languages
export -f install_editors
export -f install_databases
export -f install_containers
export -f install_devtools
export -f install_utilities

# Fonctions d'installation
install_base_system() {
    print_status "Installation des outils de base..."
    
    # Détecter le système
    local os_type=$(get_os_type)
    
    case "$os_type" in
        "$OS_LINUX")
            if command -v apt &> /dev/null; then
                safe_exec "sudo apt update" "Mise à jour des listes de paquets"
                safe_exec "sudo apt install -y curl wget git vim nano htop tree unzip" "Installation des outils de base"
            elif command -v yum &> /dev/null; then
                safe_exec "sudo yum update -y" "Mise à jour des listes de paquets"
                safe_exec "sudo yum install -y curl wget git vim nano htop tree unzip" "Installation des outils de base"
            else
                print_error "Gestionnaire de paquets non supporté"
            fi
            ;;
        "$OS_MACOS")
            if ! command -v brew &> /dev/null; then
                safe_exec "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Installation de Homebrew"
            fi
            safe_exec "brew update" "Mise à jour des listes de paquets"
            safe_exec "brew install curl wget git vim nano htop tree" "Installation des outils de base"
            ;;
        *)
            print_error "Système d'exploitation non supporté: $os_type"
            ;;
    esac
}

install_languages() {
    print_status "Installation des langages de programmation..."
    
    # Source tous les scripts de langages
    for lang in "${!LANGUAGES_CHOICES[@]}"; do
        if [ "${LANGUAGES_CHOICES[$lang]}" = "y" ]; then
            local script_path="${BASH_SOURCE%/*}/../../../modules/languages/${lang,,}.sh"
            if [ -f "$script_path" ]; then
                source "$script_path"
                install_$lang
            else
                print_warning "Script d'installation non trouvé pour $lang"
            fi
                    ;;
                "Go")
                    safe_exec "go version" "Go déjà installé"
                    ;;
                "Rust")
                    safe_exec "rustc --version" "Rust déjà installé"
                    ;;
                "Ruby")
                    safe_exec "ruby --version" "Ruby déjà installé"
                    ;;
                ".NET")
                    safe_exec "dotnet --version" ".NET déjà installé"
                    ;;
            esac
        fi
    done
}

install_editors() {
    print_status "Installation des éditeurs..."
    
    for editor in "${!EDITORS_CHOICES[@]}"; do
        if [ "${EDITORS_CHOICES[$editor]}" = "y" ]; then
            case $editor in
                "vscode")
                    safe_exec "code --version" "VSCode déjà installé"
                    ;;
                "vim")
                    safe_exec "vim --version" "Vim déjà installé"
                    ;;
                "sublime")
                    safe_exec "subl --version" "Sublime Text déjà installé"
                    ;;
                "atom")
                    safe_exec "atom --version" "Atom déjà installé"
                    ;;
                "intellij")
                    safe_exec "idea --version" "IntelliJ déjà installé"
                    ;;
                "webstorm")
                    safe_exec "webstorm --version" "WebStorm déjà installé"
                    ;;
            esac
        fi
    done
}

install_databases() {
    print_status "Installation des bases de données..."
    
    for db in "${!DATABASES_CHOICES[@]}"; do
        if [ "${DATABASES_CHOICES[$db]}" = "y" ]; then
            case $db in
                "mysql")
                    safe_exec "mysql --version" "MySQL déjà installé"
                    ;;
                "postgresql")
                    safe_exec "psql --version" "PostgreSQL déjà installé"
                    ;;
                "mongodb")
                    safe_exec "mongod --version" "MongoDB déjà installé"
                    ;;
                "redis")
                    safe_exec "redis-server --version" "Redis déjà installé"
                    ;;
                "sqlite")
                    safe_exec "sqlite3 --version" "SQLite déjà installé"
                    ;;
                "mariadb")
                    safe_exec "mariadb --version" "MariaDB déjà installé"
                    ;;
            esac
        fi
    done
}

install_containers() {
    print_status "Installation des outils de conteneurisation..."
    
    for container in "${!CONTAINERS_CHOICES[@]}"; do
        if [ "${CONTAINERS_CHOICES[$container]}" = "y" ]; then
            case $container in
                "docker")
                    safe_exec "docker --version" "Docker déjà installé"
                    ;;
                "docker_compose")
                    safe_exec "docker-compose --version" "Docker Compose déjà installé"
                    ;;
                "kubernetes")
                    safe_exec "kubectl version" "Kubernetes déjà installé"
                    ;;
                "vagrant")
                    safe_exec "vagrant --version" "Vagrant déjà installé"
                    ;;
                "virtualbox")
                    safe_exec "VBoxManage --version" "VirtualBox déjà installé"
                    ;;
            esac
        fi
    done
}

install_devtools() {
    print_status "Installation des outils de développement..."
    
    for devtool in "${!DEVTOOLS_CHOICES[@]}"; do
        if [ "${DEVTOOLS_CHOICES[$devtool]}" = "y" ]; then
            case $devtool in
                "git_tools")
                    safe_exec "git --version" "Git déjà installé"
                    ;;
                "postman")
                    safe_exec "postman --version" "Postman déjà installé"
                    ;;
                "insomnia")
                    safe_exec "insomnia --version" "Insomnia déjà installé"
                    ;;
                "terraform")
                    safe_exec "terraform --version" "Terraform déjà installé"
                    ;;
                "ansible")
                    safe_exec "ansible --version" "Ansible déjà installé"
                    ;;
                "jenkins")
                    safe_exec "java -jar jenkins.war --version" "Jenkins déjà installé"
                    ;;
                "build_tools")
                    safe_exec "make --version" "Make déjà installé"
                    ;;
            esac
        fi
    done
}

install_utilities() {
    print_status "Installation des utilitaires..."
    
    for utility in "${!UTILITIES_CHOICES[@]}"; do
        if [ "${UTILITIES_CHOICES[$utility]}" = "y" ]; then
            case $utility in
                "terminal_tools")
                    safe_exec "zsh --version" "Zsh déjà installé"
                    ;;
                "monitoring")
                    safe_exec "htop --version" "htop déjà installé"
                    ;;
                "network_tools")
                    safe_exec "curl --version" "curl déjà installé"
                    ;;
                "file_tools")
                    safe_exec "tree --version" "tree déjà installé"
                    ;;
                "media_tools")
                    safe_exec "ffmpeg -version" "ffmpeg déjà installé"
                    ;;
                "compression")
                    safe_exec "7z --version" "7zip déjà installé"
                    ;;
            esac
        fi
    done
}

install_languages() {
    print_category "INSTALLATION DES LANGAGES"
    
    # Python
    if [ "${LANGUAGES_CHOICES[Python]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/languages/python.sh"
        install_python "$pkg_manager"
    fi
    
    # Node.js
    if [ "${LANGUAGES_CHOICES[Node.js]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/languages/nodejs.sh"
        install_nodejs "$pkg_manager" "$os_type"
    fi
}

install_editors() {
    print_category "INSTALLATION DES ÉDITEURS"
    
    # VSCode
    if [ "${EDITORS_CHOICES[vscode]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/editors/vscode.sh"
        install_vscode "$pkg_manager"
    fi
}

install_databases() {
    print_category "INSTALLATION DES BASES DE DONNÉES"
    
    # PostgreSQL
    if [ "${DATABASES_CHOICES[postgresql]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/databases/postgresql.sh"
        install_postgresql "$pkg_manager"
    fi
}

install_containers() {
    print_category "INSTALLATION DES CONTENEURS"
    
    # Docker
    if [ "${CONTAINERS_CHOICES[docker]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/containers/docker.sh"
        install_docker "$pkg_manager" "$os_type"
    fi
}

install_devtools() {
    print_category "INSTALLATION DES OUTILS DE DÉVELOPPEMENT"
    
    # Git
    if [ "${DEVTOOLS_CHOICES[git_tools]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/devtools/git.sh"
        install_git "$pkg_manager" "$os_type"
        install_github_cli "$pkg_manager"
    fi
}

install_utilities() {
    print_category "INSTALLATION DES UTILITAIRES"
    
    # Zsh
    if [ "${UTILITIES_CHOICES[terminal_tools]}" = "y" ]; then
        source "${BASH_SOURCE%/*}/../../modules/utilities/zsh.sh"
        install_zsh "$pkg_manager" "$os_type"
        install_terminal_tools "$pkg_manager"
    fi
}

post_install_config() {
    print_category "CONFIGURATION POST-INSTALLATION"
    
    # Configuration des alias
    setup_shell_aliases
    
    # Génération du rapport
    generate_report
}

create_dev_directories() {
    print_status "Création des répertoires de développement..."
    
    local dev_dirs=(
        "~/Projects"
        "~/Projects/backend"
        "~/Projects/frontend"
        "~/Projects/fullstack"
        "~/Projects/personnel"
        "~/Projects/professionnel"
    )
    
    for dir in "${dev_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            safe_exec "mkdir -p $dir" "Création du dossier: $dir"
        fi
    done
}

setup_shell_aliases() {
    print_status "Configuration des alias shell..."
    
    local aliases=(
        "alias ll='ls -la'"
        "alias grep='grep --color=auto'"
        "alias df='df -h'"
        "alias du='du -h'"
        "alias ..='cd ..'"
        "alias ...='cd ../..'"
        "alias ....='cd ../../..'"
    )
    
    # Sauvegarde du fichier .bashrc
    if [ -f "~/.bashrc" ]; then
        cp "~/.bashrc" "~/.bashrc.backup"
    fi
    
    # Ajout des alias
    for alias in "${aliases[@]}"; do
        echo "$alias" >> "~/.bashrc"
    done
}

generate_report() {
    print_status "Génération du rapport d'installation..."
    
    local report="Installation de DevTooly - $(date)\n\n"
    
    # Ajout des informations système
    report+="Système:\n"
    report+="OS: $OS\n"
    report+="Gestionnaire de paquets: $PACKAGE_MANAGER\n\n"
    
    # Ajout des choix d'installation
    report+="Composants installés:\n"
    report+="- Langages: ${LANGUAGES_CHOICES[*]}\n"
    report+="- Éditeurs: ${EDITORS_CHOICES[*]}\n"
    report+="- Bases de données: ${DATABASES_CHOICES[*]}\n"
    report+="- Conteneurs: ${CONTAINERS_CHOICES[*]}\n"
    report+="- Outils de développement: ${DEVTOOLS_CHOICES[*]}\n"
    report+="- Utilitaires: ${UTILITIES_CHOICES[*]}\n"
    
    # Sauvegarde du rapport
    echo -e "$report" > "$LOG_DIR/install_report.txt"
}

# Export des fonctions
export -f install_base_system
export -f configure_environment
export -f install_languages
export -f install_editors
export -f install_databases
export -f install_containers
export -f install_devtools
export -f install_utilities
export -f post_install_config
export -f create_dev_directories
export -f setup_shell_aliases
export -f generate_report
