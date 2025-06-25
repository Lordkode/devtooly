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
    
    # Afficher l'item et sa description
    echo -e "  ${YELLOW}▶${NC} ${BOLD}$name${NC}"
    echo -e "    ${description}"
    
    # Poser la question et retourner la réponse
    ask_yes_no "Installer $name ?" "$default"
}

# Configuration des choix utilisateur (version corrigée)
configure_languages() {
    print_category "LANGAGES DE PROGRAMMATION"
    
    echo -e "${CYAN}Choisissez les langages que vous souhaitez installer :${NC}\n"
    
    # Python
    echo -e "  ${YELLOW}▶${NC} ${BOLD}Python 3${NC}"
    echo -e "    Python + pip + virtualenv + pipenv + poetry"
    LANGUAGES_CHOICES[Python]=$(ask_yes_no "Installer Python 3 ?" "y")
    echo
    
    # Node.js
    echo -e "  ${YELLOW}▶${NC} ${BOLD}Node.js${NC}"
    echo -e "    Node.js + npm + yarn + pnpm + TypeScript"
    LANGUAGES_CHOICES[Node.js]=$(ask_yes_no "Installer Node.js ?" "y")
    echo
    
    # PHP
    echo -e "  ${YELLOW}▶${NC} ${BOLD}PHP${NC}"
    echo -e "    PHP + Composer + extensions communes"
    LANGUAGES_CHOICES[PHP]=$(ask_yes_no "Installer PHP ?" "n")
    echo
    
    # Java
    echo -e "  ${YELLOW}▶${NC} ${BOLD}Java${NC}"
    echo -e "    OpenJDK + Maven + Gradle"
    LANGUAGES_CHOICES[Java]=$(ask_yes_no "Installer Java ?" "n")
    echo
    
    # Go
    echo -e "  ${YELLOW}▶${NC} ${BOLD}Go${NC}"
    echo -e "    Langage Go + outils de développement"
    LANGUAGES_CHOICES[Go]=$(ask_yes_no "Installer Go ?" "n")
    echo
    
    # Rust
    echo -e "  ${YELLOW}▶${NC} ${BOLD}Rust${NC}"
    echo -e "    Rust + Cargo + outils"
    LANGUAGES_CHOICES[Rust]=$(ask_yes_no "Installer Rust ?" "n")
    echo
    
    # Ruby
    echo -e "  ${YELLOW}▶${NC} ${BOLD}Ruby${NC}"
    echo -e "    Ruby + RubyGems + Bundler"
    LANGUAGES_CHOICES[Ruby]=$(ask_yes_no "Installer Ruby ?" "n")
    echo
    
    # .NET
    echo -e "  ${YELLOW}▶${NC} ${BOLD}.NET${NC}"
    echo -e "    .NET Core SDK + outils"
    LANGUAGES_CHOICES[.NET]=$(ask_yes_no "Installer .NET ?" "n")
}

configure_editors() {
    print_category "ÉDITEURS & IDE"
    
    echo -e "${CYAN}Choisissez vos éditeurs de code :${NC}\n"
    
    EDITORS_CHOICES[vscode]=$(show_item "Visual Studio Code" "Éditeur de Microsoft avec extensions" "y")
    echo
    EDITORS_CHOICES[vim]=$(show_item "Vim/Neovim" "Éditeur modal avec configuration avancée" "n")
    echo
    EDITORS_CHOICES[sublime]=$(show_item "Sublime Text" "Éditeur rapide et léger" "n")
    echo
    EDITORS_CHOICES[atom]=$(show_item "Atom" "Éditeur hackable de GitHub" "n")
    echo
    EDITORS_CHOICES[intellij]=$(show_item "IntelliJ IDEA" "IDE pour Java/Kotlin (Community)" "n")
    echo
    EDITORS_CHOICES[webstorm]=$(show_item "WebStorm" "IDE pour JavaScript (version d'essai)" "n")
}

configure_databases() {
    print_category "BASES DE DONNÉES"
    
    echo -e "${CYAN}Choisissez vos bases de données :${NC}\n"
    
    DATABASES_CHOICES[mysql]=$(show_item "MySQL" "Base de données relationnelle" "n")
    echo
    DATABASES_CHOICES[postgresql]=$(show_item "PostgreSQL" "Base de données relationnelle avancée" "y")
    echo
    DATABASES_CHOICES[mongodb]=$(show_item "MongoDB" "Base de données NoSQL" "n")
    echo
    DATABASES_CHOICES[redis]=$(show_item "Redis" "Base de données en mémoire" "n")
    echo
    DATABASES_CHOICES[sqlite]=$(show_item "SQLite" "Base de données légère" "n")
    echo
    DATABASES_CHOICES[mariadb]=$(show_item "MariaDB" "Fork libre de MySQL" "n")
}

