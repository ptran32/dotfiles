vim.diagnostic.config({
  virtual_text = true,
})

vim.lsp.on_type_formatting.enable()

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP Code Action" }))
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP Rename" }))
    vim.keymap.set("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format" }))
  end,
})

vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      format = {
        enable = true,
      },
    },
    ["[yaml]"] = {
      editor = {
        tabSize = 2,
        formatOnType = true,
      },
    },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      format = {
        enable = true,
      },
    },
  },
})

vim.lsp.config("helm_ls", {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
        config = {
          ["[yaml]"] = {
            editor = {
              tabSize = 2,
              formatOnType = true,
            },
          },
        },
      },
    },
  },
})

for _, server in ipairs({ "bashls", "dockerls", "helm_ls", "jsonls", "lua_ls", "pyright", "terraformls", "yamlls" }) do
  vim.lsp.enable(server)
end
