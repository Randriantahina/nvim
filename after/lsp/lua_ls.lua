return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
      hint = { enable = true, setType = true, paramType = true, paramName = "Disable", arrayIndex = "Disable" },
    },
  },
}
