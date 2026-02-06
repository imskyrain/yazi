# Yazi Features Guide: 5 Essential Operations

Complete guide for batch renaming, file operations, app selection, directory jumping, and searching in Yazi.

---

## 1. Batch Rename Files

### Method 1: Built-in Rename (Single File)

**Keybinding**: `r` (current config)

**Usage**:
1. Navigate to the file you want to rename
2. Press `r`
3. Edit the filename (cursor at extension boundary)
4. Press `<Enter>` to confirm

**Variations**:
- `a` - Rename with cursor before extension
- `A` - Rename with cursor at end
- Current config uses: `r` → `rename --cursor=before_ext`

### Method 2: Bulk/Batch Rename (Multiple Files)

**Workflow**:
1. **Select files** to rename:
   - Press `<Space>` on each file to toggle selection
   - Or press `v` to enter visual mode, then move cursor to select range
   - Or press `<C-a>` to select all files

2. **Open bulk rename**:
   - Press `r` - Opens `$EDITOR` with all selected filenames
   - Each line is one filename

3. **Edit in your editor**:
   - Modify filenames as needed
   - You can use vim/nvim features:
     - `:%s/old/new/g` - Replace text in all names
     - Visual block mode for column editing
     - Multiple cursors if using modern editor

4. **Save and exit**:
   - Save the file and exit editor
   - Yazi will rename all files accordingly

**Example - Batch rename workflow**:
```bash
# Before:
IMG_001.jpg
IMG_002.jpg
IMG_003.jpg

# In editor, change to:
vacation_001.jpg
vacation_002.jpg
vacation_003.jpg

# Yazi renames all files when you save
```

### Method 3: Plugin-Based Bulk Rename (Advanced)

Some yazi plugins provide enhanced renaming:
- **bulk-rename.yazi** - Specialized bulk rename with regex support
- **renamer.yazi** - Visual bulk rename interface

**Installation** (example for bulk-rename):
```bash
# Clone plugin
git clone https://github.com/yazi-rs/plugins/bulk-rename.yazi ~/.config/yazi/plugins/bulk-rename.yazi

# Add to keymap.toml
{ on = "R", run = "plugin bulk-rename", desc = "Bulk rename" }
```

### Tips for Batch Renaming

- **Sequential numbering**: Use vim substitution
  ```vim
  :%s/IMG/photo_00/g
  ```

- **Add prefix**: Visual block mode or substitution
  ```vim
  :%s/^/prefix_/
  ```

- **Remove prefix**: Substitution
  ```vim
  :%s/^prefix_//
  ```

- **Change extension**: Substitution
  ```vim
  :%s/\.txt$/.md/
  ```

- **Date prefix**: External tools in vim
  ```vim
  :%!awk '{print "2024-02-06_" $0}'
  ```

---

## 2. Cut/Move Files and Create Directories

### Basic Cut & Paste Workflow

**Your current keybindings**:
- `x` - Cut files (yank with cut)
- `p` - Paste files
- `P` - Paste with force (overwrite)

**Step-by-step**:

1. **Select files to move**:
   - Navigate to files
   - Press `<Space>` to select multiple, or
   - Press `v` for visual mode selection

2. **Cut the files**:
   - Press `x` (or `dd` in some configs)
   - Files are marked for cutting (visual indicator)

3. **Navigate to destination**:
   - Use `h/j/k/l` or arrow keys
   - Change directories with `l` (enter) or `h` (parent)

4. **Paste files**:
   - Press `p` to paste
   - Files are moved from source to current directory

### Creating Directories for Move Operation

**Method 1: Create directory first, then paste**

1. **Navigate to parent directory**
2. **Create new directory**:
   - Press `a` - Opens create prompt
   - Type directory name with trailing `/`: `new_folder/`
   - Press `<Enter>`
3. **Enter the new directory**: Press `l`
4. **Paste files**: Press `p`

**Method 2: Create nested directories**

Yazi's create command supports nested paths:

1. Press `a`
2. Type: `parent/child/grandchild/`
3. Press `<Enter>`
4. Yazi creates all directories in the path

