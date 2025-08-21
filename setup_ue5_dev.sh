#!/bin/bash

# UE5 Development Setup Script
# This script implements the complete UE5 setup workflow including:
# - Repository mirroring
# - Git LFS configuration  
# - Submodule initialization
# - Project file generation
# - Build process
# - Build verification

set -e

echo "=== Unreal Engine 5 Development Setup Script ==="
echo "This script will guide you through setting up UE5 development environment"
echo

# Default settings
WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"
UE5_REPO_URL="https://github.com/EpicGames/UnrealEngine.git"
UE5_BRANCH="ue5-main"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "OK" ]; then
        echo -e "${GREEN}✅ $message${NC}"
    elif [ "$status" = "INFO" ]; then
        echo -e "${BLUE}ℹ️  $message${NC}"
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠️  $message${NC}"
    else
        echo -e "${RED}❌ $message${NC}"
    fi
}

# Function to check prerequisites
check_prerequisites() {
    echo "Checking prerequisites..."
    
    # Check Git
    if command -v git >/dev/null 2>&1; then
        print_status "OK" "Git is installed: $(git --version)"
    else
        print_status "FAIL" "Git is not installed"
        return 1
    fi
    
    # Check Git LFS
    if command -v git-lfs >/dev/null 2>&1; then
        print_status "OK" "Git LFS is available: $(git lfs version 2>/dev/null | head -1)"
    else
        print_status "WARN" "Git LFS is not installed - this is required for UE5"
        return 1
    fi
    
    # Check disk space (need at least 100GB)
    available_space=$(df "$WORKSPACE_DIR" 2>/dev/null | awk 'NR==2 {print $4}' || echo "0")
    required_space=$((100 * 1024 * 1024)) # 100GB in KB
    
    if [ "$available_space" -gt "$required_space" ]; then
        print_status "OK" "Sufficient disk space available: $(df -h "$WORKSPACE_DIR" | awk 'NR==2 {print $4}')B free"
    else
        print_status "WARN" "Disk space may be insufficient. UE5 requires 100GB+. Available: $(df -h "$WORKSPACE_DIR" | awk 'NR==2 {print $4}')B"
    fi
    
    # Check memory
    total_mem=$(free -m | awk 'NR==2{print $2}')
    if [ "$total_mem" -gt 16000 ]; then
        print_status "OK" "Sufficient memory: ${total_mem}MB"
    else
        print_status "WARN" "UE5 build requires 16GB+ RAM. Available: ${total_mem}MB"
    fi
    
    echo
}

# Function to create the mirror
setup_mirror() {
    echo "Step 1: Creating UE5 repository mirror..."
    
    cd "$WORKSPACE_DIR"
    
    if [ -d "UnrealEngine" ]; then
        print_status "WARN" "UnrealEngine directory already exists"
        read -p "Remove existing directory and continue? (y/N): " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf UnrealEngine
        else
            print_status "INFO" "Skipping mirror setup - using existing directory"
            return 0
        fi
    fi
    
    print_status "INFO" "Cloning UE5 repository mirror..."
    if git clone --mirror "$UE5_REPO_URL" UnrealEngine.git; then
        print_status "OK" "Repository mirror created successfully"
    else
        print_status "FAIL" "Failed to create repository mirror"
        return 1
    fi
    
    # Convert mirror to working copy
    mv UnrealEngine.git UnrealEngine
    cd UnrealEngine
    git config --bool core.bare false
    git reset --hard
    
    print_status "OK" "Mirror setup completed"
    echo
}

# Function to configure Git LFS and fetch
configure_and_fetch() {
    echo "Step 2: Configuring Git LFS and fetching ue5-main..."
    
    cd "$WORKSPACE_DIR/UnrealEngine"
    
    # Install Git LFS
    if git lfs install; then
        print_status "OK" "Git LFS installed"
    else
        print_status "FAIL" "Failed to install Git LFS"
        return 1
    fi
    
    # Fetch all branches
    if git fetch --all; then
        print_status "OK" "Fetched all branches"
    else
        print_status "FAIL" "Failed to fetch branches"
        return 1
    fi
    
    # Checkout ue5-main
    if git checkout "$UE5_BRANCH"; then
        print_status "OK" "Checked out $UE5_BRANCH branch"
    else
        print_status "FAIL" "Failed to checkout $UE5_BRANCH branch"
        return 1
    fi
    
    # Pull latest changes
    if git pull origin "$UE5_BRANCH"; then
        print_status "OK" "Pulled latest changes from $UE5_BRANCH"
    else
        print_status "FAIL" "Failed to pull latest changes"
        return 1
    fi
    
    echo
}

