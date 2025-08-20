# Unreal Engine 5 Development Setup Guide

This repository contains scripts and tools to implement a complete Unreal Engine 5 development environment setup and build verification process.

## Overview

The implementation provides two main scripts:

1. **`setup_ue5_dev.sh`** - Complete UE5 development environment setup
2. **`verify_build.sh`** - Build verification and validation

## Features Implemented

### Setup Script (`setup_ue5_dev.sh`)

Implements the complete workflow for setting up UE5 development:

- ✅ **Prerequisites checking** - Verifies Git, Git LFS, disk space, and memory
- ✅ **Repository mirroring** - Creates a proper mirror of the UE5 repository
- ✅ **Git LFS configuration** - Sets up Large File Storage for UE5 assets
- ✅ **Branch management** - Checks out the ue5-main branch
- ✅ **Submodule initialization** - Initializes all required submodules
- ✅ **Setup script execution** - Runs UE5's Setup.sh script
- ✅ **Project file generation** - Generates build system files
- ✅ **Engine building** - Compiles the complete Unreal Engine
- ✅ **Build verification** - Validates the build completed successfully

### Verification Script (`verify_build.sh`)

Implements comprehensive build verification:

- ✅ **Directory structure validation** - Checks for proper UE5 directory layout
- ✅ **Executable verification** - Validates core UE5 executables exist and are functional
- ✅ **Module checking** - Verifies engine modules were built correctly
- ✅ **Build artifact validation** - Checks for intermediate and cache files
- ✅ **System resource monitoring** - Reports disk space and memory usage
- ✅ **Log analysis** - Identifies recent build logs for troubleshooting

## Usage

### Quick Start

1. **Run the complete setup:**
   ```bash
   ./setup_ue5_dev.sh
   ```

2. **Verify an existing build:**
   ```bash
   ./verify_build.sh [path_to_ue5_directory]
   ```

### Detailed Usage

#### Setting up UE5 Development Environment

```bash
# Default setup (uses /workspace directory)
./setup_ue5_dev.sh

# Custom workspace directory
WORKSPACE_DIR=/path/to/workspace ./setup_ue5_dev.sh
```

The setup script will:
- Check system prerequisites
- Guide you through the setup process
- Ask for confirmation before long-running operations
- Provide detailed status updates throughout

#### Verifying a UE5 Build

```bash
# Verify build in default location
./verify_build.sh

# Verify build in custom location
./verify_build.sh /path/to/UnrealEngine

# Example verification of a workspace build
./verify_build.sh /workspace/UnrealEngine
```

## System Requirements

### Minimum Requirements

- **Disk Space:** 100GB+ free space
- **Memory:** 16GB RAM (32GB+ recommended)
- **CPU:** Multi-core processor (8+ cores recommended)
- **OS:** Linux (Ubuntu 18.04+, CentOS 7+, or equivalent)

### Required Software

- **Git** 2.14+
- **Git LFS** 2.3+
- **Build tools:** GCC 9+ or Clang 10+
- **CMake** 3.16+
- **Python** 3.7+

### Installation Commands

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install git git-lfs build-essential cmake python3

# CentOS/RHEL
sudo yum groupinstall "Development Tools"
sudo yum install git git-lfs cmake python3

# Configure Git LFS
git lfs install --system
```

## Build Process Timeline

| Phase | Duration | Description |
|-------|----------|-------------|
| Prerequisites | 1-2 min | System validation |
| Repository Mirror | 10-30 min | Clone UE5 source (depends on connection) |
| LFS & Submodules | 5-15 min | Download large assets |
| Setup Scripts | 2-5 min | Configure build environment |
| Engine Build | 2-4 hours | Compile UE5 (depends on hardware) |
| Verification | 1-2 min | Validate build completion |

## Verification Checklist

The verification script checks:

- ✅ **UnrealEditor** - Main editor executable
- ✅ **UnrealCEFSubProcess** - Web content rendering
- ✅ **UnrealHeaderTool** - Code generation tool
- ✅ **Engine modules** - Core engine components
- ✅ **Build artifacts** - Intermediate files and cache
- ✅ **System resources** - Disk space and memory
- ✅ **Recent logs** - Build process logs

## Troubleshooting

### Common Issues

#### Build Failures
```bash
# Check disk space
df -h

# Check memory usage
free -h

# Review build logs
find /workspace/UnrealEngine -name "*.log" -mtime -1

# Clean and retry
cd /workspace/UnrealEngine
make clean
make -j$(nproc)
```

#### Git LFS Issues
```bash
# Reinstall Git LFS
git lfs install --force

# Pull LFS files
git lfs pull

# Verify LFS status
git lfs status
```

#### Missing Dependencies
```bash
# Ubuntu/Debian
sudo apt-get install build-essential cmake python3-dev

# Update Git LFS
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
```

### Performance Optimization

#### Build Performance
```bash
# Use more CPU cores (adjust based on your system)
make -j$(nproc)

# Or specify exact number
make -j8

# Monitor build progress
make -j$(nproc) 2>&1 | tee build.log
```

#### Memory Management
```bash
# For systems with limited RAM, reduce parallel jobs
make -j2

# Monitor memory usage during build
watch -n 5 free -h
```

## Next Steps After Setup

1. **Test the Editor:**
   ```bash
   cd /workspace/UnrealEngine
   ./Engine/Binaries/Linux/UnrealEditor
   ```

2. **Create a Test Project:**
   ```bash
   ./Engine/Binaries/Linux/UnrealEditor -NewProject
   ```

3. **Set up IDE Integration:**
   - Configure your IDE for UE5 development
   - Set up code completion and debugging
   - Configure build targets

4. **Begin Development:**
   - Create custom engine modifications
   - Develop game projects
   - Contribute to engine development

## Implementation Notes

This implementation follows the UE5 development workflow described in the Epic Games documentation and community best practices:

- Uses the `ue5-main` branch for latest features
- Properly handles Git LFS for large assets
- Implements comprehensive verification
- Provides detailed progress feedback
- Includes error handling and recovery options

The scripts are designed to be:
- **Robust** - Handle common error conditions
- **Informative** - Provide clear status updates
- **Flexible** - Support different installation paths
- **Safe** - Ask for confirmation before destructive operations

## License and Attribution

This implementation is based on the official Unreal Engine development workflow and community best practices. Please ensure you comply with Epic Games' Unreal Engine license terms when using UE5 source code.