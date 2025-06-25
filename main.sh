#!/bin/bash

# devtooly - Script d'installation interactif pour environnement de développement
# Usage: ./devtooly.sh [--auto] [--dry-run]

set -e  # Arrêt en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Variables
DRY_RUN=false
AUTO_MODE=false
LOG_FILE="devtooly_$(date +%Y%m%d_%H%M%S).log"

# Arrays pour stocker les choix
declare -A LANGUAGES_CHOICES
declare -A EDITORS_CHOICES
declare -A DATABASES_CHOICES
declare -A DEVTOOLS_CHOICES
declare -A CONTAINERS_CHOICES
declare -A UTILITIES_CHOICES

# Fonction d'affichage
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                        🛠️  DEVTOOLY 🛠️                        ║"
    echo "║          Script d'installation interactif pour devs         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_category() {
    echo -e "\n${BOLD}${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BOLD}${BLUE} 📦 $1${NC}"
    echo -e "${BOLD}${BLUE}════════════════════════════════════════${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

# Fonction pour poser une question oui/non
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local response
    
    if [ "$AUTO_MODE" = true ]; then
        echo -e "${YELLOW}[AUTO]${NC} $question -> $default"
        echo "$default"
        return
    fi
    
    while true; do
        if [ "$default" = "y" ]; then
            echo -ne "${CYAN}❓ $question [Y/n]: ${NC}"
        else
            echo -ne "${CYAN}❓ $question [y/N]: ${NC}"
        fi
        
        read -r response
        response=${response,,} # Convertir en minuscules
        
        if [[ -z "$response" ]]; then
            response="$default"
        fi
        
        case "$response" in
            y|yes|o|oui)
                echo "y"
                return
                ;;
            n|no|non)
                echo "n"
                return
                ;;
            *)
                echo -e "${RED}Veuillez répondre par y/n (oui/non)${NC}"
                ;;
        esac
    done
}

# Fonction pour afficher un item avec choix
show_item() {
    local name="$1"
    local description="$2"
    local default="${3:-n}"
    
    echo -e "  ${YELLOW}▶${NC} ${BOLD}$name${NC}"
    if [ -n "$description" ]; then
        echo -e "    ${description}"
    fi
    
    local choice=$(ask_yes_no "Installer $name ?" "$default")
    echo "$choice"
}

# Configuration des choix utilisateur
configure_languages() {
    print_category "LANGAGES DE PROGRAMMATION"
    
    echo -e "${CYAN}Choisissez les langages que vous souhaitez installer :${NC}\n"
    
    LANGUAGES_CHOICES[python]=$(show_item "Python 3" "Python + pip + virtualenv + pipenv + poetry")
    LANGUAGES_CHOICES[nodejs]=$(show_item "Node.js" "Node.js + npm + yarn + pnpm + TypeScript")
    LANGUAGES_CHOICES[php]=$(show_item "PHP" "PHP + Composer + extensions communes")
    LANGUAGES_CHOICES[java]=$(show_item "Java" "OpenJDK + Maven + Gradle")
    LANGUAGES_CHOICES[go]=$(show_item "Go" "Langage Go + outils de développement")
    LANGUAGES_CHOICES[rust]=$(show_item "Rust" "Rust + Cargo + outils")
    LANGUAGES_CHOICES[ruby]=$(show_item "Ruby" "Ruby + RubyGems + Bundler")
    LANGUAGES_CHOICES[dotnet]=$(show_item ".NET" ".NET Core SDK + outils")
}

configure_editors() {
    print_category "ÉDITEURS & IDE"
    
    echo -e "${CYAN}Choisissez vos éditeurs de code :${NC}\n"
    
    EDITORS_CHOICES[vscode]=$(show_item "Visual Studio Code" "Éditeur de Microsoft avec extensions")
    EDITORS_CHOICES[vim]=$(show_item "Vim/Neovim" "Éditeur modal avec configuration avancée")
    EDITORS_CHOICES[sublime]=$(show_item "Sublime Text" "Éditeur rapide et léger")
    EDITORS_CHOICES[atom]=$(show_item "Atom" "Éditeur hackable de GitHub")
    EDITORS_CHOICES[intellij]=$(show_item "IntelliJ IDEA" "IDE pour Java/Kotlin (Community)")
    EDITORS_CHOICES[webstorm]=$(show_item "WebStorm" "IDE pour JavaScript (version d'essai)")
}