# Function to initialize submodules
init_submodules() {
    echo "Step 3: Initializing submodules..."
    
    cd "$WORKSPACE_DIR/UnrealEngine"
    
    if git submodule update --init --recursive; then
        print_status "OK" "Submodules initialized successfully"
    else
        print_status "FAIL" "Failed to initialize submodules"
        return 1
    fi
    
    echo
}

# Function to run setup script
run_setup() {
    echo "Step 4: Running UE5 setup script..."
    
    cd "$WORKSPACE_DIR/UnrealEngine"
    
    if [ -f "./Setup.sh" ]; then
        if ./Setup.sh; then
            print_status "OK" "Setup script completed successfully"
        else
            print_status "FAIL" "Setup script failed"
            return 1
        fi
    else
        print_status "WARN" "Setup.sh not found - this may be expected for some UE5 versions"
    fi
    
    echo
}

# Function to generate project files
generate_project_files() {
    echo "Step 5: Generating project files..."
    
    cd "$WORKSPACE_DIR/UnrealEngine"
    
    if [ -f "./GenerateProjectFiles.sh" ]; then
        if ./GenerateProjectFiles.sh; then
            print_status "OK" "Project files generated successfully"
        else
            print_status "FAIL" "Failed to generate project files"
            return 1
        fi
    else
        print_status "WARN" "GenerateProjectFiles.sh not found - checking for alternatives"
        
        # Look for other project generation methods
        if [ -f "Makefile" ]; then
            print_status "INFO" "Found Makefile - project files may already be configured"
        else
            print_status "FAIL" "No project generation method found"
            return 1
        fi
    fi
    
    echo
}

# Function to build the engine
build_engine() {
    echo "Step 6: Building the engine..."
    
    cd "$WORKSPACE_DIR/UnrealEngine"
    
    # Determine number of cores for parallel build
    NPROC=$(nproc 2>/dev/null || echo "4")
    
    print_status "INFO" "Starting build with $NPROC parallel jobs..."
    print_status "WARN" "This will take 2-4 hours depending on your hardware"
    
    if make -j"$NPROC"; then
        print_status "OK" "Engine build completed successfully!"
    else
        print_status "FAIL" "Engine build failed"
        return 1
    fi
    
    echo
}

# Function to verify the build
verify_build() {
    echo "Step 7: Verifying the build..."
    
    # Use the verification script we created
    if [ -f "$WORKSPACE_DIR/UnrealEngine/verify_build.sh" ]; then
        "$WORKSPACE_DIR/UnrealEngine/verify_build.sh" "$WORKSPACE_DIR/UnrealEngine"
    else
        print_status "WARN" "Build verification script not found - performing basic checks"
        
        BINARIES_DIR="$WORKSPACE_DIR/UnrealEngine/Engine/Binaries/Linux"
        if [ -f "$BINARIES_DIR/UnrealEditor" ] && [ -x "$BINARIES_DIR/UnrealEditor" ]; then
            print_status "OK" "UnrealEditor executable found and is executable"
        else
            print_status "FAIL" "UnrealEditor executable not found or not executable"
            return 1
        fi
    fi
}

# Main execution flow
main() {
    echo "Starting UE5 development environment setup..."
    echo "Workspace directory: $WORKSPACE_DIR"
    echo "Repository URL: $UE5_REPO_URL"
    echo "Target branch: $UE5_BRANCH"
    echo
    
    # Create workspace directory if it doesn't exist
    mkdir -p "$WORKSPACE_DIR"
    
    # Run all setup steps
    check_prerequisites || exit 1
    
    echo "Press Enter to continue with the setup, or Ctrl+C to cancel..."
    read -r
    
    setup_mirror || exit 1
    configure_and_fetch || exit 1
    init_submodules || exit 1
    run_setup || exit 1
    generate_project_files || exit 1
    
    echo "Build process is about to start. This will take several hours."
    echo "Press Enter to continue with the build, or Ctrl+C to stop here..."
    read -r
    
    build_engine || exit 1
    verify_build || exit 1
    
    echo
    print_status "OK" "UE5 development environment setup completed successfully!"
    echo
    echo "Next steps:"
    echo "1. Test the editor: cd $WORKSPACE_DIR/UnrealEngine && ./Engine/Binaries/Linux/UnrealEditor"
    echo "2. Create a new project using your custom engine"
    echo "3. Set up your IDE for UE5 development"
    echo "4. Begin custom development or modifications"
}

# Run main function
main "$@"