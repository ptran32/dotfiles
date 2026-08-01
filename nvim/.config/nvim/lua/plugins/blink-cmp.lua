-- blink.cmp: completion (LSP, path, snippets, buffer). https://github.com/Saghen/blink.cmp
require("blink.cmp").setup({
  -- Enter accepts; Tab/S-Tab cycle the menu (see cmp.saghen.dev/configuration/keymap#enter)
  keymap = {
    preset = "enter",
    ["<Esc>"] = { "hide", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = { auto_show = false },
    -- Match VS Code: first item pre-selected; Enter accepts (see keymap preset "enter").
    list = {
      cycle = { from_top = true, from_bottom = true },
      selection = { preselect = true, auto_insert = false },
    },
    -- Completion menu hidden in snippets; Tab still jumps snippet placeholders.
    trigger = { show_in_snippet = false },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  -- Nixpkgs ships the prebuilt Rust fuzzy matcher.
  fuzzy = { implementation = "prefer_rust" },
})