**Example workflow**:
```bash
# Current directory: ~/Downloads
# Want to move IMG_001.jpg to ~/Downloads/2024/February/

1. Select IMG_001.jpg
2. Press `x` (cut)
3. Press `a`
4. Type: `2024/February/`
5. Press <Enter>
6. Navigate to 2024/February/: `l` → `l`
7. Press `p` (paste)
```

### Shell Command Method (Advanced)

For complex operations, use shell:

1. **Press `;` or `:`** (shell command)
2. **Use shell commands**:
   ```bash
   # Create directory and move files in one command
   mkdir -p target/nested/path && mv "$@" target/nested/path/

   # Move and rename
   mkdir -p archive/2024 && mv *.jpg archive/2024/
   ```

### Tips

- **Undo cut**: Press `Y` or `X` to cancel yank/cut
- **Copy instead of cut**: Press `y` instead of `x`
- **Force overwrite**: Use `P` instead of `p`
- **Create file**: `a` without trailing `/` creates a file

---

## 3. Open Files with Specific Apps

### Method 1: Interactive Opener (Recommended)

**Keybinding**: `O` (capital O) or `r` in reference config

**Usage**:
1. Navigate to file
2. Press `O` (Shift+o)
3. Yazi shows a menu of available openers
4. Select the opener with `j/k` and `<Enter>`

**Example**:
```
File: large_file.txt

Press `O` → Menu appears:
  1. $EDITOR
  2. Open (default app)
  3. Reveal in Finder

Select option → File opens
```

### Method 2: Configure Custom Openers

Edit `yazi.toml` to add custom openers:

```toml
[opener]
# Sublime Text opener
sublime = [
    { run = 'subl "$@"', desc = "Sublime Text", for = "macos" }
]

# Numbers (for Excel files)
numbers = [
    { run = 'open -a Numbers "$@"', desc = "Numbers", for = "macos" }
]

# VS Code
vscode = [
    { run = 'code "$@"', desc = "VS Code", for = "macos" }
]

# Preview app (macOS)
preview = [
    { run = 'open -a Preview "$@"', desc = "Preview", for = "macos" }
]

# VLC for videos
vlc = [
    { run = 'open -a VLC "$@"', desc = "VLC", for = "macos" }
]
```

Then add these to your open rules:

```toml
[open]
rules = [
    # Large text files → offer Sublime
    { mime = "text/*", use = ["edit", "sublime", "vscode", "reveal"] },

    # Excel/Numbers
    { mime = "application/vnd.ms-excel", use = ["numbers", "open", "reveal"] },
    { mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      use = ["numbers", "open", "reveal"] },

    # Images → Preview or default
    { mime = "image/*", use = ["preview", "open", "reveal"] },

    # Video → VLC or mpv
    { mime = "video/*", use = ["vlc", "play", "reveal"] },

    # PDFs
    { mime = "application/pdf", use = ["preview", "open", "reveal"] },

    # Fallback
    { url = "*", use = ["open", "reveal"] },
]
```

### Method 3: Shell Command

For one-off opens with specific apps:

1. Press `;` or `:` (shell command)
2. Type command:
   ```bash
   # Open with Sublime
   subl "$f"

   # Open with Numbers
   open -a Numbers "$f"

   # Open with specific app
   open -a "Application Name" "$f"
   ```

### Method 4: macOS `open` Command Integration

Add a generic app picker:

```toml
[opener]
choose = [
    { run = 'open -a "$0" "$@"', desc = "Choose app...", for = "macos" }
]
```

Then use shell to specify:
```bash
# Shell command:
open -a "Sublime Text" "$f"
```

### Practical Examples

**Scenario 1: Large text file with Sublime**

```toml
# Add to yazi.toml
[opener]
sublime = [
    { run = 'open -a "Sublime Text" "$@"', desc = "Sublime", for = "macos" }
]

[open]
rules = [
    { mime = "text/*", use = ["edit", "sublime", "reveal"] },
    # ... other rules
]
```

Then: Press `O` on any text file → Choose "Sublime"