configure_containers() {
    print_category "CONTENEURS & VIRTUALISATION"
    
    echo -e "${CYAN}Choisissez vos outils de conteneurisation :${NC}\n"
    
    CONTAINERS_CHOICES[docker]=$(show_item "Docker" "Plateforme de conteneurisation" "y")
    echo
    CONTAINERS_CHOICES[docker_compose]=$(show_item "Docker Compose" "Orchestration multi-conteneurs" "n")
    echo
    CONTAINERS_CHOICES[kubernetes]=$(show_item "Kubernetes tools" "kubectl + minikube" "n")
    echo
    CONTAINERS_CHOICES[vagrant]=$(show_item "Vagrant" "Gestionnaire de machines virtuelles" "n")
    echo
    CONTAINERS_CHOICES[virtualbox]=$(show_item "VirtualBox" "Hyperviseur de type 2" "n")
}

configure_devtools() {
    print_category "OUTILS DE DÉVELOPPEMENT"
    
    echo -e "${CYAN}Choisissez vos outils de développement :${NC}\n"
    
    DEVTOOLS_CHOICES[git_tools]=$(show_item "Git avancé" "Git + GitHub CLI + GitKraken" "y")
    echo
    DEVTOOLS_CHOICES[postman]=$(show_item "Postman" "Client API REST" "n")
    echo
    DEVTOOLS_CHOICES[insomnia]=$(show_item "Insomnia" "Client API REST alternatif" "n")
    echo
    DEVTOOLS_CHOICES[terraform]=$(show_item "Terraform" "Infrastructure as Code" "n")
    echo
    DEVTOOLS_CHOICES[ansible]=$(show_item "Ansible" "Automatisation et configuration" "n")
    echo
    DEVTOOLS_CHOICES[jenkins]=$(show_item "Jenkins" "CI/CD Pipeline" "n")
    echo
    DEVTOOLS_CHOICES[build_tools]=$(show_item "Build Tools" "make, cmake, build-essential" "n")
}

