# Configuration Neovim (Neovim 0.12, sans framework)

Configuration autonome écrite pour **Neovim 0.12+**, sans LazyVim. Elle s'appuie sur les fonctions intégrées récentes : `vim.pack` (gestionnaire de plugins), `vim.lsp.config` / `vim.lsp.enable` (LSP), `ui2` (messages) et `:restart`. Inspirée de l'article *Effective Neovim setup for agentic coding towards 2027*, adaptée à Laravel, Vue, Next.js, Rust et Flutter, avec Claude Code intégré.

Le thème et la transparence suivent le thème Omarchy courant.

- **Touche `<leader>`** : `Espace`.
- Appuie sur `Espace` et attends un instant : **which-key** affiche les raccourcis disponibles en bas de l'écran.
- `Espace ?` affiche les raccourcis du buffer courant.

## Prérequis

| Outil | Pourquoi |
|---|---|
| Neovim 0.12 ou plus | `vim.pack`, `ui2`, `:restart` |
| `git`, `curl`, `tar` | installation des plugins et parsers |
| `tree-sitter` CLI + compilateur C | parsers Treesitter |
| Node.js + npm | serveurs installés par Mason, `prettierd` |
| `ripgrep`, `fd` | recherche de fichiers et de texte |
| `lazygit` | interface Git (`;g`) |
| `claude` (Claude Code CLI) | panneau Claude Code |
| `flutter` / `dart` | Flutter et Dart |
| `cargo`, `rustfmt`, `clippy` | Rust |
| `php`, `composer` | Laravel |
| Une Nerd Font | icônes |

## Installation

```bash
git clone git@github.com:Randriantahina/nvim.git ~/.config/nvim
nvim
```

Au premier lancement, `vim.pack` propose d'installer les plugins (confirme) et Mason installe les serveurs et formateurs. `nvim-pack-lock.json` est ignoré par git.

> `lua/plugins/theme.lua` est un lien symbolique vers `~/.local/state/omarchy/current/theme/neovim.lua`. Il n'existe que sur une machine Omarchy ; ailleurs, le thème n'est pas chargé et il faut le remplacer par ton propre colorscheme.

## Structure du dossier

```
~/.config/nvim
├── init.lua                      point d'entrée : active vim.loader, définit <leader>, charge les modules
├── stylua.toml                   style de formatage du Lua
├── lua/
│   ├── nvim/
│   │   ├── options.lua           options de base (numéros, indentation, recherche, undo, ui2…)
│   │   ├── keymaps.lua           raccourcis généraux + raccourcis LSP (posés à l'attache d'un serveur)
│   │   ├── autocmds.lua          autocommandes (surbrillance du yank, cursorline, TSUpdate)
│   │   ├── plugins.lua           liste des plugins (vim.pack.add) et leur configuration
│   │   ├── languages.lua         serveurs LSP, diagnostics, filetype Blade
│   │   └── tabline.lua           barre d'onglets personnalisée (sans plugin)
│   ├── config/
│   │   └── remote_clipboard.lua  presse-papiers Wayland / tmux / terminal distant
│   └── plugins/
│       ├── theme.lua             lien vers le thème Omarchy courant
│       └── lualine-transparent.lua  barre d'état transparente
├── after/lsp/                    réglages par serveur, fusionnés automatiquement par Neovim 0.12
│   ├── vtsls.lua                 TypeScript : TypeScript du workspace, hints courts
│   ├── lua_ls.lua                Lua : runtime Neovim
│   ├── cssls.lua                 CSS : ignore les règles vides
│   └── oxlint.lua                oxlint en mode `--lsp`
└── plugin/after/transparency.lua fond transparent appliqué après le colorscheme
```

Ordre de chargement (`init.lua`) : `options` → `keymaps` → `autocmds` → `plugins` → `tabline` → `languages`.

## Plugins