configure_databases() {
    print_category "BASES DE DONNÉES"
    
    echo -e "${CYAN}Choisissez vos bases de données :${NC}\n"
    
    DATABASES_CHOICES[mysql]=$(show_item "MySQL" "Base de données relationnelle")
    DATABASES_CHOICES[postgresql]=$(show_item "PostgreSQL" "Base de données relationnelle avancée")
    DATABASES_CHOICES[mongodb]=$(show_item "MongoDB" "Base de données NoSQL")
    DATABASES_CHOICES[redis]=$(show_item "Redis" "Base de données en mémoire")
    DATABASES_CHOICES[sqlite]=$(show_item "SQLite" "Base de données légère")
    DATABASES_CHOICES[mariadb]=$(show_item "MariaDB" "Fork libre de MySQL")
}

configure_containers() {
    print_category "CONTENEURS & VIRTUALISATION"
    
    echo -e "${CYAN}Choisissez vos outils de conteneurisation :${NC}\n"
    
    CONTAINERS_CHOICES[docker]=$(show_item "Docker" "Plateforme de conteneurisation")
    CONTAINERS_CHOICES[docker_compose]=$(show_item "Docker Compose" "Orchestration multi-conteneurs")
    CONTAINERS_CHOICES[kubernetes]=$(show_item "Kubernetes tools" "kubectl + minikube")
    CONTAINERS_CHOICES[vagrant]=$(show_item "Vagrant" "Gestionnaire de machines virtuelles")
    CONTAINERS_CHOICES[virtualbox]=$(show_item "VirtualBox" "Hyperviseur de type 2")
}

configure_devtools() {
    print_category "OUTILS DE DÉVELOPPEMENT"
    
    echo -e "${CYAN}Choisissez vos outils de développement :${NC}\n"
    
    DEVTOOLS_CHOICES[git_tools]=$(show_item "Git avancé" "Git + GitHub CLI + GitKraken")
    DEVTOOLS_CHOICES[postman]=$(show_item "Postman" "Client API REST")
    DEVTOOLS_CHOICES[insomnia]=$(show_item "Insomnia" "Client API REST alternatif")
    DEVTOOLS_CHOICES[terraform]=$(show_item "Terraform" "Infrastructure as Code")
    DEVTOOLS_CHOICES[ansible]=$(show_item "Ansible" "Automatisation et configuration")
    DEVTOOLS_CHOICES[jenkins]=$(show_item "Jenkins" "CI/CD Pipeline")
    DEVTOOLS_CHOICES[build_tools]=$(show_item "Build Tools" "make, cmake, build-essential")
}

configure_utilities() {
    print_category "UTILITAIRES & PRODUCTIVITÉ"
    
    echo -e "${CYAN}Choisissez vos utilitaires :${NC}\n"
    
    UTILITIES_CHOICES[terminal_tools]=$(show_item "Terminal avancé" "zsh + oh-my-zsh + plugins")
    UTILITIES_CHOICES[monitoring]=$(show_item "Monitoring" "htop, btop, glances")
    UTILITIES_CHOICES[network_tools]=$(show_item "Outils réseau" "nmap, wireshark, curl avancé")
    UTILITIES_CHOICES[file_tools]=$(show_item "Outils fichiers" "tree, fd, ripgrep, bat")
    UTILITIES_CHOICES[media_tools]=$(show_item "Outils média" "ffmpeg, imagemagick")
    UTILITIES_CHOICES[compression]=$(show_item "Compression" "7zip, rar, compression avancée")
}

