#!/bin/bash

CONFIG_FILE="app_config.conf"
SWAP_FILE=".app_config.conf.swp"

echo "=== vi/vim Crash Recovery Simulation Utility ==="
echo "--------------------------------------------------"

# Step 1: Create initial baseline configuration file
cat << 'ORIG' > "$CONFIG_FILE"
# Production Database Configuration
DB_HOST=127.0.0.1
DB_PORT=5432
MAX_CONNECTIONS=100
ORIG

echo "[1] Initial baseline configuration file created ('$CONFIG_FILE'):"
cat "$CONFIG_FILE"
echo ""

# Step 2: Simulate uncommitted edits and abnormal crash by creating swap file state
vim -u NONE -N -c "e $CONFIG_FILE" -c "normal GoDB_TIMEOUT=3000" -c "preserve" -c "q!" 2>/dev/null

echo "[2] Simulating sudden system crash during unsaved editing session..."
if [ -f "$SWAP_FILE" ]; then
    echo "    SUCCESS: Swap file '$SWAP_FILE' detected on disk."
fi
echo ""

# Step 3: Demonstrate Recovery using auto-recovery mechanism (vim -r)
echo "[3] Executing auto-recovery mechanism ('vim -r $CONFIG_FILE')..."
vim -u NONE -N -r "$CONFIG_FILE" -c "w! recovered_config.conf" -c "q!" 2>/dev/null

echo "    Recovered Unsaved File Content ('recovered_config.conf'):"
cat recovered_config.conf
echo ""

# Step 4: Verification diff between original file and recovered state
echo "[4] Diff comparison (Original Baseline vs Recovered Unsaved State):"
diff -u "$CONFIG_FILE" recovered_config.conf || true
echo ""

# Step 5: Clean up orphan swap file after successful verification
rm -f "$SWAP_FILE"
echo "[5] Orphan swap file '$SWAP_FILE' safely deleted after recovery."
