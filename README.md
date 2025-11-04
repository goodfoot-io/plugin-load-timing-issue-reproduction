# Claude Code Plugin Load Timing Issue - Demonstration

## Purpose

This repository demonstrates a timing bug in Claude Code's plugin loading mechanism. Specifically, it shows that the `SessionStart` hook does not execute on the first Claude session when a plugin is loaded from a GitHub marketplace, but does execute on subsequent sessions after the marketplace has been cached.

## Repository Role

This is the **test environment** repository that:
- Configures Claude Code to load a plugin from a remote GitHub marketplace
- Runs test scripts to verify the `SessionStart` hook behavior
- Demonstrates the inconsistent execution timing

The actual plugin implementation is located in a separate marketplace repository (see References below).

## Configuration

### `.claude/settings.json`

This file configures Claude Code with the following settings:

```json
{
  "extraKnownMarketplaces": {
    "plugin-load-timing": {
      "source": {
        "source": "github",
        "repo": "goodfoot-io/plugin-load-timing-issue-reproduction-marketplace"
      }
    }
  },
  "enabledPlugins": {
    "sessionstart-hook-demonstration@plugin-load-timing": true
  }
}
```

**What this does:**
- Registers a GitHub-hosted marketplace named `plugin-load-timing`
- Enables the plugin `sessionstart-hook-demonstration` from that marketplace
- Forces Claude Code to fetch the marketplace asynchronously on first use

## Test Script

### `test-sessionstart-hook.sh`

This script automates the bug reproduction process:

1. **First Claude Run**: Executes `claude -p "Say 'hello world'"`
2. **First Check**: Verifies if `SESSION_START_HOOK_COMPLETE` exists in working directory
3. **Second Claude Run**: Executes `claude -p "Say 'hello world'"` again
4. **Second Check**: Verifies if `SESSION_START_HOOK_COMPLETE` exists in working directory
5. **Cleanup**: Removes the plugin, marketplace, and test file

The `SessionStart` hook in the plugin is designed to create the `SESSION_START_HOOK_COMPLETE` file in the working directory when it executes successfully.

## Reproduction Steps

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd demonstration
   ```

2. **Run the test script**
   ```bash
   bash test-sessionstart-hook.sh
   ```

3. **Observe the output**
   - Pay attention to the file existence checks after the first and second runs
   - The script will display check marks or cross marks indicating success or failure

## Expected Results

The `SessionStart` hook should execute immediately when Claude Code starts, creating the test file on the **first run**:

```
[Step 2] Checking for SESSION_START_HOOK_COMPLETE file after first run...
✅ SESSION_START_HOOK_COMPLETE exists after first run
```

## Actual Results

The `SessionStart` hook does **not** execute on the first run because the marketplace is still loading asynchronously. The file is only created on the **second run** after the marketplace has been cached:

```
[Step 2] Checking for SESSION_START_HOOK_COMPLETE file after first run...
❌ SESSION_START_HOOK_COMPLETE does NOT exist after first run

[Step 4] Checking for SESSION_START_HOOK_COMPLETE file after second run...
✅ SESSION_START_HOOK_COMPLETE exists after second run
```

This demonstrates that plugins loaded from GitHub marketplaces do not have their `SessionStart` hooks executed during the initial session where the marketplace is first downloaded.

## Technical Details

**Root Cause**: When Claude Code encounters a new GitHub marketplace:
1. The marketplace manifest is fetched asynchronously
2. The plugin installation happens in the background
3. The current session proceeds without waiting for plugin initialization
4. Subsequent sessions use the cached marketplace and execute hooks correctly

**Impact**: Any plugin functionality that depends on the `SessionStart` hook will fail silently during the first session after marketplace configuration.

## References

- **Marketplace Repository**: [goodfoot-io/plugin-load-timing-issue-reproduction-marketplace](https://github.com/goodfoot-io/plugin-load-timing-issue-reproduction-marketplace)
- **Main Issue Documentation**: See the root README in the parent repository for complete issue details and analysis
