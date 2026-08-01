-- grug-far.nvim: project-wide search and replace powered by ripgrep.
-- https://github.com/MagicDuck/grug-far.nvim
require("grug-far").setup({
  engines = {
    ripgrep = {
      placeholders = {
        flags = "e.g. --help --ignore-case (-i) --word-regexp (-w) --replace= (empty replace) --multiline (-U)",
      },
    },
  },
})

local function is_visual_mode()
  local mode = vim.fn.mode()
  return mode == "v" or mode == "V" or mode == "\22"
end

local function open_grug_far(paths)
  local grug_far = require("grug-far")
  local prefills = { paths = paths }

  if is_visual_mode() then
    grug_far.with_visual_selection({ prefills = prefills })
    return
  end

  prefills.search = vim.fn.expand("<cword>")
  local instance = grug_far.open({ prefills = prefills })
  instance:when_ready(function()
    instance:goto_input("replacement")
  end)
end

-- Search and replace only in the current file.
vim.keymap.set({ "n", "x" }, "<leader>sr", function()
  open_grug_far(vim.fn.expand("%"))
end, { desc = "Find and replace in file" })

-- Search and replace across the current working directory.
vim.keymap.set({ "n", "x" }, "<leader>sR", function()
  open_grug_far(vim.fn.getcwd())
end, { desc = "Find and replace in directory" })