# Détection de l'OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get >/dev/null 2>&1; then
            OS="ubuntu"
            PACKAGE_MANAGER="apt"
        elif command -v yum >/dev/null 2>&1; then
            OS="centos"
            PACKAGE_MANAGER="yum"
        elif command -v pacman >/dev/null 2>&1; then
            OS="arch"
            PACKAGE_MANAGER="pacman"
        else
            print_error "Distribution Linux non supportée"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PACKAGE_MANAGER="brew"
    else
        print_error "OS non supporté: $OSTYPE"
        exit 1
    fi
    
    print_status "OS détecté: $OS ($PACKAGE_MANAGER)"
}

# Fonction pour exécuter une commande
run_command() {
    local cmd="$1"
    local description="$2"
    
    print_status "$description"
    
    if [ "$DRY_RUN" = true ]; then
        print_warning "DRY RUN: $cmd"
        return 0
    fi
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        print_success "$description - OK"
        return 0
    else
        print_error "$description - FAILED"
        return 1
    fi
}

# Installation du gestionnaire de paquets
install_package_manager() {
    if [ "$OS" = "macos" ] && ! command -v brew >/dev/null 2>&1; then
        print_status "Installation de Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# Mise à jour du système
update_system() {
    print_status "Mise à jour du système..."
    
    case $PACKAGE_MANAGER in
        "apt")
            run_command "sudo apt update && sudo apt upgrade -y" "Mise à jour du système (apt)"
            ;;
        "yum")
            run_command "sudo yum update -y" "Mise à jour du système (yum)"
            ;;
        "pacman")
            run_command "sudo pacman -Syu --noconfirm" "Mise à jour du système (pacman)"
            ;;
        "brew")
            run_command "brew update && brew upgrade" "Mise à jour du système (brew)"
            ;;
    esac
}

# Installation des outils de base
install_base_tools() {
    print_status "Installation des outils de base..."
    
    case $PACKAGE_MANAGER in
        "apt")
            run_command "sudo apt install -y curl wget git vim nano htop tree unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release" "Outils de base (apt)"
            ;;
        "yum")
            run_command "sudo yum install -y curl wget git vim nano htop tree unzip epel-release" "Outils de base (yum)"
            ;;
        "pacman")
            run_command "sudo pacman -S --noconfirm curl wget git vim nano htop tree unzip base-devel" "Outils de base (pacman)"
            ;;
        "brew")
            run_command "brew install curl wget git vim nano htop tree" "Outils de base (brew)"
            ;;
    esac
}

