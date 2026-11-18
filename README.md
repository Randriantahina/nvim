# Neovim configuration

Configuration Neovim autonome, sans distribution. Elle utilise `vim.pack` et les fonctions LSP intégrées de Neovim 0.12.

- `jj` quitte le mode insertion.
- `<leader>q` quitte Neovim et `<leader>Q` quitte sans enregistrer.
- Les couleurs viennent du thème Omarchy courant (`lua/plugins/theme.lua`) et conservent la transparence Omarchy.
- PHP et Laravel utilisent le LSP PHPactor, PHPCS et Pint du projet (`vendor/bin/pint`) pour le formatage. Pint n'est jamais installé globalement.
- Vue et TypeScript utilisent Vue Language Server, vtsls, ESLint et Prettier/Oxfmt selon les outils du projet.
- Rust utilise rust-analyzer, Clippy et rustfmt.

Les serveurs et outils gérés par Mason s'installent au premier lancement. Les plugins sont déclarés dans `lua/nvim/plugins.lua` et le verrouillage de `vim.pack` est conservé dans `nvim-pack-lock.json`.
