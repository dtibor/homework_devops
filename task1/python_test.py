#!/usr/bin/env python3

import subprocess
import shutil
import psutil

# Minimum requirements
MIN_UBUNTU_VERSION = "20.04"
MIN_VCPU = 8
MIN_RAM_GB = 16
MIN_DISK_GB = 32

PASSED = True

print("Checking system requirements...")
print("=================================")

# Check Ubuntu version
ubuntu_version = subprocess.getoutput("lsb_release -rs")
if ubuntu_version == MIN_UBUNTU_VERSION:
    print(f"Ubuntu Version: {ubuntu_version} (Required: {MIN_UBUNTU_VERSION}) [OK]")
else:
    print(f"Ubuntu Version: {ubuntu_version} (Required: {MIN_UBUNTU_VERSION}) [FAILED]")
    PASSED = False

# Check CPU count
cpu_count = psutil.cpu_count(logical=True)
if cpu_count >= MIN_VCPU:
    print(f"CPU Count: {cpu_count} (Required: {MIN_VCPU}) [OK]")
else:
    print(f"CPU Count: {cpu_count} (Required: {MIN_VCPU}) [FAILED]")
    PASSED = False

# Check AVX support
avx_supported = "avx" in subprocess.getoutput("cat /proc/cpuinfo")
if avx_supported:
    print("CPU AVX Support: Available [OK]")
else:
    print("CPU AVX Support: Not Available [FAILED]")
    PASSED = False

# Check RAM
total_ram_gb = round(psutil.virtual_memory().total / (1024**3))
if total_ram_gb >= MIN_RAM_GB:
    print(f"RAM: {total_ram_gb}GB (Required: {MIN_RAM_GB}GB) [OK]")
else:
    print(f"RAM: {total_ram_gb}GB (Required: {MIN_RAM_GB}GB) [FAILED]")
    PASSED = False

# Check Disk Space
free_disk_gb = round(shutil.disk_usage("/").free / (1024**3))
if free_disk_gb >= MIN_DISK_GB:
    print(f"Disk Space: {free_disk_gb}GB free (Required: {MIN_DISK_GB}GB) [OK]")
else:
    print(f"Disk Space: {free_disk_gb}GB free (Required: {MIN_DISK_GB}GB) [FAILED]")
    PASSED = False

print("=================================")

# Final Verdict
if PASSED:
    print("FINAL VERDICT: PASSED")
else:
    print("FINAL VERDICT: FAILED")
