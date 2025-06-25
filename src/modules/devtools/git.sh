#!/bin/bash

source "${BASH_SOURCE%/*}/../../core/utils/helpers.sh"

install_git() {
    local pkg_manager="$1"
    local os_type="$2"
    
    print_status "Installation de Git..."
    
    case "$pkg_manager" in
        "$PKG_APT")
            safe_exec "sudo apt install -y git git-lfs" \
                "Installation de Git et Git LFS"
            ;;
        "$PKG_YUM")
            safe_exec "sudo yum install -y git git-lfs" \
                "Installation de Git et Git LFS"
            ;;
        "$PKG_BREW")
            safe_exec "brew install git git-lfs" \
                "Installation de Git et Git LFS"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
    
    # Configuration de Git
    if command -v git &> /dev/null; then
        # Configuration globale
        safe_exec "git config --global user.name \"$(whoami)\"" \
            "Configuration du nom d'utilisateur Git"
        safe_exec "git config --global user.email \"$(whoami)@$(hostname)\"" \
            "Configuration de l'email Git"
        
        # Configuration des alias
        local git_aliases=(
            "co=checkout"
            "br=branch"
            "ci=commit"
            "st=status"
            "pr=prune"
            "lg=log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
        )
        
        for alias in "${git_aliases[@]}"; do
            safe_exec "git config --global alias.$(echo $alias | cut -d'=' -f1) $(echo $alias | cut -d'=' -f2)" \
                "Configuration de l'alias Git: $(echo $alias | cut -d'=' -f1)"
        done
    fi
}

install_github_cli() {
    local pkg_manager="$1"
    
    print_status "Installation de GitHub CLI..."
    
    case "$pkg_manager" in
        "$PKG_APT")
            safe_exec "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg" \
                "Ajout de la clé GPG GitHub CLI"
            safe_exec "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null" \
                "Ajout du repository GitHub CLI"
            safe_exec "sudo apt update" \
                "Mise à jour des listes de paquets"
            safe_exec "sudo apt install -y gh" \
                "Installation de GitHub CLI"
            ;;
        "$PKG_YUM")
            safe_exec "curl -fsSL https://cli.github.com/packages/rpm/gh-cli.repo | sudo tee /etc/yum.repos.d/gh-cli.repo" \
                "Ajout du repository GitHub CLI"
            safe_exec "sudo yum install -y gh" \
                "Installation de GitHub CLI"
            ;;
        "$PKG_BREW")
            safe_exec "brew install gh" \
                "Installation de GitHub CLI via Homebrew"
            ;;
        *)
            print_error "Gestionnaire de paquets non supporté: $pkg_manager"
            ;;
    esac
}

# Export des fonctions
export -f install_git
export -f install_github_cli