| Rôle | Plugin |
|---|---|
| Gestionnaire | `vim.pack` (intégré) |
| Raccourcis affichés | `which-key.nvim` |
| Explorateur latéral | `neo-tree.nvim` |
| Explorateur en flottant | `oil.nvim` |
| Recherche, lazygit, notifications, indentation, mots | `snacks.nvim` |
| Icônes | `mini.icons` (simule `nvim-web-devicons`) |
| Barre d'état / étiquettes de fenêtre | `lualine.nvim` / `incline.nvim` |
| Ligne de commande flottante | `tiny-cmdline.nvim` |
| Coloration | `nvim-treesitter`, `todo-comments.nvim`, `nvim-highlight-colors`, `vim-blade` |
| LSP et outils | `nvim-lspconfig`, `mason.nvim`, `mason-tool-installer.nvim` |
| Complétion | `blink.cmp` (Entrée accepte) |
| Formatage / lint | `conform.nvim` / `nvim-lint` |
| Parenthèses automatiques | `mini.pairs` |
| Git | `gitsigns.nvim`, `mini.diff`, `codediff.nvim`, `gitlinker.nvim` |
| IA | `claudecode.nvim` (Claude Code CLI) |
| Flutter / Dart | `flutter-tools.nvim` |

## Raccourcis

### Généraux
| Touches | Action |
|---|---|
| `jj` (insertion) | Retour au mode normal |
| `Ctrl-s` | Enregistrer (déclenche le formatage) |
| `Espace w` | Enregistrer |
| `Espace q` | Quitter Neovim |
| `Espace Q` | Quitter sans enregistrer |
| `ZR` | Redémarrer Neovim (`:restart`) |
| `x` | Supprimer un caractère sans copier |
| `Espace d` / `Espace c` / `Espace p` | Supprimer, changer, coller sans toucher au registre de copie |
| `dw` | Supprimer le mot précédent sans copier |
| `+` / `-` | Incrémenter / décrémenter un nombre |
| `Ctrl-a` | Tout sélectionner |
| `Espace o` / `Espace O` | Ouvrir une ligne dessous / dessus sans continuer un commentaire |
| `Ctrl-m` | Avancer dans la liste des sauts |
| `Espace b d` | Fermer les buffers cachés et enregistrés |

### Fenêtres et onglets
| Touches | Action |
|---|---|
| `ss` / `sv` | Split horizontal / vertical |
| `sh` `sj` `sk` `sl` | Aller à la fenêtre gauche / bas / haut / droite |
| `te` | Nouvel onglet |
| `Tab` / `Shift-Tab` | Onglet suivant / précédent |

### Explorateur
| Touches | Action |
|---|---|
| `Espace e` | Ouvrir / fermer la barre latérale (neo-tree) |
| `l` | Ouvrir un dossier ou un fichier |
| `h` | Fermer un dossier |
| `q` | Fermer la barre |
| `sf` | Explorateur flottant (oil) ; `h` dossier parent, `q` fermer |

### Recherche (snacks)
| Touches | Action |
|---|---|
| `;f` | Fichiers (cachés inclus) |
| `;r` | Recherche de texte |
| `;;` | Reprendre la dernière recherche |
| `\\` | Liste des buffers |
| `;e` | Diagnostics |
| `;n` | Historique des notifications |
| `;h` | Hunks Git |
| `;g` | Lazygit |

### LSP (actifs quand un serveur est attaché)
| Touches | Action |
|---|---|
| `gd` / `gD` | Définition / déclaration |
| `gy` | Définition du type |
| `gr` | Références |
| `gI` | Source (TypeScript) ou implémentation |
| `;c` | Appels entrants |
| `K` | Documentation au survol |
| `gK` / `Ctrl-k` (insertion) | Signature |
| `Ctrl-j` | Diagnostic suivant avec bulle |
| `Espace c a` | Actions de code |
| `Espace c r` | Renommer le symbole |
| `Espace c R` | Renommer le fichier (met à jour les imports) |
| `Espace c l` | Informations LSP |
| `Espace f` | Formater maintenant |

### Git
| Touches | Action |
|---|---|
| `Espace g b` / `Espace g B` | Blame de la ligne / du fichier |
| `Espace g s` | Indexer le fichier |
| `Espace g h` | Indexer le hunk |
| `Espace g d` | Overlay de diff (mini.diff) |
| `Espace g y` | Copier le lien GitHub |
| `Espace d v` | Vue diff (codediff) |
| `Espace d h` / `Espace d H` | Historique du fichier / du dépôt |

