-- the lazyvim.plugins.extras.lang.rust import lives in config/lazy.lua (extras must be
-- imported before "plugins" per LazyVim's import order); this file only overrides its opts.
return {
  -- use clippy instead of plain `cargo check` for richer lint diagnostics on save
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      },
    },
  },

  -- format Rust files with rustfmt on save (via conform.nvim, already wired by LazyVim)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },
}
