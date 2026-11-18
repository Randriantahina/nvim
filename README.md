# Configuration Neovim

Configuration autonome pour Neovim 0.12, basée sur l’article « Effective Neovim setup for agentic coding towards 2027 ». Elle utilise `vim.pack`, le LSP intégré, `ui2`, et conserve le thème et la transparence du thème Omarchy courant.

- `jj` revient au mode normal ; `<leader>q` quitte Neovim et `<leader>Q` quitte sans enregistrer.
- PHP/Laravel utilisent PHPactor, PHPCS et Pint local (`vendor/bin/pint`). Pint n’est jamais installé globalement.
- Blade a sa coloration dédiée ; Vue et TypeScript utilisent `vue_ls`, vtsls, ESLint/Oxlint et Prettier/Oxfmt.
- Rust utilise rust-analyzer, Clippy et rustfmt.
- Avante utilise Claude Code par ACP. Les appels aux outils demandent confirmation ; connecte d’abord Claude Code comme d’habitude.

Les serveurs et outils gérés par Mason s’installent au premier démarrage. Les plugins sont déclarés dans `lua/nvim/plugins.lua` et leur verrouillage est conservé dans `nvim-pack-lock.json`. Avante peut nécessiter `:AvanteBuild` à sa première utilisation.