# Installation des langages
install_languages() {
    print_category "INSTALLATION DES LANGAGES"
    
    # Python
    if [ "${LANGUAGES_CHOICES[python]}" = "y" ]; then
        print_status "Installation de Python..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y python3 python3-pip python3-venv python3-dev" "Python (apt)"
                ;;
            "yum")
                run_command "sudo yum install -y python3 python3-pip python3-devel" "Python (yum)"
                ;;
            "pacman")
                run_command "sudo pacman -S --noconfirm python python-pip" "Python (pacman)"
                ;;
            "brew")
                run_command "brew install python" "Python (brew)"
                ;;
        esac
        run_command "pip3 install --user virtualenv pipenv poetry requests flask django fastapi" "Packages Python"
    fi
    
    # Node.js
    if [ "${LANGUAGES_CHOICES[nodejs]}" = "y" ]; then
        print_status "Installation de Node.js..."
        if [ "$OS" = "macos" ]; then
            run_command "brew install node" "Node.js (brew)"
        else
            run_command "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -" "Configuration NodeSource"
            case $PACKAGE_MANAGER in
                "apt")
                    run_command "sudo apt install -y nodejs" "Node.js (apt)"
                    ;;
                "yum")
                    run_command "sudo yum install -y nodejs npm" "Node.js (yum)"
                    ;;
                "pacman")
                    run_command "sudo pacman -S --noconfirm nodejs npm" "Node.js (pacman)"
                    ;;
            esac
        fi
        run_command "npm install -g yarn pnpm typescript @angular/cli create-react-app vue-cli nodemon pm2" "Packages npm globaux"
    fi
    
    # PHP
    if [ "${LANGUAGES_CHOICES[php]}" = "y" ]; then
        print_status "Installation de PHP..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y php php-cli php-fpm php-mysql php-pgsql php-sqlite3 php-curl php-gd php-mbstring php-xml php-zip composer" "PHP (apt)"
                ;;
            "yum")
                run_command "sudo yum install -y php php-cli php-fpm php-mysql php-pgsql php-curl php-gd php-mbstring php-xml composer" "PHP (yum)"
                ;;
            "pacman")
                run_command "sudo pacman -S --noconfirm php php-fpm composer" "PHP (pacman)"
                ;;
            "brew")
                run_command "brew install php composer" "PHP (brew)"
                ;;
        esac
    fi
    
    # Java
    if [ "${LANGUAGES_CHOICES[java]}" = "y" ]; then
        print_status "Installation de Java..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y openjdk-11-jdk maven gradle" "Java (apt)"
                ;;
            "yum")
                run_command "sudo yum install -y java-11-openjdk-devel maven" "Java (yum)"
                ;;
            "pacman")
                run_command "sudo pacman -S --noconfirm jdk11-openjdk maven gradle" "Java (pacman)"
                ;;
            "brew")
                run_command "brew install openjdk@11 maven gradle" "Java (brew)"
                ;;
        esac
    fi
    
    # Go
    if [ "${LANGUAGES_CHOICES[go]}" = "y" ]; then
        print_status "Installation de Go..."
        case $PACKAGE_MANAGER in
            "apt"|"yum")
                run_command "wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz && sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz && rm go1.21.0.linux-amd64.tar.gz" "Go (Linux)"
                run_command "echo 'export PATH=\$PATH:/usr/local/go/bin' >> ~/.bashrc" "Configuration Go PATH"
                ;;
            "pacman")
                run_command "sudo pacman -S --noconfirm go" "Go (pacman)"
                ;;
            "brew")
                run_command "brew install go" "Go (brew)"
                ;;
        esac
    fi
    
    # Rust
    if [ "${LANGUAGES_CHOICES[rust]}" = "y" ]; then
        run_command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "Installation de Rust"
        run_command "source ~/.cargo/env" "Configuration Rust"
    fi
    
    # Ruby
    if [ "${LANGUAGES_CHOICES[ruby]}" = "y" ]; then
        print_status "Installation de Ruby..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y ruby-full bundler" "Ruby (apt)"
                ;;
            "yum")
                run_command "sudo yum install -y ruby ruby-devel bundler" "Ruby (yum)"
                ;;
            "pacman")
                run_command "sudo pacman -S --noconfirm ruby bundler" "Ruby (pacman)"
                ;;
            "brew")
                run_command "brew install ruby bundler" "Ruby (brew)"
                ;;
        esac
    fi
    
    # .NET
    if [ "${LANGUAGES_CHOICES[dotnet]}" = "y" ]; then
        print_status "Installation de .NET..."
        if [ "$OS" = "macos" ]; then
            run_command "brew install dotnet" ".NET (brew)"
        else
            run_command "wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && sudo dpkg -i packages-microsoft-prod.deb && sudo apt update && sudo apt install -y dotnet-sdk-6.0" ".NET (Linux)"
        fi
    fi
}

# Installation des éditeurs
install_editors() {
    print_category "INSTALLATION DES ÉDITEURS"
    
    # VS Code
    if [ "${EDITORS_CHOICES[vscode]}" = "y" ]; then
        print_status "Installation de VS Code..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/" "Clé VS Code"
                run_command "sudo sh -c 'echo \"deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main\" > /etc/apt/sources.list.d/vscode.list'" "Repository VS Code"
                run_command "sudo apt update && sudo apt install -y code" "VS Code (apt)"
                ;;
            "brew")
                run_command "brew install --cask visual-studio-code" "VS Code (brew)"
                ;;
        esac
    fi
    
    # Vim/Neovim
    if [ "${EDITORS_CHOICES[vim]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y neovim" "Neovim (apt)"
                ;;
            "brew")
                run_command "brew install neovim" "Neovim (brew)"
                ;;
        esac
    fi
    
    # Sublime Text
    if [ "${EDITORS_CHOICES[sublime]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - && echo \"deb https://download.sublimetext.com/ apt/stable/\" | sudo tee /etc/apt/sources.list.d/sublime-text.list && sudo apt update && sudo apt install -y sublime-text" "Sublime Text (apt)"
                ;;
            "brew")
                run_command "brew install --cask sublime-text" "Sublime Text (brew)"
                ;;
        esac
    fi
}