configure_utilities() {
    print_category "UTILITAIRES & PRODUCTIVITÉ"
    
    echo -e "${CYAN}Choisissez vos utilitaires :${NC}\n"
    
    UTILITIES_CHOICES[terminal_tools]=$(show_item "Terminal avancé" "zsh + oh-my-zsh + plugins" "y")
    echo
    UTILITIES_CHOICES[monitoring]=$(show_item "Monitoring" "htop, btop, glances" "n")
    echo
    UTILITIES_CHOICES[network_tools]=$(show_item "Outils réseau" "nmap, wireshark, curl avancé" "n")
    echo
    UTILITIES_CHOICES[file_tools]=$(show_item "Outils fichiers" "tree, fd, ripgrep, bat" "n")
    echo
    UTILITIES_CHOICES[media_tools]=$(show_item "Outils média" "ffmpeg, imagemagick" "n")
    echo
    UTILITIES_CHOICES[compression]=$(show_item "Compression" "7zip, rar, compression avancée" "n")
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
    if [ "${LANGUAGES_CHOICES[Python]}" = "y" ]; then
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
    if [ "${LANGUAGES_CHOICES[Node.js]}" = "y" ]; then
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
    if [ "${LANGUAGES_CHOICES[PHP]}" = "y" ]; then
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
    if [ "${LANGUAGES_CHOICES[Java]}" = "y" ]; then
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
    if [ "${LANGUAGES_CHOICES[Go]}" = "y" ]; then
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
    if [ "${LANGUAGES_CHOICES[Rust]}" = "y" ]; then
        run_command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "Installation de Rust"
        run_command "source ~/.cargo/env" "Configuration Rust"
    fi
    
    # Ruby
    if [ "${LANGUAGES_CHOICES[Ruby]}" = "y" ]; then
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
    if [ "${LANGUAGES_CHOICES[.NET]}" = "y" ]; then
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

# Installation des outils de développement
install_devtools() {
    print_category "INSTALLATION DES OUTILS DE DÉVELOPPEMENT"
    
    # Git avancé
    if [ "${DEVTOOLS_CHOICES[git_tools]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y git gh" "Git outils (apt)"
                ;;
            "brew")
                run_command "brew install git gh" "Git outils (brew)"
                ;;
        esac
    fi
    
    # Postman
    if [ "${DEVTOOLS_CHOICES[postman]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo snap install postman" "Postman (snap)"
                ;;
            "brew")
                run_command "brew install --cask postman" "Postman (brew)"
                ;;
        esac
    fi
}

# Installation des utilitaires
install_utilities() {
    print_category "INSTALLATION DES UTILITAIRES"
    
    # Terminal avancé
    if [ "${UTILITIES_CHOICES[terminal_tools]}" = "y" ]; then
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo apt install -y zsh" "Zsh (apt)"
                ;;
            "brew")
                run_command "brew install zsh" "Zsh (brew)"
                ;;
        esac
        run_command "sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"" "Oh My Zsh"
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
    
    echo -e "\n${CYAN}Outils de développement sélectionnés :${NC}"
    for devtool in "${!DEVTOOLS_CHOICES[@]}"; do
        if [ "${DEVTOOLS_CHOICES[$devtool]}" = "y" ]; then
            echo -e "  ${GREEN}✓${NC} $devtool"
        fi
    done
    
    echo -e "\n${CYAN}Utilitaires sélectionnés :${NC}"
    for utility in "${!UTILITIES_CHOICES[@]}"; do
        if [ "${UTILITIES_CHOICES[$utility]}" = "y" ]; then
            echo -e "  ${GREEN}✓${NC} $utility"
        fi
    done
    
    echo -e "\n${YELLOW}OS détecté : $OS${NC}"
    echo -e "${YELLOW}Gestionnaire de paquets : $PACKAGE_MANAGER${NC}"
    
    if [ "$AUTO_MODE" = false ]; then
        echo
        if [ "$(ask_yes_no "Confirmer l'installation ?" "y")" = "n" ]; then
            print_warning "Installation annulée par l'utilisateur"
            exit 0
        fi
    fi
}

# Configuration post-installation
post_install_config() {
    print_category "CONFIGURATION POST-INSTALLATION"
    
    # Configuration Git
    if [ "${DEVTOOLS_CHOICES[git_tools]}" = "y" ]; then
        print_status "Configuration de Git..."
        if [ "$AUTO_MODE" = false ]; then
            echo -ne "${CYAN}Nom pour Git : ${NC}"
            read -r git_name
            echo -ne "${CYAN}Email pour Git : ${NC}"
            read -r git_email
            
            if [ -n "$git_name" ] && [ -n "$git_email" ]; then
                run_command "git config --global user.name '$git_name'" "Configuration nom Git"
                run_command "git config --global user.email '$git_email'" "Configuration email Git"
                run_command "git config --global init.defaultBranch main" "Configuration branche par défaut"
                run_command "git config --global pull.rebase false" "Configuration pull strategy"
            fi
        fi
    fi
    
    # Configuration PostgreSQL
    if [ "${DATABASES_CHOICES[postgresql]}" = "y" ]; then
        print_status "Configuration initiale de PostgreSQL..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo systemctl enable postgresql && sudo systemctl start postgresql" "Service PostgreSQL"
                ;;
            "brew")
                run_command "brew services start postgresql" "Service PostgreSQL (brew)"
                ;;
        esac
    fi
    
    # Configuration MySQL
    if [ "${DATABASES_CHOICES[mysql]}" = "y" ]; then
        print_status "Configuration initiale de MySQL..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo systemctl enable mysql && sudo systemctl start mysql" "Service MySQL"
                ;;
            "brew")
                run_command "brew services start mysql" "Service MySQL (brew)"
                ;;
        esac
    fi
    
    # Configuration MongoDB
    if [ "${DATABASES_CHOICES[mongodb]}" = "y" ]; then
        print_status "Configuration initiale de MongoDB..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo systemctl enable mongod && sudo systemctl start mongod" "Service MongoDB"
                ;;
            "brew")
                run_command "brew services start mongodb-community" "Service MongoDB (brew)"
                ;;
        esac
    fi
    
    # Configuration Redis
    if [ "${DATABASES_CHOICES[redis]}" = "y" ]; then
        print_status "Configuration initiale de Redis..."
        case $PACKAGE_MANAGER in
            "apt")
                run_command "sudo systemctl enable redis-server && sudo systemctl start redis-server" "Service Redis"
                ;;
            "brew")
                run_command "brew services start redis" "Service Redis (brew)"
                ;;
        esac
    fi
    
    # Configuration environnement de développement
    create_dev_directories
    setup_shell_aliases
}

