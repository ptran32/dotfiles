-- Day: Rosé Pine Dawn. Night: Sora.
-- Auto mode follows macOS light/dark; <leader>ut cycles auto → light → dark.

local theme_mode = "auto" -- "auto" | "light" | "dark"

local function notify_mode()
  local label = {
    auto = "auto (system)",
    light = "Rosé Pine Dawn",
    dark = "Sora",
  }
  vim.notify("Theme: " .. label[theme_mode], vim.log.levels.INFO)
end

local function macos_dark_mode()
  if vim.fn.has("mac") ~= 1 then
    return true
  end
  local style = vim.trim(vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }))
  return vim.v.shell_error == 0 and style == "Dark"
end

local function use_dark_theme()
  if theme_mode == "light" then
    return false
  end
  if theme_mode == "dark" then
    return true
  end
  return macos_dark_mode()
end

require("rose-pine").setup({
  variant = "dawn",
  dark_variant = "main",
  disable_background = true,
  enable = {
    terminal = true,
  },
  styles = {
    italic = true,
  },
})

require("sora").setup({
  transparent = true,
  italic = true,
  italic_comments = true,
})

local function apply_transparent_highlights()
  local set_hl = vim.api.nvim_set_hl
  for _, group in ipairs({
    "Normal",
    "NormalNC",
    "EndOfBuffer",
    "LineNr",
    "FoldColumn",
    "WinSeparator",
  }) do
    set_hl(0, group, { bg = "NONE" })
  end

  if use_dark_theme() then
    set_hl(0, "CursorLineNr", { fg = "#e6edf3", bg = "#262b38", bold = true })
    set_hl(0, "CursorLineSign", { bg = "#262b38" })
    set_hl(0, "CursorLineFold", { bg = "#262b38" })
    set_hl(0, "CursorLine", { bg = "#262b38" })
  else
    set_hl(0, "CursorLineNr", { fg = "#575279", bg = "#f7f1eb", bold = true })
    set_hl(0, "CursorLineSign", { bg = "#f7f1eb" })
    set_hl(0, "CursorLineFold", { bg = "#f7f1eb" })
    set_hl(0, "CursorLine", { bg = "#f7f1eb" })
  end
end