# Installation des bases de données
install_databases() {
    print_category "INSTALLATION DES BASES DE DONNÉES"
    
    # MySQL
    if [ "${DATABASES_CHOICES[mysql]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y mysql-server mysql-client" "MySQL (apt)"
                ;;
            "brew")
                run_command "brew install mysql" "MySQL (brew)"
                ;;
        esac
    fi
    
    # PostgreSQL
    if [ "${DATABASES_CHOICES[postgresql]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y postgresql postgresql-contrib" "PostgreSQL (apt)"
                ;;
            "brew")
                run_command "brew install postgresql" "PostgreSQL (brew)"
                ;;
        esac
    fi
    
    # MongoDB
    if [ "${DATABASES_CHOICES[mongodb]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add - && echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list && sudo apt update && sudo apt install -y mongodb-org" "MongoDB (apt)"
                ;;
            "brew")
                run_command "brew tap mongodb/brew && brew install mongodb-community" "MongoDB (brew)"
                ;;
        esac
    fi
    
    # Redis
    if [ "${DATABASES_CHOICES[redis]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y redis-server" "Redis (apt)"
                ;;
            "brew")
                run_command "brew install redis" "Redis (brew)"
                ;;
        esac
    fi
}

# Installation des conteneurs
install_containers() {
    print_category "INSTALLATION DES OUTILS DE CONTENEURISATION"
    
    # Docker
    if [ "${CONTAINERS_CHOICES[docker]}" = "y" ]; then
        print_status "Installation de Docker..."
        if [ "$OS" = "macos" ]; then
            run_command "brew install --cask docker" "Docker Desktop (brew)"
        else
            case $PACKAGE_MANAGER in
                "apt")
                    run_command "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg" "Clé Docker"
                    run_command "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null" "Repository Docker"
                    run_command "sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io" "Docker (apt)"
                    ;;
            esac
            run_command "sudo systemctl enable docker && sudo systemctl start docker" "Service Docker"
            run_command "sudo usermod -aG docker \$USER" "Groupe docker"
        fi
    fi
    
    # Docker Compose
    if [ "${CONTAINERS_CHOICES[docker_compose]}" = "y" ]; then
        run_command "sudo curl -L \"https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-\$(uname -s)-\$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose" "Docker Compose"
    fi
}

# Résumé des choix
show_summary() {
    print_category "RÉSUMÉ DE VOS CHOIX"
    
    echo -e "${CYAN}Langages sélectionnés :${NC}"
    for lang in "${!LANGUAGES_CHOICES[@]}"; do
        if [ "${LANGUAGES_CHOICES[$lang]}" = "y" ]; then
            echo -e "  ${GREEN}✓${NC} $lang"
        fi
    done
    
    echo -e "\n${CYAN}Éditeurs sélectionnés :${NC}"
    for editor in "${!EDITORS_CHOICES[@]}"; do
        if [ "${EDITORS_CHOICES[$editor]}" = "y" ]; then
            echo -e "  ${GREEN}✓${NC} $editor"
        fi
    done
    
    echo -e "\n${CYAN}Bases de données sélectionnées :${NC}"
    for db in "${!DATABASES_CHOICES[@]}"; do
        if [ "${DATABASES_CHOICES[$db]}" = "y" ]; then
            echo -e "  ${GREEN}✓${NC} $db"
        fi
    done
    
    echo -e "\n${CYAN}Outils de conteneurisation sélectionnés :${NC}"
    for container in "${!CONTAINERS_CHOICES[@]}"; do
        if [ "${CONTAINERS_CHOICES[$container]}" = "y" ]; then
            echo -e "  ${GREEN}✓${NC} $container"
        fi
    done
    
    echo ""
    local confirm=$(ask_yes_no "Confirmer l'installation avec ces choix ?" "y")
    if [ "$confirm" != "y" ]; then
        print_warning "Installation annulée par l'utilisateur"
        exit 0
    fi
}

