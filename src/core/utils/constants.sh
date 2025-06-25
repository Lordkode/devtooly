#!/bin/bash

# Export all constants
export RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Exit codes
SUCCESS=0
ERROR=1
WARNING=2

# OS types
OS_LINUX="linux"
OS_MACOS="macos"

# Package managers
PKG_APT="apt"
PKG_BREW="brew"
PKG_YUM="yum"

# Default values
DEFAULT_DRY_RUN=false
DEFAULT_AUTO_MODE=false

# File paths
LOG_DIR="logs"
CONFIG_DIR=".devtooly"
DEFAULT_LOG_FILE="$LOG_DIR/devtooly_$(date +%Y%m%d_%H%M%S).log"
CONFIG_FILE="$CONFIG_DIR/config.json"