# Création des répertoires de développement
create_dev_directories() {
    print_status "Création des répertoires de développement..."
    
    local dev_dirs=(
        "$HOME/Development"
        "$HOME/Development/projects"
        "$HOME/Development/scripts"
        "$HOME/Development/sandbox"
        "$HOME/Development/tools"
        "$HOME/.local/bin"
    )
    
    for dir in "${dev_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            run_command "mkdir -p '$dir'" "Création du répertoire $dir"
        fi
    done
}

# Configuration des alias shell
setup_shell_aliases() {
    print_status "Configuration des alias shell..."
    
    local aliases_file="$HOME/.devtooly_aliases"
    
    cat > "$aliases_file" << 'EOF'
# DevTooly - Alias utiles pour le développement

# Alias généraux
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Alias Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'

# Alias Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dex='docker exec -it'
alias dlogs='docker logs'

# Alias développement
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias jsonpp='python3 -m json.tool'

# Alias système
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Alias réseaux
alias ports='netstat -tulanp'
alias myip='curl -s http://whatismyip.akamai.com/'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# Alias fichiers
alias size='du -sh'
alias count='find . -type f | wc -l'
alias tree='tree -C'
EOF

    # Ajouter les alias au fichier de configuration shell approprié
    local shell_config=""
    if [ -n "$ZSH_VERSION" ] || [ "${UTILITIES_CHOICES[terminal_tools]}" = "y" ]; then
        shell_config="$HOME/.zshrc"
    else
        shell_config="$HOME/.bashrc"
    fi
    
    if [ -f "$shell_config" ]; then
        if ! grep -q "source.*devtooly_aliases" "$shell_config"; then
            echo "# DevTooly aliases" >> "$shell_config"
            echo "source $aliases_file" >> "$shell_config"
            print_success "Aliases ajoutés à $shell_config"
        fi
    fi
}