**Scenario 2: Excel files with Numbers**

```toml
[opener]
numbers = [
    { run = 'open -a Numbers "$@"', desc = "Numbers", for = "macos" }
]
excel = [
    { run = 'open -a "Microsoft Excel" "$@"', desc = "Excel", for = "macos" }
]

[open]
rules = [
    { mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      use = ["numbers", "excel", "reveal"] },
    { url = "*.xlsx", use = ["numbers", "excel", "reveal"] },
]
```

### Quick Reference - macOS Apps

```bash
# Common app names for macOS `open -a`:
open -a "Sublime Text" file.txt
open -a "Visual Studio Code" file.py
open -a Numbers file.xlsx
open -a "Microsoft Excel" file.xlsx
open -a Preview image.png
open -a VLC video.mp4
open -a "Adobe Acrobat Reader" file.pdf
```

---

## 4. Quick Directory Jumping

Your config has multiple methods for directory jumping:

### Method 1: fzf Integration (Fastest)

**Keybinding**: `z`

**Usage**:
1. Press `z`
2. fzf opens with directory list
3. Type to fuzzy search
4. Press `<Enter>` to jump

**Features**:
- Fuzzy matching
- Real-time filtering
- Preview support
- Fast search through entire directory tree

### Method 2: zoxide Integration (Frecency-based)

**Keybinding**: `Z` (capital Z)

**What is zoxide**:
- Tracks your most frequently and recently used directories
- Learns your habits over time
- Jumps based on "frecency" (frequency + recency)

**Usage**:
1. Press `Z`
2. Type partial directory name
3. zoxide finds the most likely match
4. Press `<Enter>` to jump

**Example**:
```bash
# You frequently visit:
# ~/Projects/work/client-app
# ~/Documents/personal/photos

# In yazi, press `Z`
# Type: "client" → jumps to ~/Projects/work/client-app
# Type: "photos" → jumps to ~/Documents/personal/photos
```

**Setup zoxide** (if not installed):
```bash
# Install
brew install zoxide

# Add to shell config (.zshrc or .bashrc)
eval "$(zoxide init zsh)"  # or bash
```

### Method 3: cdhist - Directory History

**Keybinding**: `<Alt-c>` (Option+C on macOS)

**Usage**:
1. Press `<Alt-c>`
2. Fuzzy search through previously visited directories (in current session)
3. Select and jump

**Great for**:
- Bouncing between recently visited directories
- Session-based navigation

### Method 4: Goto Shortcuts (Bookmarks)

**Current keybindings**:
```
gh       → Home directory (~)
gc       → Config directory (~/.config)
gd       → Downloads
g<Space> → Interactive cd (type path)
```

**Adding custom shortcuts**:

Edit `keymap.toml`:
```toml
[mgr]
keymap = [
    # Add your custom shortcuts
    { on = ["g", "p"], run = "cd ~/Projects", desc = "Go to Projects" },
    { on = ["g", "w"], run = "cd ~/Projects/work", desc = "Go to Work" },
    { on = ["g", "D"], run = "cd ~/Documents", desc = "Go to Documents" },
    { on = ["g", "i"], run = "cd ~/Pictures", desc = "Go to Pictures" },
    { on = ["g", "v"], run = "cd ~/.config/nvim", desc = "Go to nvim config" },
    # ... rest of config
]
```

### Method 5: Shell cd with Tab Completion

**Keybinding**: `g<Space>` or custom

**Usage**:
1. Press `g` then `<Space>`
2. Yazi opens input prompt
3. Type path (with tab completion in some setups)
4. Press `<Enter>` to jump

### Method 6: Add yamb Plugin (Bookmark Manager)

The reference config has `yamb.yazi` for persistent bookmarks:

**Installation**:
```bash
# Install yamb plugin
git clone https://github.com/h-hg/yamb.yazi ~/.config/yazi/plugins/yamb.yazi
```

**Add to init.lua**:
```lua
require("yamb"):setup {
    cli = "fzf",  -- or "sk" for skim
}
```

