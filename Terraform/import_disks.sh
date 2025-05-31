#!/bin/bash
set -e

VMID=$1
STORAGE=$2

cd /var/lib/vz/template/cache
tar -xvf 9.1.0.0.ova
qm set "$VMID" -rng0 /dev/urandom
# Import all 22 VMDKs
for d in {1..22}; do
  qm importdisk "$VMID" "9.1.0.0-disk${d}.vmdk" "$STORAGE"
done

# Wait until the last LV appears
until pvesm path "${STORAGE}:vm-${VMID}-disk-21" >/dev/null 2>&1; do
  sleep 2
done

# Attach disks
qm set "$VMID" -delete ide0

# IDE 0–3
for i in 0 1 2 3; do
  qm set "$VMID" -ide${i} "${STORAGE}:vm-${VMID}-disk-${i}"
done

# SCSI 0–15
idx=0
for i in $(seq 4 19); do
  qm set "$VMID" -scsi${idx} "${STORAGE}:vm-${VMID}-disk-${i}"
  idx=$((idx+1))
done

# SATA 0–1
for i in 20 21; do
  port=$((i-20))
  qm set "$VMID" -sata${port} "${STORAGE}:vm-${VMID}-disk-${i}"
done

# Attach disks
qm set "$VMID" -scsi0 "$STORAGE:vm-${VMID}-disk-0"
qm set "$VMID" -ide0 "$STORAGE:vm-${VMID}-disk-1"


