#!/bin/bash

# Test script for SessionStart hook demonstration
# This script tests whether the SessionStart hook creates SESSION_START_HOOK_COMPLETE file

set -e

echo "=========================================="
echo "SessionStart Hook Test Script"
echo "=========================================="
echo ""

# Step 1: First Claude run
echo "[Step 1] Running first Claude command..."
claude -p "Say 'hello world'"
echo ""

# Step 2: Check for SESSION_START_HOOK_COMPLETE after first run
echo "[Step 2] Checking for SESSION_START_HOOK_COMPLETE file after first run..."
if [ -f /workspace/SESSION_START_HOOK_COMPLETE ]; then
    echo "✅ SESSION_START_HOOK_COMPLETE exists after first run"
    echo "   Content:"
    cat /workspace/SESSION_START_HOOK_COMPLETE | sed 's/^/   /'
else
    echo "❌ SESSION_START_HOOK_COMPLETE does NOT exist after first run"
fi
echo ""

# Step 3: Second Claude run
echo "[Step 3] Running second Claude command..."
claude -p "Say 'hello world'"
echo ""

# Step 4: Check for SESSION_START_HOOK_COMPLETE after second run
echo "[Step 4] Checking for SESSION_START_HOOK_COMPLETE file after second run..."
if [ -f /workspace/SESSION_START_HOOK_COMPLETE ]; then
    echo "✅ SESSION_START_HOOK_COMPLETE exists after second run"
    echo "   Content:"
    cat /workspace/SESSION_START_HOOK_COMPLETE | sed 's/^/   /'
else
    echo "❌ SESSION_START_HOOK_COMPLETE does NOT exist after second run"
fi
echo ""

# Step 5: Remove plugin
echo "[Step 5] Removing plugin..."
claude plugin remove "sessionstart-hook-demonstration@plugin-load-timing"
echo ""

# Step 6: Remove marketplace
echo "[Step 6] Removing marketplace..."
claude plugin marketplace remove "plugin-load-timing"
echo ""

# Step 7: Clean up SESSION_START_HOOK_COMPLETE file
echo "[Step 7] Cleaning up SESSION_START_HOOK_COMPLETE file..."
if [ -f /workspace/SESSION_START_HOOK_COMPLETE ]; then
    rm /workspace/SESSION_START_HOOK_COMPLETE
    echo "✅ Removed SESSION_START_HOOK_COMPLETE"
else
    echo "ℹ️  SESSION_START_HOOK_COMPLETE already removed or never existed"
fi
echo ""

echo "=========================================="
echo "Test script complete!"
echo "=========================================="
