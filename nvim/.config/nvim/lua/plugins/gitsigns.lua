require("gitsigns").setup({
  attach_to_untracked = true,
  signs = {
    add = { text = "▌" },
    change = { text = "▌" },
    delete = { text = "▌" },
    topdelete = { text = "▌" },
    changedelete = { text = "▌" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "▌" },
    change = { text = "▌" },
    delete = { text = "▌" },
    topdelete = { text = "▌" },
    changedelete = { text = "▌" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, "Next git hunk")
    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, "Prev git hunk")
    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>hb", gs.blame_line, "Blame line")
  end,
})

-- Classic git gutter tones (re-apply after colorscheme).
local function gitsigns_colors()
  local set_hl = vim.api.nvim_set_hl
  set_hl(0, "GitSignsAdd", { fg = "#1f5c3a", bg = "NONE" }) -- dark green
  set_hl(0, "GitSignsChange", { fg = "#d4a017", bg = "NONE" }) -- yellow / amber
  set_hl(0, "GitSignsDelete", { fg = "#c45c66", bg = "NONE" }) -- soft red
  set_hl(0, "GitSignsTopdelete", { fg = "#c45c66", bg = "NONE" })
  set_hl(0, "GitSignsChangedelete", { fg = "#d4a017", bg = "NONE" })
  set_hl(0, "GitSignsUntracked", { fg = "#1f5c3a", bg = "NONE" })
end

gitsigns_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("gitsigns-colors", { clear = true }),
  callback = function()
    -- Catppuccin links GitSigns* during ColorScheme; re-apply after it finishes.
    vim.schedule(gitsigns_colors)
  end,
})
-- Also re-apply once after startup plugins finish theme links.
vim.schedule(gitsigns_colors)
