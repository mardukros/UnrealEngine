#!/bin/bash

# UE5 Build Verification Script
# This script implements the verification steps for Unreal Engine 5 builds
# Based on the build verification process outlined in the development workflow

set -e

echo "=== UE5 Build Verification Script ==="
echo "Verifying Unreal Engine 5 build completion and integrity..."
echo

# Default UE5 directory - can be overridden with argument
UE5_DIR="${1:-/workspace/UnrealEngine}"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "OK" ]; then
        echo -e "${GREEN}✅ $message${NC}"
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠️  $message${NC}"
    else
        echo -e "${RED}❌ $message${NC}"
    fi
}

# Function to check if directory exists
check_directory() {
    local dir=$1
    local name=$2
    if [ -d "$dir" ]; then
        print_status "OK" "$name directory exists: $dir"
        return 0
    else
        print_status "FAIL" "$name directory not found: $dir"
        return 1
    fi
}

# Function to check if file exists and is executable
check_executable() {
    local file=$1
    local name=$2
    if [ -f "$file" ] && [ -x "$file" ]; then
        print_status "OK" "$name executable found: $file"
        return 0
    else
        print_status "FAIL" "$name executable not found or not executable: $file"
        return 1
    fi
}

echo "Step 1: Checking UE5 directory structure..."
if ! check_directory "$UE5_DIR" "UE5 root"; then
    echo "Please ensure UE5 is properly cloned and built at: $UE5_DIR"
    echo "Or specify the correct path: $0 /path/to/UnrealEngine"
    exit 1
fi

BINARIES_DIR="$UE5_DIR/Engine/Binaries/Linux"
echo
echo "Step 2: Checking build output and executables..."
check_directory "$BINARIES_DIR" "Engine binaries"

echo
echo "Step 3: Verifying key executable files..."
EXECUTABLES=(
    "$BINARIES_DIR/UnrealEditor"
    "$BINARIES_DIR/UnrealCEFSubProcess"
    "$BINARIES_DIR/UnrealHeaderTool"
)

all_executables_found=true
for exe in "${EXECUTABLES[@]}"; do
    if ! check_executable "$exe" "$(basename "$exe")"; then
        all_executables_found=false
    fi
done

echo
echo "Step 4: Checking for essential binaries pattern..."
unreal_editor_binaries=$(find "$BINARIES_DIR" -name "UnrealEditor-*" 2>/dev/null | head -5)
if [ -n "$unreal_editor_binaries" ]; then
    print_status "OK" "UnrealEditor modules found:"
    echo "$unreal_editor_binaries" | while read -r binary; do
        echo "  - $(basename "$binary")"
    done
else
    print_status "WARN" "No UnrealEditor module binaries found"
fi

echo
echo "Step 5: Testing editor version check..."
if [ -f "$BINARIES_DIR/UnrealEditor" ] && [ -x "$BINARIES_DIR/UnrealEditor" ]; then
    cd "$UE5_DIR"
    if timeout 10s ./Engine/Binaries/Linux/UnrealEditor -version 2>/dev/null; then
        print_status "OK" "UnrealEditor version check successful"
    else
        print_status "WARN" "UnrealEditor version check failed or timed out"
    fi
else
    print_status "FAIL" "Cannot test UnrealEditor - executable not found"
fi

echo
echo "Step 6: Checking build artifacts..."
ARTIFACTS=(
    "$UE5_DIR/Engine/Intermediate"
    "$UE5_DIR/Engine/DerivedDataCache"
)

for artifact in "${ARTIFACTS[@]}"; do
    check_directory "$artifact" "$(basename "$artifact")"
done

echo
echo "Step 7: Checking recent build logs..."
recent_logs=$(find "$UE5_DIR" -name "*.log" -mtime -1 2>/dev/null | head -5)
if [ -n "$recent_logs" ]; then
    print_status "OK" "Recent build logs found:"
    echo "$recent_logs" | while read -r log; do
        echo "  - $log"
    done
else
    print_status "WARN" "No recent build logs found"
fi

echo
echo "Step 8: System resource check..."
echo "Disk space:"
df -h "$UE5_DIR" 2>/dev/null || df -h .
echo
echo "Available memory:"
free -h

echo
echo "=== Build Verification Summary ==="
if [ "$all_executables_found" = true ]; then
    print_status "OK" "Build verification completed successfully!"
    echo "Your UE5 build appears to be complete and ready for development."
    echo
    echo "Next steps:"
    echo "1. Create a test project to verify full functionality"
    echo "2. Set up your development environment and IDE"
    echo "3. Begin custom development or modifications"
else
    print_status "FAIL" "Build verification found issues"
    echo "Some essential executables are missing. Please check the build process."
    echo
    echo "Troubleshooting:"
    echo "1. Check disk space: df -h"
    echo "2. Check available memory: free -h"
    echo "3. Review build logs for specific errors"
    echo "4. Verify all dependencies are installed"
    echo "5. Re-run the build process if necessary"
    exit 1
fi