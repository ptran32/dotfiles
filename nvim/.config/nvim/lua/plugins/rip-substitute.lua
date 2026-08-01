-- nvim-rip-substitute: literal search/replace with live preview.
-- https://github.com/chrisgrieser/nvim-rip-substitute
require("rip-substitute").setup({
  regexOptions = {
    -- Plain text by default — no regex syntax to learn.
    startWithFixedStrings = true,
    pcre2 = false,
  },
  prefill = {
    normal = "cursorWord",
    visual = "selection",
    -- Word is already on the search line; jump straight to typing the replacement.
    startInReplaceLineIfPrefill = true,
  },
  popupWin = {
    position = "bottom",
    title = "Find → Replace",
    hideKeymapHints = true,
    hideSearchReplaceLabels = false,
  },
  keymaps = {
    -- Enter applies while typing (no Ctrl+Enter / <CR> jargon).
    confirmAndSubstituteInBuffer = "<CR>",
    insertModeConfirmAndSubstituteInBuffer = "<CR>",
    -- Project-wide replace stays on Shift+Enter (asks which files — easy to hit by mistake).
    confirmAndSubstituteInCwd = "<S-CR>",
    abort = "q",
  },
})

vim.keymap.set({ "n", "x" }, "<leader>sr", function()
  require("rip-substitute").sub()
end, { desc = "Find and replace (literal)" })
