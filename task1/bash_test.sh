#!/bin/bash

# Minimum requirements
MIN_UBUNTU_VERSION="20.04"
MIN_VCPU=8
MIN_RAM_GB=16
MIN_DISK_GB=32

PASSED=true

echo "Checking system requirements..."
echo "================================="

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
if [[ "$UBUNTU_VERSION" == "$MIN_UBUNTU_VERSION" ]]; then
    echo "Ubuntu Version: $UBUNTU_VERSION (Required: $MIN_UBUNTU_VERSION) [OK]"
else
    echo "Ubuntu Version: $UBUNTU_VERSION (Required: $MIN_UBUNTU_VERSION) [FAILED]"
    PASSED=false
fi

# Check CPU count
CPU_COUNT=$(nproc)
if [[ $CPU_COUNT -ge $MIN_VCPU ]]; then
    echo "CPU Count: $CPU_COUNT (Required: $MIN_VCPU) [OK]"
else
    echo "CPU Count: $CPU_COUNT (Required: $MIN_VCPU) [FAILED]"
    PASSED=false
fi

# Check AVX support
if grep -q avx /proc/cpuinfo; then
    echo "CPU AVX Support: Available [OK]"
else
    echo "CPU AVX Support: Not Available [FAILED]"
    PASSED=false
fi

# Check RAM
TOTAL_RAM_GB=$(free -g | awk '/Mem:/ {print $2}')
if [[ $TOTAL_RAM_GB -ge $MIN_RAM_GB ]]; then
    echo "RAM: ${TOTAL_RAM_GB}GB (Required: ${MIN_RAM_GB}GB) [OK]"
else
    echo "RAM: ${TOTAL_RAM_GB}GB (Required: ${MIN_RAM_GB}GB) [FAILED]"
    PASSED=false
fi

# Check Disk Space
FREE_DISK_GB=$(df --output=avail -BG / | tail -1 | sed 's/G//g' | xargs)
if [[ $FREE_DISK_GB -ge $MIN_DISK_GB ]]; then
    echo "Disk Space: ${FREE_DISK_GB}GB free (Required: ${MIN_DISK_GB}GB) [OK]"
else
    echo "Disk Space: ${FREE_DISK_GB}GB free (Required: ${MIN_DISK_GB}GB) [FAILED]"
    PASSED=false
fi

echo "================================="

# Final Verdict
if $PASSED; then
    echo "FINAL VERDICT: PASSED"
else
    echo "FINAL VERDICT: FAILED"
fi