**Add keybindings** to `keymap.toml`:
```toml
[mgr]
keymap = [
    { on = ["'", "a"], run = "plugin yamb save", desc = "Add bookmark" },
    { on = ["'", "'"], run = "plugin yamb jump_by_fzf", desc = "Jump to bookmark" },
    { on = ["'", "r"], run = "plugin yamb delete_by_key", desc = "Delete bookmark" },
    # ... rest
]
```

**Usage**:
1. Navigate to directory you want to bookmark
2. Press `'a` (quote, then a)
3. Give it a name
4. Later, press `''` (quote twice) to fuzzy-find and jump to bookmarks

### Comparison Table

| Method | Keybinding | Best For | Requires |
|--------|-----------|----------|----------|
| **fzf** | `z` | Fast search entire tree | fd + fzf |
| **zoxide** | `Z` | Frecent directories | zoxide |
| **cdhist** | `<A-c>` | Recent directories | cdhist plugin |
| **goto** | `gh`, `gc`, etc. | Common shortcuts | - |
| **yamb** | `''` | Personal bookmarks | yamb plugin |
| **interactive cd** | `g<Space>` | Type exact path | - |

### Recommended Workflow

1. **Frequent dirs**: Use `zoxide` (`Z`) - learns your patterns
2. **Project navigation**: Add custom `g?` shortcuts
3. **Recent dirs**: Use `cdhist` (`<A-c>`)
4. **Find unknown**: Use `fzf` (`z`)
5. **Important dirs**: Bookmark with `yamb` (`''`)

---

## 5. Search in Current Directory

### Method 1: Filter (Live Filtering)

**Keybinding**: `f`

**Usage**:
1. Press `f`
2. Type search term
3. File list filters in real-time
4. Navigate filtered results with `j/k`
5. Press `<Enter>` to select, `<Esc>` to clear

**Features**:
- Instant feedback
- Smart case-insensitive (lowercase = ignore case)
- Shows matching files only
- Great for quick filtering

**Example**:
```
Files in directory:
  report_2024.pdf
  report_2023.pdf
  invoice_jan.xlsx
  invoice_feb.xlsx

Press `f` → Type "2024"
  → Shows: report_2024.pdf

Press `f` → Type "invoice"
  → Shows: invoice_jan.xlsx, invoice_feb.xlsx
```

### Method 2: Find (Jump to File)

**Keybinding**: `/` (forward) or `?` (backward)

**Usage**:
1. Press `/`
2. Type characters to find
3. Press `<Enter>` or `n` to jump to next match
4. Press `N` to jump to previous match

**Difference from filter**:
- **Filter** (`f`): Shows only matching files
- **Find** (`/`): Jumps to matching file, keeps all visible

### Method 3: Search Files by Name (fd)

**Keybinding**: `s` (based on config)

**Usage**:
1. Press `s`
2. Type filename pattern
3. Press `<Enter>`
4. Yazi searches recursively using `fd`
5. Shows results, navigate with `j/k`

**Features**:
- Recursive search (searches subdirectories)
- Fast (using fd or find)
- Respects .gitignore by default

**Example**:
```bash
# Search for all PDF files recursively
Press `s` → Type "*.pdf" → Shows all PDFs in tree

# Search for files containing "report"
Press `s` → Type "report" → Shows all files matching
```

### Method 4: Search Files by Content (ripgrep)

**Keybinding**: `S` (capital S) or `F`

**Usage**:
1. Press `S`
2. Type text to search for (content inside files)
3. Press `<Enter>`
4. Yazi searches file contents using `ripgrep`
5. Shows files containing the text

**Features**:
- Full-text search
- Very fast (ripgrep)
- Respects .gitignore
- Shows match context

**Example**:
```bash
# Find all files containing "TODO"
Press `S` → Type "TODO" → Shows files with TODO comments

# Find all Python files with "import pandas"
Press `S` → Type "import pandas" → Shows matching .py files
```

### Method 5: Escape Search

**Keybinding**: `<C-s>` (Ctrl+S)

**Usage**:
- Cancel ongoing search
- Clear search highlighting
- Return to normal view

