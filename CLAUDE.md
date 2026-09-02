# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Zsh plugin that creates a customizable F-key (F1-F12) shortcut toolbar for tmux. Users define shortcuts in a YAML configuration file, and a Node.js script generates the corresponding Zsh code that binds tmux key handlers and updates the tmux status bar.

## Architecture

### Configuration Pipeline

1. User creates `~/.tmux-keys.yaml` with view definitions and key bindings
2. On plugin load, `tmux-keys.plugin.zsh` checks if config has changed (via file timestamp comparison)
3. If changed (or no cache exists), `generate.js` reads YAML and generates Zsh code with MD5-hashed function names
4. Generated code is cached to `${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh`
5. Plugin sources the cached file, which sets up tmux key bindings and status bar

The caching mechanism avoids unnecessary Node.js invocations on every shell startup.

### Key Components

**tmux-keys.plugin.zsh** (25 lines): Entry point that manages caching and generation
- Only runs inside tmux sessions (returns early if `$TMUX` is unset)
- Uses file timestamp comparison: `[[ "$STAT_CACHE_FILE" -nt "${HOME}/.tmux-keys.yaml" ]]`
- Falls back to `tmux-keys.example.zsh` if `generate.js` fails (via `||` operator)
- Copies example config if `~/.tmux-keys.yaml` doesn't exist
- Follows Zsh Plugin Standard for `$0` handling (lines 5-9)

**generate.js** (~158 lines): YAML config to Zsh code transpiler
- **Structure**:
  - Imports: `yaml`, `fs/promises`, `crypto`, `os` (lines 1-4)
  - `colorMap` object with named colors (lines 9-23)
  - Utility functions: `getRandomColor()`, `md5()` (lines 25-31)
  - Main function: `generateCacheFile()` (lines 33-155)
- Parses `~/.tmux-keys.yaml` using the `yaml` npm package
- Generates view functions with MD5-hashed names to avoid conflicts (e.g., `a02c83a7dbd96295beaefb72c2bee2de_view`)
- Creates three helper functions in output: `unbind_keys()`, `create_key()`, `set_status()`
- Outputs executable Zsh script with case statement for view routing

**Generated output structure**:
- Global variable `left_status` accumulates status bar content
- Each view becomes a function that:
  1. Calls `unbind_keys()` to clear all F1-F12 bindings
  2. Calls `create_key()` for each action (up to 12)
  3. Appends formatted segments to `left_status`
  4. Calls `set_status()` to update tmux status bar
- Case statement at end routes view names to their hash functions

### Action Types

The config supports 5 action types, each generating different tmux commands:

| Type | Generated tmux command | Use case |
|------|----------------------|----------|
| `view` | `run-shell 'zsh <cache> <view_hash>_view'` | Navigate to another F-key view |
| `exec` | `send-keys <key> '<action>\n'` | Execute command (with Enter) |
| `insert` | `send-keys <key> '<action>'` | Insert text (without Enter) |
| `tmux` | `<action>` | Raw tmux command (e.g., `previous-window`) |
| `popup` | `display-popup -w '80%' -h '80%' <action>` | Show command in popup window |

### Color System

View items can specify colors from a predefined map (tmux 256-color palette indices):
- Basic: `red`(1), `green`(2), `yellow`(3), `blue`(4), `magenta`(5), `cyan`(6)
- Extended: `rose`(9), `chartreuse`(10), `orange`(11), `azure`(12), `violet`(13), `springgreen`(14)
- Random color assigned if none specified via `getRandomColor()`

Status bar format: `#[bg=colour8,fg=colour15,bold] <num> #[bg=colour<N>,fg=colour0,bold] <label> #[fg=default,bg=default]`

### Dynamic Titles

Actions support dynamic titles via `title_exec` property:
- If `title_exec` is set, it's executed as a shell command and output used as title
- Falls back to `title` property if set
- Falls back to `action` value if neither is set

Example:
```yaml
- action: "git status"
  type: exec
  title_exec: "git branch --show-current"  # Shows current branch name
```

### Flash Effect

Controlled via `sh` property in config (default: `true` for exec/insert/popup, `false` for view):
- When `sh: true` (or not specified for exec/insert/popup): shows flash message
- When `sh: false`: no flash effect
- Generates: `display -d 600 '#[fill=colour0 bg=colour${5} align=centre] ${2} '`
- Shows centered flash message for 600ms (hardcoded in `create_key()` function)

## Code Structure (generate.js)

```javascript
// Imports (lines 1-4)
import YAML, fs, crypto, os

// User info (lines 6-7)
const userInfo = os.userInfo();
const uid = userInfo.uid;

// Color map (lines 9-23)
const colorMap = { red: "1", green: "2", ... }

// Utilities (lines 25-31)
getRandomColor()  // Returns random color from colorMap
md5()             // Generates MD5 hash for view names

// Main function (lines 33-155)
generateCacheFile()  // Reads YAML, generates Zsh script, writes to cache
```

### Code Characteristics

- Uses inline template literals with nested ternaries for action type handling
- No error handling (crashes propagate to plugin fallback)
- Single monolithic `generateCacheFile()` function
- Views are processed via `Object.entries().map()` pattern
- Key bindings and status bar segments generated inline together

## Testing Changes

No formal test suite exists. To test modifications:

1. **Edit config**: `vim ~/.tmux-keys.yaml`
2. **Force regeneration**: `rm ${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh`
3. **Reload plugin**: `source ~/.zshrc` (or restart zsh)
4. **Inspect generated code**: `cat ${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh`
5. **Verify tmux bindings**: `tmux list-keys -N | grep F[0-9]`
6. **Check status bar**: Look at bottom-right of tmux window

### Testing generate.js Changes

```bash
# Test YAML parsing
node generate.js

# Check output
cat "${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh"

# Test with malformed YAML
echo "invalid: [" > ~/.tmux-keys.yaml
node generate.js  # Should exit with error message

# Restore valid config
cp tmux-keys.example.yaml ~/.tmux-keys.yaml
```

If `generate.js` crashes, the plugin falls back to `tmux-keys.example.zsh`.

## Development Workflow

### Modifying the Generator (generate.js)

When editing `generate.js`:
- **Output is Zsh, not Bash**: Different array syntax, parameter expansion, etc.
- **Escape special chars**: Dollar signs in templates must be escaped: `\${variable}`
- **Test edge cases**: Empty views, missing titles, unknown colors, invalid action types
- **Hardcoded values**: Flash duration (600ms) and popup size (80%) are hardcoded in the script template
- **Template structure**: Keep generated Zsh code readable (indentation, spacing)

**Key areas**:
- **Action type ternary chain** (lines 58-66): Maps action types to `create_key()` parameters
- **Title resolution** (lines 52-56, 73-77): Handles `title_exec`, `title`, or falls back to `action`
- **Flash logic** (line 68): Uses `action.sh` property to control flash effect
- **Helper functions template** (lines 94-138): The Zsh `unbind_keys()`, `create_key()`, `set_status()` functions

### Modifying the Plugin Loader (tmux-keys.plugin.zsh)

When editing `tmux-keys.plugin.zsh`:
- **Respect plugin standard**: Lines 5-9 handle `$0` correctly for all plugin managers
- **Cache location**: Must be user-specific (uses `${UID}`) and writable
- **TMUX check**: Always verify `$TMUX` is set (line 1-3)
- **Error handling**: Use `||` fallback pattern (line 22)
- **mkdir safety**: Create cache dir with `-p` flag (line 16)

### Adding New Action Types

To add a new action type (e.g., `copy` for clipboard):

1. **Update the ternary chain in `generateCacheFile()`** (around line 58-66):
   ```javascript
   action.type === "view"
     ? `'${md5(action.action)}_view' 'view'`
     : action.type === "exec"
     ? `'${action.action}' 'exec'`
     // ... add new type here:
     : action.type === "copy"
     ? `'${action.action}' 'copy'`
     : `'${action.action}' 'popup'`
   ```

2. **Update the `create_key()` function template** (around line 117-127):
   ```javascript
   elif [ "$4" = "copy" ]; then
     tmux_action="run-shell 'echo $3 | xclip -selection clipboard'"
   ```

3. **Update documentation**:
   - Add to README.md action types table
   - Add example to tmux-keys.example.yaml
   - Update CLAUDE.md architecture section

4. **Test thoroughly** with various inputs

### Adding New Colors

1. Add to `colorMap` object in generate.js (lines 9-23)
2. Add to README.md available colors section
3. Use tmux's 256-color palette indices (0-255)

## Common Tasks

### Debugging Generated Code

The generated code uses MD5 hashes for function names. To debug:

```bash
# Find view hash
echo -n "Main" | md5sum
# a02c83a7dbd96295beaefb72c2bee2de

# Search in generated file
grep "a02c83a7dbd96295beaefb72c2bee2de_view" "${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh"
```

### Changing Flash Duration or Popup Size

These values are hardcoded in the script template. Search and replace in generate.js:

- **Flash duration**: Find `display -d 600` in line 112, change `600` to desired milliseconds
- **Popup size**: Find `display-popup -w '80%' -h '80%'` in line 124, change `80%` to desired percentage

### Cache Management

```bash
# View cache location
echo "${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh"

# Clear cache
rm "${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh"

# Force regeneration
touch ~/.tmux-keys.yaml
```

## Known Constraints & Limitations

- **Node.js required**: Only for config generation, not runtime
- **Tmux-only**: Plugin returns early if not in tmux session
- **12 keys maximum**: Limited to F1-F12 (hardware constraint)
- **View names hashed**: Generated function names are MD5 hashes (collision possible but unlikely)
- **No YAML validation**: Invalid configs cause cryptic errors or silent failures
- **No error handling**: generate.js has no try-catch; errors crash the script (plugin falls back to example)
- **Status bar overwrites**: Sets `status-right`, may conflict with other plugins
- **No nested views**: Views are flat; no sub-menus or hierarchies
- **Flash timing global**: All flash effects use same hardcoded duration (600ms)
- **Hardcoded values**: Popup size (80%) and flash duration are not configurable without editing code

## Potential Improvements

- Add JSON schema validation for YAML config
- Support custom F-key ranges (e.g., F1-F8 only)
- Add `--dry-run` flag to generate.js for testing
- Implement view history/navigation stack
- Add TypeScript types for better IDE support
- Support environment variable expansion in actions
- Add logging/debug mode for troubleshooting
- Extract hardcoded values (flash duration, popup size) into constants
- Add try-catch error handling with meaningful error messages
- Refactor into separate template generator functions for better maintainability