# Génération d'un rapport d'installation
generate_report() {
    print_category "GÉNÉRATION DU RAPPORT"
    
    local report_file="devtooly_report_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$report_file" << EOF
# 📋 Rapport d'installation DevTooly

**Date :** $(date)
**OS :** $OS
**Gestionnaire de paquets :** $PACKAGE_MANAGER
**Mode :** $([ "$AUTO_MODE" = true ] && echo "Automatique" || echo "Interactif")

## 🎯 Composants installés

### Langages de programmation
$(for lang in "${!LANGUAGES_CHOICES[@]}"; do
    if [ "${LANGUAGES_CHOICES[$lang]}" = "y" ]; then
        echo "- ✅ $lang"
    fi
done)

### Éditeurs et IDE
$(for editor in "${!EDITORS_CHOICES[@]}"; do
    if [ "${EDITORS_CHOICES[$editor]}" = "y" ]; then
        echo "- ✅ $editor"
    fi
done)

### Bases de données
$(for db in "${!DATABASES_CHOICES[@]}"; do
    if [ "${DATABASES_CHOICES[$db]}" = "y" ]; then
        echo "- ✅ $db"
    fi
done)

### Outils de conteneurisation
$(for container in "${!CONTAINERS_CHOICES[@]}"; do
    if [ "${CONTAINERS_CHOICES[$container]}" = "y" ]; then
        echo "- ✅ $container"
    fi
done)

### Outils de développement
$(for devtool in "${!DEVTOOLS_CHOICES[@]}"; do
    if [ "${DEVTOOLS_CHOICES[$devtool]}" = "y" ]; then
        echo "- ✅ $devtool"
    fi
done)

### Utilitaires
$(for utility in "${!UTILITIES_CHOICES[@]}"; do
    if [ "${UTILITIES_CHOICES[$utility]}" = "y" ]; then
        echo "- ✅ $utility"
    fi
done)

## 📁 Répertoires créés

- \`~/Development/\` - Répertoire principal de développement
- \`~/Development/projects/\` - Projets
- \`~/Development/scripts/\` - Scripts utilitaires
- \`~/Development/sandbox/\` - Tests et expérimentations
- \`~/Development/tools/\` - Outils personnalisés
- \`~/.local/bin/\` - Binaires utilisateur

## 🚀 Prochaines étapes

### Pour finaliser l'installation :

1. **Redémarrer votre terminal** ou exécuter :
   \`\`\`bash
   source ~/.bashrc  # ou ~/.zshrc si vous utilisez zsh
   \`\`\`

2. **Docker** (si installé) : Vous devez vous déconnecter et vous reconnecter pour que l'ajout au groupe docker soit effectif.

3. **Bases de données** : Consultez la documentation spécifique pour la configuration initiale.

### Commandes utiles ajoutées :

- **Alias Git** : \`gs\`, \`ga\`, \`gc\`, \`gp\`, \`gl\`, etc.
- **Alias Docker** : \`d\`, \`dc\`, \`dps\`, \`di\`, etc.
- **Alias système** : \`ll\`, \`myip\`, \`ports\`, etc.

### Fichiers de configuration :

- **Log d'installation** : \`$LOG_FILE\`
- **Aliases** : \`~/.devtooly_aliases\`
- **Ce rapport** : \`$report_file\`

## 💡 Conseils

1. Explorez les nouveaux outils installés avec \`command --help\`
2. Configurez vos éditeurs avec vos extensions préférées
3. Créez vos premiers projets dans \`~/Development/projects/\`
4. Consultez les logs en cas de problème : \`cat $LOG_FILE\`

---
*Généré par DevTooly - Script d'installation pour développeurs*
EOF

    print_success "Rapport généré : $report_file"
}

# Fonction de nettoyage
cleanup() {
    print_status "Nettoyage des fichiers temporaires..."
    
    # Nettoyer les paquets
    case $PACKAGE_MANAGER in
        "apt")
            run_command "sudo apt autoremove -y && sudo apt autoclean" "Nettoyage apt"
            ;;
        "yum")
            run_command "sudo yum clean all" "Nettoyage yum"
            ;;
        "brew")
            run_command "brew cleanup" "Nettoyage brew"
            ;;
    esac
    
    # Supprimer les fichiers temporaires
    run_command "rm -f /tmp/devtooly_*" "Suppression fichiers temporaires"
}

# Vérification des installations
verify_installations() {
    print_category "VÉRIFICATION DES INSTALLATIONS"
    
    local verification_failed=false
    
    # Vérifier les langages
    for lang in "${!LANGUAGES_CHOICES[@]}"; do
        if [ "${LANGUAGES_CHOICES[$lang]}" = "y" ]; then
            case $lang in
                "Python")
                    if command -v python3 >/dev/null 2>&1; then
                        print_success "Python 3 : $(python3 --version)"
                    else
                        print_error "Python 3 non trouvé"
                        verification_failed=true
                    fi
                    ;;
                "Node.js")
                    if command -v node >/dev/null 2>&1; then
                        print_success "Node.js : $(node --version)"
                    else
                        print_error "Node.js non trouvé"
                        verification_failed=true
                    fi
                    ;;
                "PHP")
                    if command -v php >/dev/null 2>&1; then
                        print_success "PHP : $(php --version | head -1)"
                    else
                        print_error "PHP non trouvé"
                        verification_failed=true
                    fi
                    ;;
                "Java")
                    if command -v java >/dev/null 2>&1; then
                        print_success "Java : $(java --version | head -1)"
                    else
                        print_error "Java non trouvé"
                        verification_failed=true
                    fi
                    ;;
                "Go")
                    if command -v go >/dev/null 2>&1; then
                        print_success "Go : $(go version)"
                    else
                        print_error "Go non trouvé"
                        verification_failed=true
                    fi
                    ;;
                "Rust")
                    if command -v rustc >/dev/null 2>&1; then
                        print_success "Rust : $(rustc --version)"
                    else
                        print_error "Rust non trouvé"
                        verification_failed=true
                    fi
                    ;;
                "Ruby")
                    if command -v ruby >/dev/null 2>&1; then
                        print_success "Ruby : $(ruby --version)"
                    else
                        print_error "Ruby non trouvé"
                        verification_failed=true
                    fi
                    ;;
                ".NET")
                    if command -v dotnet >/dev/null 2>&1; then
                        print_success ".NET : $(dotnet --version)"
                    else
                        print_error ".NET non trouvé"
                        verification_failed=true
                    fi
                    ;;
            esac
        fi
    done
    
    # Vérifier Docker
    if [ "${CONTAINERS_CHOICES[docker]}" = "y" ]; then
        if command -v docker >/dev/null 2>&1; then
            print_success "Docker : $(docker --version)"
        else
            print_error "Docker non trouvé"
            verification_failed=true
        fi
    fi
    
    # Vérifier Git
    if [ "${DEVTOOLS_CHOICES[git_tools]}" = "y" ]; then
        if command -v git >/dev/null 2>&1; then
            print_success "Git : $(git --version)"
        else
            print_error "Git non trouvé"
            verification_failed=true
        fi
    fi
    
    if [ "$verification_failed" = true ]; then
        print_warning "Certaines installations ont échoué. Consultez le log : $LOG_FILE"
        return 1
    else
        print_success "Toutes les vérifications sont passées avec succès !"
        return 0
    fi
}

# Fonction d'aide
show_help() {
    echo -e "${CYAN}DevTooly - Script d'installation interactif pour environnement de développement${NC}"
    echo
    echo -e "${BOLD}Usage:${NC}"
    echo "  $0 [OPTIONS]"
    echo
    echo -e "${BOLD}Options:${NC}"
    echo "  --auto      Mode automatique (utilise les valeurs par défaut)"
    echo "  --dry-run   Simulation sans installation réelle"
    echo "  --help      Affiche cette aide"
    echo
    echo -e "${BOLD}Exemples:${NC}"
    echo "  $0              # Mode interactif"
    echo "  $0 --auto       # Installation automatique"
    echo "  $0 --dry-run    # Test sans installation"
    echo
    echo -e "${BOLD}Fonctionnalités:${NC}"
    echo "  • Installation de langages de programmation"
    echo "  • Configuration d'éditeurs et IDE"
    echo "  • Installation de bases de données"
    echo "  • Outils de conteneurisation (Docker, etc.)"
    echo "  • Utilitaires de développement"
    echo "  • Configuration automatique de l'environnement"
    echo "  • Génération de rapport d'installation"
    echo
}

# Fonction principale
main() {
    # Traitement des arguments
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
            --help|-h)
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
    
    # Vérification des privilèges
    if [ "$EUID" -eq 0 ]; then
        print_error "Ne pas exécuter ce script en tant que root"
        exit 1
    fi
    
    # Initialisation
    print_banner
    
    if [ "$DRY_RUN" = true ]; then
        print_warning "MODE SIMULATION ACTIVÉ - Aucune installation réelle"
    fi
    
    if [ "$AUTO_MODE" = true ]; then
        print_warning "MODE AUTOMATIQUE ACTIVÉ"
    fi
    
    print_status "Début de l'installation - Log: $LOG_FILE"
    
    # Détection de l'environnement
    detect_os
    
    # Configuration des choix utilisateur
    if [ "$AUTO_MODE" = false ]; then
        configure_languages
        configure_editors
        configure_databases
        configure_containers
        configure_devtools
        configure_utilities
        show_summary
    else
        # Valeurs par défaut pour le mode automatique
        LANGUAGES_CHOICES[Python]="y"
        LANGUAGES_CHOICES[Node.js]="y"
        DATABASES_CHOICES[postgresql]="y"
        CONTAINERS_CHOICES[docker]="y"
        DEVTOOLS_CHOICES[git_tools]="y"
        EDITORS_CHOICES[vscode]="y"
        UTILITIES_CHOICES[terminal_tools]="y"
        show_summary
    fi
    
    # Installation
    print_category "DÉBUT DE L'INSTALLATION"
    
    install_package_manager
    update_system
    install_base_tools
    install_languages
    install_editors
    install_databases
    install_containers
    install_devtools
    install_utilities
    
    # Configuration post-installation
    post_install_config
    
    # Vérification
    if verify_installations; then
        print_success "Installation terminée avec succès !"
    else
        print_warning "Installation terminée avec des avertissements"
    fi
    
    # Finalisation
    cleanup
    generate_report
    
    # Message final
    print_category "INSTALLATION TERMINÉE"
    echo -e "${GREEN}✅ DevTooly a terminé la configuration de votre environnement !${NC}"
    echo -e "${CYAN}📋 Consultez le rapport généré pour plus de détails${NC}"
    echo -e "${YELLOW}🔄 Redémarrez votre terminal pour appliquer tous les changements${NC}"
    
    if [ "${CONTAINERS_CHOICES[docker]}" = "y" ] && [ "$OS" != "macos" ]; then
        echo -e "${YELLOW}🐳 Pour Docker : déconnectez-vous et reconnectez-vous${NC}"
    fi
    
    echo -e "\n${BOLD}Bon développement ! 🚀${NC}"
}

# Gestion des signaux
trap 'print_error "Installation interrompue"; exit 1' INT TERM

# Exécution du script principal
main "$@"