### Advanced: Shell-based Search

**Keybinding**: `;` or `:` (shell command)

**Custom searches**:

```bash
# Find files modified in last 24 hours
find . -type f -mtime -1

# Find large files (>100MB)
find . -type f -size +100M

# Find files by extension
fd -e pdf

# Search with pattern
fd "pattern.*\.txt$"

# Content search with context
rg "search term" -A 3 -B 3
```

### Search Comparison

| Method | Key | Type | Scope | Speed | Use Case |
|--------|-----|------|-------|-------|----------|
| **Filter** | `f` | Name | Current dir | Instant | Quick filtering |
| **Find** | `/` | Name | Current dir | Instant | Jump to file |
| **Search (fd)** | `s` | Name | Recursive | Fast | Find files in tree |
| **Search (rg)** | `S` | Content | Recursive | Fast | Find text in files |
| **Shell** | `;` | Custom | Anywhere | Varies | Complex queries |

### Practical Examples

**Example 1: Find recent downloads**
```
1. Navigate to ~/Downloads
2. Press `f`
3. Type file name or extension
4. Navigate to file
```

**Example 2: Find TODO comments in project**
```
1. Navigate to project root
2. Press `S` (content search)
3. Type "TODO"
4. See all files with TODOs
```

**Example 3: Find large video files**
```
1. Navigate to directory
2. Press `;` (shell)
3. Type: fd -e mp4 -e mkv -x ls -lh {}
4. See list with sizes
```

**Example 4: Filter by date pattern**
```
1. Navigate to directory with dated files
2. Press `f`
3. Type "2024-02"
4. See all files from February 2024
```

### Tips

- **Case sensitivity**: Lowercase = case-insensitive, any uppercase = case-sensitive
- **Clear filter**: Press `<Esc>` to clear filter/find
- **Smart search**: Use `--smart` flag in custom keybindings for smart-case search
- **Preview matches**: Many search results show file preview
- **Regex support**: `fd` and `rg` support regex patterns

---

## Summary - Quick Reference Card

```
╔══════════════════════════════════════════════════════════════╗
║                    YAZI QUICK REFERENCE                      ║
╠══════════════════════════════════════════════════════════════╣
║ 1. BATCH RENAME                                              ║
║    r              Rename file(s) - opens $EDITOR for bulk    ║
║    <Space>        Select files, then r for batch rename      ║
║                                                              ║
║ 2. CUT/MOVE + CREATE DIRS                                    ║
║    x              Cut files                                  ║
║    p              Paste files                                ║
║    a              Create file/dir (end with / for dir)       ║
║    a parent/child/  Create nested directories               ║
║                                                              ║
║ 3. OPEN WITH APPS                                            ║
║    O              Interactive opener (choose app)            ║
║    ;              Shell command (open -a "App" "$f")         ║
║    Edit yazi.toml  Add custom openers                        ║
║                                                              ║
║ 4. DIRECTORY JUMPING                                         ║
║    z              fzf fuzzy directory search                 ║
║    Z              zoxide frecent directories                 ║
║    <A-c>          cdhist directory history                   ║
║    gh,gc,gd       Quick goto shortcuts                       ║
║    g<Space>       Interactive cd (type path)                 ║
║    '' (yamb)      Bookmark jump (needs plugin)              ║
║                                                              ║
║ 5. SEARCH                                                    ║
║    f              Filter (live filtering in current dir)     ║
║    /              Find (jump to file in current dir)         ║
║    s              Search by name (recursive, uses fd)        ║
║    S              Search by content (recursive, uses rg)     ║
║    <C-s>          Cancel search                              ║
║    ;              Shell search (custom queries)              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Next Steps

1. **Test each feature** in yazi
2. **Customize keybindings** to your preference
3. **Install recommended plugins**:
   - yamb.yazi for bookmarks
   - bulk-rename.yazi for advanced renaming
4. **Configure custom openers** for your favorite apps
5. **Set up zoxide** for frecent directory jumping
6. **Create custom goto shortcuts** for your common directories

Happy file managing with Yazi!
