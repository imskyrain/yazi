# Yazi Config Comparison: Reference vs Local

## Overview
Comparison between reference config (`~/.config/yazi/`) and local config (`~/Tools/git_core/github/yazi/`).

---

## Key Differences

### 1. Plugins

**Reference config** (6 plugins):
- `compress.yazi` - Archive compression
- `git.yazi` - Git status integration
- `smart-enter.yazi` - Smart file opening
- `starship.yazi` - Starship prompt
- `yamb.yazi` - Bookmark manager (fzf-based)
- `yaziline.yazi` - Custom statusline

**Local config** (14 plugins):
- `cdhist.yazi` - Directory history fuzzy jump
- `chmod.yazi` - Interactive permission changer
- `duckdb.yazi` - Tabular data preview (CSV, Parquet, etc.)
- `exifaudio.yazi` - Audio metadata with cover art
- `full-border.yazi` - Rounded border UI
- `git.yazi` - Git status integration
- `mediainfo.yazi` - Media file previews (audio/video/image)
- `mount.yazi` - Partition mount/unmount manager
- `office.yazi` - Office document previews
- `ouch.yazi` - Archive compression/extraction
- `piper.yazi` - Fallback previewer with hexyl
- `relative-motions.yazi` - Vim-style numeric motions
- `smart-enter.yazi` - Smart file opening

### 2. Keymap Philosophy

**Reference config**:
- Colemak layout (u/e for up/down instead of k/j)
- Custom navigation: n=left, i=right
- Number keys (1-9) for direct tab switching
- Bookmark system with `'a`, `''`, `'r`

**Local config**:
- Standard Vim bindings (k/j for up/down)
- Standard hjkl navigation
- Ctrl+number for tab switching (numbers free for relative-motions)
- Relative motions plugin (vim-style 3j, 10gg)
- Alt+h/Alt+l for back/forward (frees H/L for duckdb column scroll)

### 3. File Manager Settings (yazi.toml)

#### Sorting & Display

**Reference**:
```toml
sort_by = "alphabetical"
sort_reverse = false
sort_dir_first = true
linemode = "size"
ratio = [1, 3, 4]
```

**Local**:
```toml
sort_by = "btime"        # Sort by birth time (creation)
sort_reverse = true      # Newest first
sort_dir_first = false   # Mix files and dirs
linemode = "none"        # No metadata column
ratio = [1, 4, 3]        # Wider center panel
```

**Recommendation**: Consider local's `btime` + `sort_reverse=true` for seeing newest files first.

#### Archive Extraction

**Reference**: Uses `ya pub extract`
**Local**: Uses `ouch` tool with `ouch d -y`

**Recommendation**: Install `ouch` for better archive handling.

#### Tasks

**Reference**:
```toml
image_alloc = 536870912  # 512MB
```

**Local**:
```toml
image_alloc = 1073741824  # 1GB (for large media files)
```

**Recommendation**: Use 1GB if you preview large videos/images.

#### Plugins & Previewers

**Reference**:
- Basic previewers (image, video, pdf, font, code, json, archive)
- Uses `prepend_fetchers` for git

**Local**:
- Advanced previewer stack:
  - `mediainfo.yazi` replaces built-in image/video/magick
  - `office.yazi` for Office docs (.docx, .xlsx)
  - `duckdb.yazi` for tabular data (.csv, .parquet, .db)
  - `ouch.yazi` replaces built-in archive previewer
  - `piper` with `hexyl` fallback for unknown files
- Uses `fetchers` array (newer syntax) instead of `prepend_fetchers`
- Explicit MIME handling for many formats

**Recommendation**: Adopt local's plugin stack for better file preview support.

### 4. UI & Dialogs

**Reference**:
- Uses `[input]` section for prompts
- Separate trash/delete/overwrite/quit settings

**Local**:
- Uses both `[input]` and `[confirm]` sections (v25.12.29+ syntax)
- `overwrite_body` and `quit_body` replace old `content` key
- Centered dialogs for confirmations

**Recommendation**: Update to local's newer dialog syntax.

### 5. Keybinding Highlights

**Reference unique bindings**:
- `P` - Open spotter
- `['a]` - Add bookmark
- `['']` - Jump bookmark
- `ca` - Archive with compress plugin
- `S` - Shell prompt
- Colemak-friendly bindings

**Local unique bindings**:
- `M` - Mount manager
- `C` - Compress with ouch
- `<A-c>` - Jump via cdhist (directory history)
- `<C-m>` - chmod plugin
- `H/L` - Scroll columns in duckdb preview
- `<F9>` - Toggle mediainfo metadata
- `z/Z` - fzf/zoxide (swapped from reference)
- Relative motions (1-9 for vim-style counts)
- `<C-c>` - Close tab (vs `q`)

### 6. init.lua

**Reference**:
- yaziline statusline with custom symbols
- Starship prompt integration
- User/group display in status
- yamb bookmark setup

**Local**:
- full-border rounded UI
- git status integration
- relative-motions with `show_numbers = "relative"`
- duckdb setup
- smart-enter with `open_multi = true`

---

## Recommended Upgrades for Local Config

### High Priority

1. **Add bookmark system** - Reference's yamb plugin is very useful
   - Add `yamb.yazi` plugin
   - Add keybindings: `['a]`, `['']`, `['r]`

2. **Consider Colemak bindings** (if you use Colemak keyboard)
   - Reference has well-thought-out Colemak mappings

3. **Add statusline customization**
   - Reference's yaziline + starship setup looks polished
   - Consider adding user/group display

### Medium Priority

4. **Archive compression** - Reference has compress.yazi
   - You have ouch.yazi, but compress.yazi might offer more options
   - Compare both plugins

5. **Spotter integration** (if available)
   - Reference has `P` for spotter - check if this is macOS Spotlight integration

6. **Keybinding refinements**
   - `<C-g>` for lazygit (reference has this, check if local has it)

### Low Priority

7. **Panel ratio** - Try reference's `[1, 3, 4]` vs local's `[1, 4, 3]`
8. **Sorting defaults** - Test both approaches
9. **Linemode** - Test `size` vs `none`

---

## Things to Keep from Local

1. **Plugin ecosystem** - Much richer (14 vs 6 plugins)
2. **Modern syntax** - Uses latest yazi config format
3. **Relative motions** - Vim users will love this
4. **Advanced previewers** - mediainfo, office, duckdb are excellent
5. **Numeric motions** - Very efficient for vim users
6. **Mount manager** - Useful for external drives
7. **chmod plugin** - Interactive permission editing
8. **cdhist** - Directory history is very useful

---

## Action Items

- [ ] Install yamb plugin for bookmarks
- [ ] Test both sorting strategies (alphabetical vs btime)
- [ ] Compare compress.yazi vs ouch.yazi
- [ ] Check if spotter is available/useful
- [ ] Consider adding starship + yaziline for better UI
- [ ] Test panel ratios
- [ ] Review keybinding conflicts
- [ ] Add user/group status display if desired