local function apply_programming_highlights()
  local set_hl = vim.api.nvim_set_hl

  if use_dark_theme() then
    set_hl(0, "SignColumn", { bg = "#1f2430" })
    set_hl(0, "NormalFloat", { bg = "#1f2430" })
    set_hl(0, "FloatBorder", { fg = "#7aa2f7", bg = "#1f2430" })
    set_hl(0, "Pmenu", { bg = "#1f2430" })
    set_hl(0, "PmenuSel", { fg = "#e6edf3", bg = "#2a3142", bold = true })
    set_hl(0, "NonText", { fg = "#7f8ea3" })
    set_hl(0, "Comment", { fg = "#8a99b5", italic = true })
    set_hl(0, "Conceal", { fg = "#8a99b5" })
    set_hl(0, "Directory", { fg = "#89b4fa", bold = true })
    set_hl(0, "SnacksPickerDirectory", { fg = "#89b4fa", bold = true })
    set_hl(0, "SnacksPickerDir", { fg = "#7f8ea3" })
    set_hl(0, "SnacksPickerPathHidden", { fg = "#8a99b5" })
    set_hl(0, "SnacksPickerPathIgnored", { fg = "#8a99b5" })
    set_hl(0, "SnacksPickerComment", { fg = "#8a99b5" })
    set_hl(0, "SnacksPickerDimmed", { fg = "#8a99b5" })
    set_hl(0, "SnacksPickerTree", { fg = "#6f7c96" })
    set_hl(0, "SnacksDashboardDir", { fg = "#8a99b5" })
    set_hl(0, "SnacksDashboardDesc", { fg = "#a9b7d0" })
    set_hl(0, "Visual", { bg = "#2f374a" })
    set_hl(0, "CursorWord", { bg = "#36415a" })
    set_hl(0, "LspReferenceText", { fg = "#e6edf3", bg = "#36415a", bold = true })
    set_hl(0, "LspReferenceRead", { fg = "#e6edf3", bg = "#3a4a67", bold = true })
    set_hl(0, "LspReferenceWrite", { fg = "#e6edf3", bg = "#4a5d7d", bold = true })
    set_hl(0, "Search", { fg = "#111318", bg = "#e0af68", bold = true })
    set_hl(0, "IncSearch", { fg = "#111318", bg = "#ff9e64", bold = true })
    set_hl(0, "CurSearch", { fg = "#111318", bg = "#ff9e64", bold = true })
    set_hl(0, "Added", { fg = "#7bd88f", bg = "#1f3d2e" })
    set_hl(0, "Changed", { fg = "#7dcfff", bg = "#243b53" })
    set_hl(0, "Removed", { fg = "#f7768e", bg = "#3d2028" })
    set_hl(0, "DiffAdd", { fg = "#7bd88f", bg = "#1f3d2e" })
    set_hl(0, "DiffChange", { fg = "#7dcfff", bg = "#243b53" })
    set_hl(0, "DiffDelete", { fg = "#f7768e", bg = "#3d2028" })
    set_hl(0, "DiffText", { fg = "#c9d1d9", bg = "#36506c", bold = true })
    set_hl(0, "NeogitDiffAdd", { fg = "#7bd88f", bg = "#1f3d2e" })
    set_hl(0, "NeogitDiffAddHighlight", { fg = "#a6e3a1", bg = "#244d38" })
    set_hl(0, "NeogitDiffDelete", { fg = "#f7768e", bg = "#3d2028" })
    set_hl(0, "NeogitDiffDeleteHighlight", { fg = "#f38ba8", bg = "#4a2530" })
    set_hl(0, "NeogitDiffContext", { fg = "#c9d1d9", bg = "#1f2430" })
    set_hl(0, "NeogitDiffContextHighlight", { fg = "#e6edf3", bg = "#262b38" })
    set_hl(0, "NeogitHunkHeader", { fg = "#7dcfff", bg = "#243b53", bold = true })
    set_hl(0, "NeogitHunkHeaderHighlight", { fg = "#89b4fa", bg = "#36506c", bold = true })
    set_hl(0, "DiagnosticVirtualTextError", { fg = "#f38ba8", bg = "#351c24" })
    set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#f9e2af", bg = "#3b311d" })
    set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#89dceb", bg = "#1d3139" })
    set_hl(0, "DiagnosticVirtualTextHint", { fg = "#94e2d5", bg = "#1d352f" })
  else
    set_hl(0, "SignColumn", { bg = "#faf4ed" })
    set_hl(0, "NormalFloat", { bg = "#fffaf3" })
    set_hl(0, "FloatBorder", { fg = "#56949f", bg = "#fffaf3" })
    set_hl(0, "Pmenu", { bg = "#fffaf3" })
    set_hl(0, "PmenuSel", { fg = "#232136", bg = "#f2e9de", bold = true })
    set_hl(0, "NonText", { fg = "#5f6472" })
    set_hl(0, "Comment", { fg = "#4b5563", italic = true })
    set_hl(0, "Conceal", { fg = "#4b5563" })
    set_hl(0, "String", { fg = "#713f12" })
    set_hl(0, "Character", { fg = "#713f12" })
    set_hl(0, "Constant", { fg = "#7f1d1d" })
    set_hl(0, "Number", { fg = "#7f1d1d" })
    set_hl(0, "Boolean", { fg = "#7f1d1d" })
    set_hl(0, "Identifier", { fg = "#1e3a8a" })
    set_hl(0, "Function", { fg = "#7f1d1d", bold = true })
    set_hl(0, "Statement", { fg = "#581c87" })
    set_hl(0, "Keyword", { fg = "#581c87" })
    set_hl(0, "PreProc", { fg = "#581c87" })
    set_hl(0, "Type", { fg = "#155e75", bold = true })
    set_hl(0, "Special", { fg = "#7c2d12" })
    set_hl(0, "Directory", { fg = "#286983", bold = true })
    set_hl(0, "SnacksPickerDirectory", { fg = "#286983", bold = true })
    set_hl(0, "SnacksPickerDir", { fg = "#5f6472" })
    set_hl(0, "SnacksPickerPathHidden", { fg = "#4b5563" })
    set_hl(0, "SnacksPickerPathIgnored", { fg = "#4b5563" })
    set_hl(0, "SnacksPickerComment", { fg = "#4b5563" })
    set_hl(0, "SnacksPickerDimmed", { fg = "#4b5563" })
    set_hl(0, "SnacksPickerTree", { fg = "#6b7280" })
    set_hl(0, "SnacksDashboardDir", { fg = "#4b5563" })
    set_hl(0, "SnacksDashboardDesc", { fg = "#575279" })
    set_hl(0, "Visual", { bg = "#e7dacf" })
    set_hl(0, "CursorWord", { bg = "#d8dee9" })
    set_hl(0, "LspReferenceText", { fg = "#232136", bg = "#d8dee9", bold = true })
    set_hl(0, "LspReferenceRead", { fg = "#232136", bg = "#cde0f4", bold = true })
    set_hl(0, "LspReferenceWrite", { fg = "#232136", bg = "#f2d5cf", bold = true })
    set_hl(0, "Search", { fg = "#232136", bg = "#ea9d34", bold = true })
    set_hl(0, "IncSearch", { fg = "#232136", bg = "#d7827e", bold = true })
    set_hl(0, "CurSearch", { fg = "#232136", bg = "#d7827e", bold = true })
    set_hl(0, "Added", { fg = "#286983", bg = "#d9efe0" })
    set_hl(0, "Changed", { fg = "#56949f", bg = "#dce9f8" })
    set_hl(0, "Removed", { fg = "#b4637a", bg = "#f5d7dd" })
    set_hl(0, "DiffAdd", { bg = "#d9efe0" })
    set_hl(0, "DiffChange", { bg = "#dce9f8" })
    set_hl(0, "DiffDelete", { fg = "#b4637a", bg = "#f5d7dd" })
    set_hl(0, "DiffText", { bg = "#c6dbf3", bold = true })
    set_hl(0, "DiagnosticVirtualTextError", { fg = "#b4637a", bg = "#f7dde3" })
    set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#713f12", bg = "#f8ead1" })
    set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#155e75", bg = "#dcedf2" })
    set_hl(0, "DiagnosticVirtualTextHint", { fg = "#155e75", bg = "#dff1ee" })
    set_hl(0, "@comment", { fg = "#4b5563", italic = true })
    set_hl(0, "@string", { fg = "#713f12" })
    set_hl(0, "@string.documentation", { fg = "#713f12" })
    set_hl(0, "@constant", { fg = "#7f1d1d" })
    set_hl(0, "@number", { fg = "#7f1d1d" })
    set_hl(0, "@boolean", { fg = "#7f1d1d" })
    set_hl(0, "@function", { fg = "#7f1d1d", bold = true })
    set_hl(0, "@function.method", { fg = "#7f1d1d", bold = true })
    set_hl(0, "@keyword", { fg = "#581c87" })
    set_hl(0, "@keyword.function", { fg = "#581c87" })
    set_hl(0, "@type", { fg = "#155e75", bold = true })
    set_hl(0, "@variable", { fg = "#2f3346" })
    set_hl(0, "@variable.parameter", { fg = "#4a4f63", italic = true })
  end
