-- ===========================================================================
-- init.lua — plugin initialisation
-- ===========================================================================
-- Load order matters: git signs must be registered before full-border draws.
-- ===========================================================================

-- ── UI ─────────────────────────────────────────────────────────────────────

-- full-border: draw a rounded border around the entire Yazi layout
require("full-border"):setup {
	type = ui.Border.ROUNDED,
}

-- git: show git-status icons next to every file / directory
-- `order` controls where the icon appears in the file list line
require("git"):setup {
	order = 1500,
}

-- ── Motion ─────────────────────────────────────────────────────────────────

-- relative-motions: vim-style numeric motions (3j, 10gg, …)
-- show_numbers = "relative"  → display relative line numbers (like vim)
-- show_motion  = true        → echo the pending motion in the status bar
require("relative-motions"):setup {
	show_numbers = "relative",
	show_motion  = true,
}

-- ── Previewers ─────────────────────────────────────────────────────────────

-- duckdb: tabular-data previewer (CSV, TSV, Parquet, …)
require("duckdb"):setup()

-- smart-enter: open_multi = true lets `l` open all selected files
-- when multiple files are selected, otherwise just enters the directory.
require("smart-enter"):setup {
	open_multi = true,
}
