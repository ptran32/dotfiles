-- Superlogical Rex-inspired dark palette.

require("sora").setup({
  transparent = true,
  italic = true,
  italic_comments = true,
})

local function apply_surface_highlights()
  local set_hl = vim.api.nvim_set_hl

  -- Rex surfaces: terminal #0D1117, page #161B22, card #1C2128,
  -- hover #21262D. Explicit backgrounds keep split panes consistent.
  for _, group in ipairs({ "Normal", "NormalNC", "EndOfBuffer", "LineNr", "FoldColumn" }) do
    set_hl(0, group, { bg = "#0D1117" })
  end
  set_hl(0, "WinSeparator", { fg = "#30363D", bg = "#0D1117" })
  set_hl(0, "CursorLineNr", { fg = "#E6EDF3", bg = "#21262D", bold = true })
  set_hl(0, "CursorLineSign", { bg = "#21262D" })
  set_hl(0, "CursorLineFold", { bg = "#21262D" })
  set_hl(0, "CursorLine", { bg = "#21262D" })

  for _, group in ipairs({
    "NormalFloat",
    "SnacksNormal",
    "SnacksNormalNC",
    "SnacksExplorerNormal",
    "SnacksPickerNormal",
    "SnacksPickerNormalFloat",
    "SnacksPickerBoxNormalFloat",
    "SnacksPickerInputNormalFloat",
    "SnacksPickerListNormalFloat",
    "SnacksPickerPreviewNormalFloat",
  }) do
    set_hl(0, group, { bg = "#161B22" })
  end
end

local function apply_programming_highlights()
  local set_hl = vim.api.nvim_set_hl

  set_hl(0, "SignColumn", { bg = "#0D1117" })
    set_hl(0, "FloatBorder", { fg = "#58A6FF", bg = "#161B22" })
    set_hl(0, "Pmenu", { bg = "#1C2128" })
    set_hl(0, "PmenuSel", { fg = "#E6EDF3", bg = "#21262D", bold = true })
    set_hl(0, "NonText", { fg = "#6E7681" })
    set_hl(0, "Comment", { fg = "#8B949E", italic = true })
    set_hl(0, "Conceal", { fg = "#8B949E" })
    set_hl(0, "String", { fg = "#A5D6FF" })
    set_hl(0, "Character", { fg = "#A5D6FF" })
    set_hl(0, "Constant", { fg = "#79C0FF" })
    set_hl(0, "Number", { fg = "#79C0FF" })
    set_hl(0, "Boolean", { fg = "#79C0FF" })
    set_hl(0, "Identifier", { fg = "#E6EDF3" })
    set_hl(0, "Function", { fg = "#D2A8FF", bold = true })
    set_hl(0, "Statement", { fg = "#FF7B72" })
    set_hl(0, "Keyword", { fg = "#FF7B72" })
    set_hl(0, "PreProc", { fg = "#FF7B72" })
    set_hl(0, "Type", { fg = "#FFA657", bold = true })
    set_hl(0, "Special", { fg = "#79C0FF" })
    set_hl(0, "Directory", { fg = "#58A6FF", bold = true })
    set_hl(0, "SnacksExplorerDir", { fg = "#58A6FF", bold = true })
    set_hl(0, "SnacksPickerDirectory", { fg = "#58A6FF", bold = true })
    set_hl(0, "SnacksPickerDir", { fg = "#8B949E" })
    set_hl(0, "SnacksPickerPathHidden", { fg = "#8B949E" })
    set_hl(0, "SnacksPickerPathIgnored", { fg = "#8B949E" })
    set_hl(0, "SnacksPickerComment", { fg = "#8B949E" })
    set_hl(0, "SnacksPickerDimmed", { fg = "#8B949E" })
    set_hl(0, "SnacksPickerTree", { fg = "#6E7681" })
    set_hl(0, "SnacksDashboardDir", { fg = "#8B949E" })
    set_hl(0, "SnacksDashboardDesc", { fg = "#C9D1D9" })
    set_hl(0, "Visual", { fg = "#FFFFFF", bg = "#30363D", bold = true })
    set_hl(0, "CursorWord", { bg = "#30363D" })
    set_hl(0, "LspReferenceText", { fg = "#E6EDF3", bg = "#30363D", bold = true })
    set_hl(0, "LspReferenceRead", { fg = "#E6EDF3", bg = "#30363D", bold = true })
    set_hl(0, "LspReferenceWrite", { fg = "#E6EDF3", bg = "#30363D", bold = true })
    set_hl(0, "Search", { fg = "#0D1117", bg = "#D29922", bold = true })
    set_hl(0, "IncSearch", { fg = "#0D1117", bg = "#E8912D", bold = true })
    set_hl(0, "CurSearch", { fg = "#0D1117", bg = "#E8912D", bold = true })
    set_hl(0, "Added", { fg = "#3FB950", bg = "#1C3A24" })
    set_hl(0, "Changed", { fg = "#58A6FF", bg = "#172F4A" })
    set_hl(0, "Removed", { fg = "#F85149", bg = "#3D2024" })
    set_hl(0, "DiffAdd", { fg = "#3FB950", bg = "#1C3A24" })
    set_hl(0, "DiffChange", { fg = "#58A6FF", bg = "#172F4A" })
    set_hl(0, "DiffDelete", { fg = "#F85149", bg = "#3D2024" })
    set_hl(0, "DiffText", { fg = "#E6EDF3", bg = "#264F78", bold = true })
    set_hl(0, "DiagnosticVirtualTextError", { fg = "#F85149", bg = "#3D2024" })
    set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#D29922", bg = "#3D311D" })
    set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#58A6FF", bg = "#172F4A" })
    set_hl(0, "DiagnosticVirtualTextHint", { fg = "#3FB950", bg = "#1C3A24" })
    set_hl(0, "@comment", { fg = "#8B949E", italic = true })
    set_hl(0, "@string", { fg = "#A5D6FF" })
    set_hl(0, "@constant", { fg = "#79C0FF" })
    set_hl(0, "@number", { fg = "#79C0FF" })
    set_hl(0, "@boolean", { fg = "#79C0FF" })
    set_hl(0, "@function", { fg = "#D2A8FF", bold = true })
    set_hl(0, "@function.method", { fg = "#D2A8FF", bold = true })
    set_hl(0, "@keyword", { fg = "#FF7B72" })
    set_hl(0, "@keyword.function", { fg = "#FF7B72" })
  set_hl(0, "@type", { fg = "#FFA657", bold = true })
end

local function apply_theme()
  vim.o.background = "dark"
  -- Keep Airline on a dark, high-contrast theme while Rex highlights apply.
  vim.g.airline_theme = "base16_mocha"
  vim.cmd.colorscheme("sora")
  apply_surface_highlights()
  apply_programming_highlights()
  pcall(vim.cmd.AirlineRefresh)
end

vim.api.nvim_create_user_command("ThemeRefresh", function()
  apply_theme()
end, { desc = "Re-apply colorscheme (after system appearance change)" })

apply_theme()
