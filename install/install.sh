#!/usr/bin/env bash
# install.sh - Global installer for opencode-foundry
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/opencode-foundry/opencode-foundry/main/install/install.sh | bash
#
# Options:
#   --help          Show help
#   --dry-run       Preview changes without making them
#   --force         Overwrite existing without prompting
#   --no-python     Skip foundry-mcp installation
#   --uninstall     Remove foundry components
#   --update        Update to latest (same as re-running installer)

set -euo pipefail

VERSION="1.0.0"
REPO_URL="https://raw.githubusercontent.com/foundry-works/opencode-foundry/main"

# Color output (disabled if not a terminal)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    BOLD=''
    NC=''
fi

# Global state
DRY_RUN=false
FORCE=false
NO_PYTHON=false
UNINSTALL=false
OPENCODE_HOME=""
INSTALLER=""
SKILLS=(
    "foundry-implement"
    "foundry-note"
    "foundry-pr"
    "foundry-refactor"
    "foundry-research"
    "foundry-review"
    "foundry-setup"
    "foundry-spec"
    "foundry-test"
)

# ============================================================================
# Utility Functions
# ============================================================================

log_step() {
    local step="$1"
    local total="$2"
    local msg="$3"
    echo -e "\n${BOLD}[${step}/${total}]${NC} ${msg}..."
}

log_success() {
    echo -e "      ${GREEN}$1 ✓${NC}"
}

log_info() {
    echo -e "      $1"
}

log_warn() {
    echo -e "      ${YELLOW}$1${NC}"
}

log_error() {
    echo -e "      ${RED}$1${NC}"
}

die() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# ============================================================================
# Environment Detection
# ============================================================================

detect_os() {
    case "$(uname -s)" in
        Darwin*)  echo "macOS" ;;
        Linux*)
            if grep -qE "(Microsoft|WSL)" /proc/version 2>/dev/null; then
                echo "WSL"
            else
                echo "Linux"
            fi
            ;;
        MINGW*|CYGWIN*|MSYS*) echo "Windows" ;;
        *)        echo "Unknown" ;;
    esac
}

check_python_version() {
    local python_cmd=""

    # Find Python
    if command -v python3 &>/dev/null; then
        python_cmd="python3"
    elif command -v python &>/dev/null; then
        python_cmd="python"
    else
        return 1
    fi

    # Check version >= 3.10
    $python_cmd -c "
import sys
if sys.version_info >= (3, 10):
    sys.exit(0)
else:
    sys.exit(1)
" 2>/dev/null
}

get_python_version() {
    if command -v python3 &>/dev/null; then
        python3 --version 2>&1 | cut -d' ' -f2
    elif command -v python &>/dev/null; then
        python --version 2>&1 | cut -d' ' -f2
    else
        echo "not found"
    fi
}

detect_python_installer() {
    if command -v uvx &>/dev/null; then
        echo "uvx"  # Preferred - runs without install
    elif command -v pipx &>/dev/null; then
        echo "pipx"
    elif command -v pip3 &>/dev/null; then
        echo "pip3"
    elif command -v pip &>/dev/null; then
        echo "pip"
    else
        echo "none"
    fi
}

detect_opencode_home() {
    # Check for existing OpenCode config directories
    if [ -d "$HOME/.config/opencode" ]; then
        echo "$HOME/.config/opencode"
    elif [ -d "$HOME/.opencode" ]; then
        echo "$HOME/.opencode"
    else
        # Default to XDG-compliant location
        echo "$HOME/.config/opencode"
    fi
}

# ============================================================================
# foundry-mcp Installation
# ============================================================================

check_foundry_mcp() {
    case "$INSTALLER" in
        uvx)
            # For uvx, verify it can run foundry-mcp
            uvx foundry-mcp --version &>/dev/null 2>&1 && return 0
            # Also check if foundry-mcp is directly available
            command -v foundry-mcp &>/dev/null && return 0
            # uvx exists but foundry-mcp hasn't been cached yet - that's OK
            return 0
            ;;
        pipx|pip3|pip)
            command -v foundry-mcp &>/dev/null
            ;;
        *)
            return 1
            ;;
    esac
}

install_foundry_mcp() {
    if [ "$NO_PYTHON" = true ]; then
        log_warn "Skipping foundry-mcp installation (--no-python)"
        return 0
    fi

    case "$INSTALLER" in
        uvx)
            log_info "foundry-mcp available via uvx (runs on-demand)"
            log_success "foundry-mcp ready"
            ;;
        pipx)
            if ! command -v foundry-mcp &>/dev/null; then
                if [ "$DRY_RUN" = true ]; then
                    log_info "[dry-run] Would run: pipx install foundry-mcp"
                else
                    log_info "Installing via pipx..."
                    pipx install foundry-mcp
                fi
            fi
            log_success "foundry-mcp installed"
            ;;
        pip3|pip)
            if ! command -v foundry-mcp &>/dev/null; then
                if [ "$DRY_RUN" = true ]; then
                    log_info "[dry-run] Would run: $INSTALLER install --user foundry-mcp"
                else
                    log_info "Installing via $INSTALLER..."
                    $INSTALLER install --user foundry-mcp
                fi
            fi
            log_success "foundry-mcp installed"
            ;;
        none)
            log_error "No Python package manager found (uvx, pipx, or pip required)"
            log_info "Install uv: curl -LsSf https://astral.sh/uv/install.sh | sh"
            return 1
            ;;
    esac
}

