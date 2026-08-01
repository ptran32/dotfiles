-- General options (mirrors home/vimrc + former nvchad-extra.lua)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use Python's native indent knob for continuation inside (), [], and {}.
-- The default is two shiftwidths, which is too deep for `return {}` / `return []`.
vim.g.pyindent_open_paren = "shiftwidth()"

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.termguicolors = true

-- Relative line numbers (absolute line number on cursor line instead of 0)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.foldmethod = "indent"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.confirm = true
vim.o.ttimeoutlen = 1
vim.opt.timeoutlen = 300
vim.opt.guicursor = {
  "n-v-c-sm:block",
  "i-ci-ve:ver25",
  "r-cr-o:hor20",
  "a:blinkwait700-blinkon250-blinkoff250",
}

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown-literal-punctuation", { clear = true }),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
})

local function snacks_explorer_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype")
    if ft:match("^snacks") then
      return true
    end
  end
  return false
end

local function save_buffer()
  vim.cmd.write()
end

-- Avoid accidental macro @w (collides with <leader>w save). Other registers stay usable;
-- Neogit can bind buffer-local `q` = Close again.
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = vim.api.nvim_create_augroup("cancel-macro-w", { clear = true }),
  callback = function()
    if vim.fn.reg_recording() == "w" then
      vim.schedule(function()
        vim.api.nvim_feedkeys("q", "n", false)
        vim.notify("Stopped macro recording @w", vim.log.levels.WARN)
      end)
    end
  end,
})

vim.keymap.set("n", "<leader>w", save_buffer, { desc = "Save", silent = true })
-- No <leader> maps in insert mode: leader is Space, so each Space would wait
-- timeoutlen (300ms) for a possible <leader>w / <leader><space> chord.
vim.keymap.set({ "n", "i" }, "<C-s>", save_buffer, { desc = "Save", silent = true })

vim.keymap.set("n", "<leader>q", function()
  local ft = vim.bo.filetype
  if snacks_explorer_open() and not ft:match("^snacks") then
    vim.cmd("q")
  else
    vim.cmd("qa")
  end
end, { desc = "Quit window or all" })
vim.keymap.set("n", "<leader>Q", function()
  vim.cmd("qa!")
end, { desc = "Force quit all" })

vim.keymap.set("n", "<leader>x", function()
  vim.cmd("x")
end, { desc = "Save and quit" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
-- Terminal mode: same habit as insert. Snacks float needs double-Esc otherwise.
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Shift+arrows: word/block motion (like many GUI editors)
vim.keymap.set({ "n", "v" }, "<S-Left>", "b", { desc = "Prev word" })
vim.keymap.set({ "n", "v" }, "<S-Right>", "w", { desc = "Next word" })
vim.keymap.set({ "n", "v" }, "<S-Up>", "{", { desc = "Prev block" })
vim.keymap.set({ "n", "v" }, "<S-Down>", "}", { desc = "Next block" })
vim.keymap.set("i", "<S-Left>", "<C-o>b", { desc = "Prev word" })
vim.keymap.set("i", "<S-Right>", "<C-o>w", { desc = "Next word" })
vim.keymap.set("i", "<S-Up>", "<C-o>{", { desc = "Prev block" })
vim.keymap.set("i", "<S-Down>", "<C-o>}", { desc = "Next block" })
