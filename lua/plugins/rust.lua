return {
  -- LazyVim's official Rust extra: rustaceanvim (LSP via rust-analyzer, found on $PATH),
  -- crates.nvim, treesitter, codelldb for debugging
  { import = "lazyvim.plugins.extras.lang.rust" },

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