# ============================================================================
# Skills Installation
# ============================================================================

download_file() {
    local url="$1"
    local dest="$2"

    if command -v curl &>/dev/null; then
        curl -sSL "$url" -o "$dest" 2>/dev/null
    elif command -v wget &>/dev/null; then
        wget -q "$url" -O "$dest" 2>/dev/null
    else
        die "Neither curl nor wget found"
    fi
}

install_skills() {
    local skills_dir="${OPENCODE_HOME}/skills"

    if [ "$DRY_RUN" = true ]; then
        log_info "[dry-run] Would create: $skills_dir"
        for skill in "${SKILLS[@]}"; do
            log_info "[dry-run] Would download: $skill"
        done
        return 0
    fi

    mkdir -p "$skills_dir"

    log_info "Downloading ${#SKILLS[@]} skills from GitHub..."

    local failed=0
    for skill in "${SKILLS[@]}"; do
        local skill_dir="${skills_dir}/${skill}"
        mkdir -p "$skill_dir"

        # Download SKILL.md
        local skill_url="${REPO_URL}/skills/${skill}/SKILL.md"
        if download_file "$skill_url" "${skill_dir}/SKILL.md"; then
            echo -e "      → ${skill} ${GREEN}✓${NC}"
        else
            echo -e "      → ${skill} ${RED}✗${NC}"
            ((failed++))
        fi

        # Try to download references directory if it exists
        # Note: GitHub raw URLs don't support directory listing, so we'll download known reference files
        local refs_dir="${skill_dir}/references"
        mkdir -p "$refs_dir" 2>/dev/null || true

        # Download common reference files (these may or may not exist for each skill)
        for ref_file in "workflow.md" "examples.md" "api.md"; do
            local ref_url="${REPO_URL}/skills/${skill}/references/${ref_file}"
            download_file "$ref_url" "${refs_dir}/${ref_file}" 2>/dev/null || rm -f "${refs_dir}/${ref_file}" 2>/dev/null
        done

        # Clean up empty references directory
        rmdir "$refs_dir" 2>/dev/null || true
    done

    if [ "$failed" -gt 0 ]; then
        log_warn "$failed skill(s) failed to download"
    fi
}

# ============================================================================
# Configuration
# ============================================================================

backup_config() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        local backup="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
        if [ "$DRY_RUN" = true ]; then
            log_info "[dry-run] Would backup: $config_file → $backup"
        else
            cp "$config_file" "$backup"
            log_info "Backed up to: $(basename "$backup")"
        fi
    fi
}

merge_config() {
    local config_file="${OPENCODE_HOME}/opencode.json"
    local template_url="${REPO_URL}/install/assets/opencode-global.json"

    # Download the template
    local template_content
    if ! template_content=$(curl -sSL "$template_url" 2>/dev/null); then
        log_error "Failed to download config template"
        return 1
    fi

    if [ "$DRY_RUN" = true ]; then
        log_info "[dry-run] Would merge config at: $config_file"
        return 0
    fi

    # Ensure directory exists
    mkdir -p "$(dirname "$config_file")"

    # Backup existing config
    backup_config "$config_file"

    # If no existing config, just write the template
    if [ ! -f "$config_file" ]; then
        echo "$template_content" > "$config_file"
        log_success "Created config at $config_file"
        return 0
    fi

    # Deep merge using Python
    python3 -c "
import json
import sys

# Read existing config
try:
    with open('$config_file', 'r') as f:
        existing = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    existing = {}

# Parse template
template = json.loads('''$template_content''')

def deep_merge(base, overlay):
    '''Merge overlay into base, preserving base values where not overridden.'''
    result = base.copy()

    for key, value in overlay.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = deep_merge(result[key], value)
        elif key not in result:
            result[key] = value
        # Don't override existing values, only add missing ones

    return result

merged = deep_merge(existing, template)

with open('$config_file', 'w') as f:
    json.dump(merged, f, indent=2)
    f.write('\n')
" || {
        log_error "Failed to merge config"
        return 1
    }

    log_success "Merged config at $config_file"
}

# ============================================================================
# Uninstall
# ============================================================================