# Configuration de Git
configure_git() {
    print_status "Configuration de Git..."
    
    if [ "$DRY_RUN" = false ] && [ "$AUTO_MODE" = false ]; then
        echo -e "${CYAN}Configuration de Git :${NC}"
        echo -ne "Entrez votre nom pour Git: "
        read -r git_name
        echo -ne "Entrez votre email pour Git: "
        read -r git_email
        
        if [ -n "$git_name" ] && [ -n "$git_email" ]; then
            run_command "git config --global user.name \"$git_name\"" "Configuration nom Git"
            run_command "git config --global user.email \"$git_email\"" "Configuration email Git"
        fi
    fi
}

# Affichage de l'aide
show_help() {
    echo "devtooly - Script d'installation interactif pour environnement de développement"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --auto         Mode automatique (utilise les valeurs par défaut)"
    echo "  --dry-run      Affiche les commandes sans les exécuter"
    echo "  --help         Affiche cette aide"
    echo ""
    echo "Le script vous guide dans le choix des outils à installer :"
    echo "  - Langages de programmation"
    echo "  - Éditeurs et IDE"
    echo "  - Bases de données"
    echo "  - Outils de conteneurisation"
    echo "  - Outils de développement"
    echo "  - Utilitaires"
}

# Fonction principale
main() {
    # Parsing des arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --auto)
                AUTO_MODE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Option inconnue: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    print_banner
    
    print_status "Démarrage de devtooly..."
    print_status "Log: $LOG_FILE"
    
    if [ "$DRY_RUN" = true ]; then
        print_warning "Mode DRY RUN activé - aucune commande ne sera exécutée"
    fi
    
    if [ "$AUTO_MODE" = true ]; then
        print_warning "Mode AUTO activé - utilisation des valeurs par défaut"
    fi
    
    # Vérification des permissions
    if [ "$EUID" -eq 0 ]; then
        print_error "Ne pas exécuter ce script en tant que root"
        exit 1
    fi
    
    # Configuration interactive
    detect_os
    configure_languages
    configure_editors
    configure_databases
    configure_containers
    configure_devtools
    configure_utilities
    
    # Résumé et confirmation
    show_summary
    
    # Installation
    print_category "DÉBUT DE L'INSTALLATION"
    install_package_manager
    update_system
    install_base_tools
    install_languages
    install_editors
    install_databases
    install_containers
    configure_git
    
    print_success "🎉 Installation terminée avec succès !"
    print_status "Redémarrez votre terminal pour appliquer tous les changements"
    
        if [ "$OS" != "macos" ]; then
        print_warning "Pour utiliser Docker sans sudo, déconnectez-vous et reconnectez-vous ou exécutez :"
        echo "  sudo usermod -aG docker $USER"
    fi
    
    # Nettoyage
    print_status "Nettoyage..."
    case $PACKAGE_MANAGER in
        "apt")
            run_command "sudo apt autoremove -y" "Nettoyage (apt)"
            ;;
        "yum")
            run_command "sudo yum autoremove -y" "Nettoyage (yum)"
            ;;
        "pacman")
            run_command "sudo pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null || true" "Nettoyage (pacman)"
            ;;
        "brew")
            run_command "brew cleanup" "Nettoyage (brew)"
            ;;
    esac
    
    # Fin du script
    echo -e "\n${GREEN}✅ Installation terminée !${NC}"
    echo -e "Consultez le fichier de log pour plus de détails: ${YELLOW}$LOG_FILE${NC}"
    echo -e "\nPensez à redémarrer votre terminal ou votre session pour appliquer tous les changements."
}

# Capture CTRL+C pour annuler l'installation
trap ctrl_c INT
ctrl_c() {
    echo -e "\n${RED}❌ Installation annulée par l'utilisateur${NC}"
    exit 1
}

# Point d'entrée principal
main "$@"