end

local function apply_theme()
  if use_dark_theme() then
    vim.o.background = "dark"
    -- Closest stock airline theme to Sora's cool dark palette.
    vim.g.airline_theme = "base16_mocha"
    vim.cmd.colorscheme("sora")
  else
    vim.o.background = "light"
    vim.g.airline_theme = "base16_atelier_seaside_light"
    vim.cmd.colorscheme("rose-pine-dawn")
  end
  apply_transparent_highlights()
  apply_programming_highlights()
  pcall(vim.cmd.AirlineRefresh)
end

local function set_theme_mode(mode)
  theme_mode = mode
  apply_theme()
  notify_mode()
end

local function cycle_theme_mode()
  if theme_mode == "auto" then
    theme_mode = "light"
  elseif theme_mode == "light" then
    theme_mode = "dark"
  else
    theme_mode = "auto"
  end
  apply_theme()
  notify_mode()
end

vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
  group = vim.api.nvim_create_augroup("theme-sync", { clear = true }),
  callback = function()
    if theme_mode == "auto" then
      apply_theme()
    end
  end,
})

vim.api.nvim_create_user_command("ThemeRefresh", function()
  apply_theme()
end, { desc = "Re-apply colorscheme (after system appearance change)" })

vim.api.nvim_create_user_command("ThemeAuto", function()
  set_theme_mode("auto")
end, {})
vim.api.nvim_create_user_command("ThemeLight", function()
  set_theme_mode("light")
end, {})
vim.api.nvim_create_user_command("ThemeDark", function()
  set_theme_mode("dark")
end, {})

vim.keymap.set("n", "<leader>ut", cycle_theme_mode, { desc = "Cycle theme (auto/light/dark)" })

apply_theme()