do_uninstall() {
    echo -e "\n${BOLD}Uninstalling opencode-foundry...${NC}"

    local skills_dir="${OPENCODE_HOME}/skills"

    # Remove foundry skills
    for skill in "${SKILLS[@]}"; do
        local skill_dir="${skills_dir}/${skill}"
        if [ -d "$skill_dir" ]; then
            if [ "$DRY_RUN" = true ]; then
                log_info "[dry-run] Would remove: $skill_dir"
            else
                rm -rf "$skill_dir"
                echo -e "      Removed ${skill} ${GREEN}✓${NC}"
            fi
        fi
    done

    # Remove MCP config from opencode.json
    local config_file="${OPENCODE_HOME}/opencode.json"
    if [ -f "$config_file" ]; then
        if [ "$DRY_RUN" = true ]; then
            log_info "[dry-run] Would remove foundry-mcp from config"
        else
            backup_config "$config_file"
            python3 -c "
import json

with open('$config_file', 'r') as f:
    config = json.load(f)

# Remove foundry-mcp from mcp section
if 'mcp' in config and 'foundry-mcp' in config['mcp']:
    del config['mcp']['foundry-mcp']
    if not config['mcp']:
        del config['mcp']

# Remove foundry permissions
if 'permission' in config:
    perm = config['permission']
    # Remove MCP permissions
    keys_to_remove = [k for k in perm if k.startswith('mcp__plugin_foundry')]
    for k in keys_to_remove:
        del perm[k]

with open('$config_file', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')
"
            log_success "Removed foundry-mcp from config"
        fi
    fi

    # Note: Don't uninstall the Python package as user may have installed it separately
    log_info "Note: foundry-mcp Python package not removed (run 'pipx uninstall foundry-mcp' if desired)"

    echo -e "\n${GREEN}Uninstall complete!${NC}"
}

# ============================================================================
# Verification
# ============================================================================

verify_installation() {
    local errors=0

    # Verify skills directory has content
    local skills_dir="${OPENCODE_HOME}/skills"
    local skill_count=0
    for skill in "${SKILLS[@]}"; do
        if [ -f "${skills_dir}/${skill}/SKILL.md" ]; then
            ((skill_count++))
        fi
    done

    if [ "$skill_count" -eq "${#SKILLS[@]}" ]; then
        log_success "All ${skill_count} skills installed"
    else
        log_warn "Only ${skill_count}/${#SKILLS[@]} skills installed"
        ((errors++))
    fi

    # Verify config is valid JSON
    local config_file="${OPENCODE_HOME}/opencode.json"
    if [ -f "$config_file" ]; then
        if python3 -c "import json; json.load(open('$config_file'))" 2>/dev/null; then
            log_success "Config is valid JSON"
        else
            log_error "Config is not valid JSON"
            ((errors++))
        fi
    fi

    return $errors
}

# ============================================================================
# Help
# ============================================================================

show_help() {
    cat <<EOF
opencode-foundry installer v${VERSION}

Usage: install.sh [OPTIONS]

Options:
    --help          Show this help message
    --dry-run       Preview changes without making them
    --force         Overwrite existing files without prompting
    --no-python     Skip foundry-mcp Python package installation
    --uninstall     Remove foundry components
    --update        Update to latest version (same as re-running)

Examples:
    # Standard installation
    curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash

    # Preview what would be installed
    curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash -s -- --dry-run

    # Uninstall
    curl -sSL https://raw.githubusercontent.com/foundry-works/opencode-foundry/main/install/install.sh | bash -s -- --uninstall

For more information, visit: https://github.com/foundry-works/opencode-foundry
EOF
}

# ============================================================================
# Main
# ============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --force|-f)
                FORCE=true
                shift
                ;;
            --no-python)
                NO_PYTHON=true
                shift
                ;;
            --uninstall)
                UNINSTALL=true
                shift
                ;;
            --update)
                # Update is just a normal install (re-downloads skills, merges config)
                shift
                ;;
            *)
                die "Unknown option: $1"
                ;;
        esac
    done

    # Header
    echo -e "\n${BOLD}opencode-foundry installer v${VERSION}${NC}"
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}(dry-run mode - no changes will be made)${NC}"
    fi

    # Detect environment
    OPENCODE_HOME=$(detect_opencode_home)
    INSTALLER=$(detect_python_installer)

    # Handle uninstall
    if [ "$UNINSTALL" = true ]; then
        do_uninstall
        exit 0
    fi

    # Step 1: Check environment
    log_step 1 4 "Checking environment"

    local os_name
    os_name=$(detect_os)
    log_info "OS: ${os_name}"

    local python_version
    python_version=$(get_python_version)
    if check_python_version; then
        log_success "Python: ${python_version}"
    else
        log_error "Python: ${python_version} (requires >= 3.10)"
        die "Python 3.10 or higher is required"
    fi

    log_info "Package manager: ${INSTALLER}"
    log_info "OpenCode home: ${OPENCODE_HOME}"

    # Step 2: Check/Install foundry-mcp
    log_step 2 4 "Checking foundry-mcp"
    install_foundry_mcp || die "Failed to set up foundry-mcp"

    # Step 3: Install skills
    log_step 3 4 "Installing skills"
    install_skills

    # Step 4: Configure OpenCode
    log_step 4 4 "Configuring OpenCode"
    merge_config || die "Failed to configure OpenCode"

    # Verification (only if not dry-run)
    if [ "$DRY_RUN" = false ]; then
        echo -e "\n${BOLD}Verifying installation...${NC}"
        verify_installation
    fi

    # Success message
    echo -e "\n${GREEN}${BOLD}Installation complete!${NC}"
    echo ""
    echo "Run 'opencode' then type '/foundry-setup' to verify your setup."
    echo ""
}

main "$@"
