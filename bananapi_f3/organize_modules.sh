#!/bin/bash
# Post-build script to organize modules into ramdisk/, vendor_dlkm/, system_dlkm/
# The build produces tar files that need to be extracted
# Usage: ./organize_modules.sh [dist_dir]
# Default dist_dir: out/spacemit_k1x/dist

DIST_DIR="${1:-out/spacemit_k1x/dist}"

if [ ! -d "$DIST_DIR" ]; then
    echo "Error: Distribution directory not found: $DIST_DIR"
    echo "Run 'tools/bazel build //devices/spacemit/bananapi_f3:spacemit_k1x_dist' first"
    exit 1
fi

cd "$DIST_DIR" || exit 1

echo "Organizing modules in $DIST_DIR..."

# Extract ramdisk modules (vendor boot modules)
if [ -f "ramdisk/ramdisk_modules.tar" ]; then
    echo "Extracting vendor boot modules to ramdisk/..."
    tar -xf ramdisk/ramdisk_modules.tar -C ramdisk/
    rm ramdisk/ramdisk_modules.tar
    count=$(ls ramdisk/*.ko 2>/dev/null | wc -l)
    echo "  Extracted $count modules to ramdisk/"
fi

# Extract vendor DLKM modules
if [ -f "vendor_dlkm/vendor_dlkm_modules.tar" ]; then
    echo "Extracting vendor dlkm modules to vendor_dlkm/..."
    tar -xf vendor_dlkm/vendor_dlkm_modules.tar -C vendor_dlkm/
    rm vendor_dlkm/vendor_dlkm_modules.tar
    count=$(ls vendor_dlkm/*.ko 2>/dev/null | wc -l)
    echo "  Extracted $count modules to vendor_dlkm/"
fi

# Extract system DLKM modules (GKI modules)
if [ -f "system_dlkm/system_dlkm_modules.tar" ]; then
    echo "Extracting system dlkm modules to system_dlkm/..."
    tar -xf system_dlkm/system_dlkm_modules.tar -C system_dlkm/
    rm system_dlkm/system_dlkm_modules.tar
    count=$(ls system_dlkm/*.ko 2>/dev/null | wc -l)
    echo "  Extracted $count modules to system_dlkm/"
fi

echo ""
echo "Module organization complete:"
echo "  ramdisk/:     $(ls ramdisk/*.ko 2>/dev/null | wc -l) modules (vendor boot)"
echo "  vendor_dlkm/: $(ls vendor_dlkm/*.ko 2>/dev/null | wc -l) modules (vendor dlkm)"
echo "  system_dlkm/: $(ls system_dlkm/*.ko 2>/dev/null | wc -l) modules (GKI/system dlkm)"