### Copier pour un agent
| Touches | Action |
|---|---|
| `Espace y f` | Copier le chemin relatif avec `#L<ligne>` |
| `Espace y p` | Copier le chemin absolu avec `#L<ligne>` |
| `Espace c c` (visuel) | Copier la sélection en bloc Markdown avec fichier et lignes |
| `Espace j` | Afficher `package.json` dans un flottant (`q` ou `Esc` ferme) |

### Claude Code
| Touches | Action |
|---|---|
| `Espace a c` | Ouvrir / fermer le panneau Claude Code |
| `Espace a f` | Aller dans le panneau |
| `Espace a r` | Reprendre une session |
| `Espace a C` | Continuer la dernière session |
| `Espace a b` | Ajouter le fichier courant au contexte |
| `Espace a s` (visuel) | Envoyer la sélection |
| `Espace a a` / `Espace a d` | Accepter / refuser un diff |

Depuis le terminal Claude (Espace y écrit une espace, `<leader>` n'y fonctionne pas) :

| Touches | Action |
|---|---|
| `Alt-h` | Revenir à la fenêtre de gauche (le code) |
| `Ctrl-Espace` | Fermer le panneau |
| `Ctrl-q` ou `Ctrl-\` `Ctrl-n` | Mode normal dans le terminal |

### Flutter / Dart
| Touches | Action |
|---|---|
| `Espace F r` | Lancer l'application |
| `Espace F d` / `Espace F e` | Choisir l'appareil / l'émulateur |
| `Espace F h` | Hot reload |
| `Espace F R` | Hot restart |
| `Espace F q` | Arrêter l'application |
| `Espace F o` | Plan des widgets |
| `Espace F l` | Logs |
| `Espace F t` | DevTools |
| `Espace F p` | `pub get` |

## Langages : serveurs, formatage, lint

| Langage | Serveur LSP | Formatage à l'enregistrement | Lint |
|---|---|---|---|
| JS / TS / TSX / JSX | `vtsls`, `eslint`, `oxlint` | `oxfmt` (si config oxfmt dans le projet), sinon `prettierd` puis `prettier` | ESLint, oxlint |
| Vue | `vue_ls` + `vtsls` | idem JS | ESLint |
| CSS / SCSS / HTML / JSON / Markdown / YAML | `cssls`, `tailwindcss` (CSS) | idem JS | — |
| PHP / Laravel | `phpactor` | `pint` (si `vendor/bin/pint`), sinon `php_cs_fixer` | `php`, `phpcs` |
| Blade | coloration `vim-blade` | `blade-formatter` | — |
| Rust | `rust_analyzer` (clippy) | `rustfmt` | clippy (à l'enregistrement) |
| Dart / Flutter | `dartls` (via flutter-tools) | `dart_format` | dartls |
| Lua | `lua_ls` | `stylua` | — |
| Shell / Fish | — | `shfmt` / `fish_indent` | — |

- Le formatage se fait à l'enregistrement (timeout 1000 ms, repli sur le LSP). `:ToggleFormatter` l'active ou le coupe globalement.
- `Espace f` formate à la demande. `:ConformInfo` montre les formateurs utilisés pour le fichier courant.
- Pint n'est jamais installé globalement : il faut `vendor/bin/pint` dans le projet.
- Le lint Rust (clippy) s'exécute à l'enregistrement, dans un projet avec `Cargo.toml`.

## Commandes utiles

| Commande | Rôle |
|---|---|
| `:ConformInfo` | Voir les formateurs actifs |
| `:LspInfo` | Voir les serveurs attachés |
| `:Mason` | Gérer les serveurs et outils |
| `:checkhealth vim.lsp` | Diagnostiquer le LSP |
| `:ToggleFormatter` | Activer / couper le formatage à l'enregistrement |
| `:GitLink` | Copier le lien GitHub de la ligne |
| `:ClaudeCode` | Ouvrir / fermer Claude Code |
| `:Neotree toggle` | Ouvrir / fermer l'explorateur |

## Historique

Cette configuration remplace une ancienne installation LazyVim (Avante a été remplacé par `claudecode.nvim`, qui lance directement le CLI Claude Code).
