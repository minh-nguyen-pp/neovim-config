# Neovim Configuration

A personal, Lua-based Neovim setup for macOS and iTerm2, optimized for Java/Kotlin projects, Git worktrees, and a dedicated OpenCode TUI inside each Neovim instance.

This config keeps my original Vim habits: **`,` as leader**, **2-space indentation**, **Space for `/` search**, familiar window/buffer keys, and the macOS clipboard.

> **Status (October 2026):** Core editor, Git, themes, and per-Neovim OpenCode integration are part of this setup. Java/Kotlin LSP navigation is documented below; make sure `lua/plugins/lsp.lua` is committed if you have already added it. **`blink.cmp` autocomplete is deliberately postponed** and is not required by this README.

## Features

| Area | Tools |
| --- | --- |
| Plugin management | [lazy.nvim](https://github.com/folke/lazy.nvim) |
| Explorer / file search / live grep | [snacks.nvim](https://github.com/folke/snacks.nvim), `ripgrep`, `fd` |
| Syntax highlighting | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) |
| Git signs / history / full diffs | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim), [diffview.nvim](https://github.com/sindrets/diffview.nvim) |
| File tabs / statusline | [bufferline.nvim](https://github.com/akinsho/bufferline.nvim), [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) |
| Colorschemes | [Catppuccin](https://github.com/catppuccin/nvim) Mocha and [TokyoNight](https://github.com/folke/tokyonight.nvim) |
| Keybinding help | [which-key.nvim](https://github.com/folke/which-key.nvim) |
| Java/Kotlin navigation | Neovim native LSP + [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig); [Mason](https://github.com/mason-org/mason.nvim) for JDTLS installation |
| AI assistant | [opencode.nvim](https://github.com/nickjvandyke/opencode.nvim), pinned to **v1.0.1** for OpenCode CLI v1 |

## 1. Install system prerequisites (macOS)

Install [Homebrew](https://brew.sh/) first, if it is not already available.

```sh
# If Xcode Command Line Tools are missing:
xcode-select --install

brew update
brew install neovim git curl ripgrep fd tree-sitter-cli
brew install --cask font-fira-code-nerd-font
```

Verify:

```sh
nvim --version                 # Neovim 0.12+
rg --version
fd --version
tree-sitter --version
```

**iTerm2 font:** Go to **Settings → Profiles → Text → Font**, choose **FiraCode Nerd Font Mono**, then open a new iTerm2 window. Regular Fira Code does not include the Nerd Font icons used in the explorer and file tabs.

This Tree-sitter setup expects **Neovim 0.12+**, a compiler, and `tree-sitter-cli` **0.26.1+**. See [nvim-treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements).

## 2. Clone the configuration

Back up an existing Neovim config before cloning:

```sh
if [ -e "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)"
fi
mkdir -p "$HOME/.config"
```

Clone **this repository** (replace `YOUR_USERNAME/nvim-config` with the actual repository path):

```sh
git clone https://github.com/YOUR_USERNAME/nvim-config.git "$HOME/.config/nvim"
```

SSH alternative:

```sh
git clone git@github.com:YOUR_USERNAME/nvim-config.git "$HOME/.config/nvim"
```

Keep **`init.lua`**, but don't keep an old **`init.vim`** in that same directory; the two together cause Neovim's `E5422` startup error.

## 3. Install plugins

Start Neovim:

```sh
nvim
```

The `lua/config/lazy.lua` bootstrap installs lazy.nvim and discovers plugin specifications in `lua/plugins/`.

Inside Neovim:

```vim
:Lazy sync
```

If the repository contains `lazy-lock.json`, use the pinned versions for reproducibility:

```vim
:Lazy restore
```

After installation, restart Neovim and verify:

```vim
:Lazy
:checkhealth
:TSUpdate
:checkhealth nvim-treesitter
```

> Plugins and parsers are downloaded to local Neovim data directories. Don't commit `~/.local/share/nvim/`, caches, or local state; commit `lazy-lock.json` instead.

## 4. Install OpenCode v1 (for AI integration)

This config is written for **OpenCode CLI v1** and pins `nickjvandyke/opencode.nvim` to **`1.0.1`**. The plugin's **main** branch targets OpenCode v2; don't unpin the plugin or upgrade the CLI independently without updating this integration.

If OpenCode v1 already works on your machine, just verify it:

```sh
opencode --version
command -v opencode
```

For a new installation of the same CLI version used with this setup, npm is an option (Node.js required):

```sh
brew install node
npm install -g opencode-ai@1.18.35
opencode --version
```

Configure the AI provider/authentication through OpenCode itself. **Never commit API tokens or credentials.**

### One OpenCode TUI per Neovim / worktree

Open each worktree in a **separate Neovim process**, launched from the worktree's root:

```sh
cd /path/to/worktree-a
nvim .
```

In another iTerm2 tab/window:

```sh
cd /path/to/worktree-b
nvim .
```

Within each Neovim:

- `,ot` opens/focuses the embedded OpenCode terminal on the right; subsequent uses reuse the same managed terminal.
- The config assigns **a distinct, dynamically chosen localhost port per Neovim process**, rather than sharing `127.0.0.1:4096`.
- `,oy` in Visual mode appends **only the selected file/line context** to OpenCode's prompt; it does **not** submit an instruction. Type your own prompt in the TUI.
- `,oe` explains the current code or selection immediately using the built-in *Explain @this and its context* prompt.
- `,oa` opens a custom prompt; `,os` opens the OpenCode actions picker.

**Save your file first**: `@this` normally uses a file-and-line reference, and OpenCode reads the referenced source from disk.

Closing the Neovim process normally also terminates its managed terminal job. If Neovim is killed unexpectedly, verify that no orphaned OpenCode processes remain.

## 5. Java and Kotlin LSP navigation

> This section applies when `lua/plugins/lsp.lua` from the LSP setup is present. The language-server binaries are **external dependencies**; cloning the repository alone does not install them. No completion plugin is needed to use `gd`, references, or hover.

### 5.1 Java: JDK 21 and Eclipse JDTLS

```sh
brew install openjdk@21

# Make Homebrew's JDK visible to macOS's Java launcher:
sudo ln -sfn \
  "$(brew --prefix openjdk@21)/libexec/openjdk.jdk" \
  /Library/Java/JavaVirtualMachines/openjdk-21.jdk
```

If Java 21 isn't already active, add the following to your `~/.zshrc` and reload your shell:

```sh
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
```

Verify:

```sh
java -version
```

JDTLS needs **Java 21 or newer to run**, while your Gradle/Maven project can target a different JDK. If you use several JDKs, configure project toolchains separately.

Inside Neovim, install the JDTLS binary with Mason:

```vim
:MasonInstall jdtls
:echo executable("jdtls")
```

The `executable()` result should be `1`. Your `lsp.lua` needs to enable `jdtls` with `vim.lsp.enable("jdtls")`. Basic code navigation works through native LSP; advanced Java refactoring/debugging can be added later with `nvim-jdtls`.

### 5.2 Kotlin: official JetBrains Kotlin LSP

Check whether it's already installed:

```sh
command -v kotlin-lsp
kotlin-lsp --version
```

If missing, the official Homebrew installation is:

```sh
brew install JetBrains/utils/kotlin-lsp
```

**Known Homebrew issue (checked October 2026):** Some versions of the JetBrains tap use `download-cdn.jetbrains.com` directly, producing a **404**. [Issue](https://github.com/Kotlin/kotlin-lsp/issues/282) · [formula fix PR](https://github.com/JetBrains/homebrew-utils/pull/20). If you still encounter that exact error, apply the temporary local formula workaround:

```sh
brew tap JetBrains/utils

FORMULA="$(brew --repo JetBrains/utils)/Formula/kotlin-lsp.rb"
sed -i '' \
  's#download-cdn.jetbrains.com#download.jetbrains.com#g' \
  "$FORMULA"

HOMEBREW_NO_AUTO_UPDATE=1 brew install JetBrains/utils/kotlin-lsp
```

Homebrew still verifies the formula's SHA-256 checksum. A future upstream update can replace this local edit.

The current `nvim-lspconfig` `kotlin_lsp` preset looks for `intellij-server`, while the Homebrew formula creates the command **`kotlin-lsp`**. The Neovim configuration should therefore explicitly set:

```lua
vim.lsp.config("kotlin_lsp", {
  cmd = { "kotlin-lsp", "--stdio" },
})
vim.lsp.enable("kotlin_lsp")
```

This belongs in `lua/plugins/lsp.lua` alongside `vim.lsp.enable("jdtls")`, **not** in your OpenCode or completion settings.

### 5.3 Verify code navigation

Start Neovim **at the Gradle/Maven project root**:

```sh
cd /path/to/java-or-kotlin-worktree
nvim .
```

Open an actual `.java` or `.kt` source file, then run:

```vim
:checkhealth vim.lsp
:lua vim.print(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 })))
```

Expected active client: `jdtls` for Java, `kotlin_lsp` for Kotlin. Allow initial project import/indexing to finish.

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `Ctrl+o` | Jump **back** in Neovim's jumplist |
| `Ctrl+i` | Jump **forward** in the jumplist |
| `gr` | Search references (Snacks picker) |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `,rn` | Rename symbol |
| `,ca` | Code actions |
| `,Si` / `,Sw` | Document / workspace symbols |
| `[d` / `]d` | Previous / next diagnostic |

**Worktree note:** The stock `nvim-lspconfig` JDTLS cache uses the project directory's basename. If multiple worktrees share that basename, consider a custom JDTLS workspace keyed by the **absolute project path** to avoid indexing collisions.

## 6. Everyday keybindings

`<leader>` is **`,` (comma)**, not Space.

| Key | Action |
| --- | --- |
| `,w` | Save file |
| `Space` | Start `/` search |
| `Ctrl+h/j/k/l` | Move left/down/up/right between windows |
| `,l` / `,h` | Next / previous buffer |
| `,fb` | Select open buffer |
| `,bd` | Close current buffer |
| `,e` | Open/toggle Snacks Explorer |
| `,f` | Find files |
| `,g` | Live grep across the project |
| `,Gd` / `,GD` | Open / close Diffview |
| `,Gp` / `,Gs` / `,Gr` | Preview / stage / reset Git hunk |
| `,Gb` / `,Gh` | Git blame / file history |
| `]c` / `[c` | Next / previous changed Git hunk |
| `,ut` | Theme picker |
| `,ot` | Open/focus managed OpenCode terminal |
| `,oy` (Visual) | Append selected-code context, **without submitting** |
| `,oe` (Normal/Visual) | Explain selected/current code |
| `,oa` (Normal/Visual) | Ask OpenCode a custom question |
| `,os` (Normal/Visual) | OpenCode action picker |
| `,tn` / `,tc` / `,to` | New / close / keep only tab |
| `,ss` | Toggle spell checking |
| `,q` / `,x` | Open personal scratch / Markdown scratch file |

The definitive source for keybindings is `lua/config/keymaps.lua` and the plugin-specific `keys` tables. Inspect a mapping with `:verbose nmap ,ot`, or use `:verbose xmap ,oy` for a Visual-mode mapping.

### Splits and buffers

```vim
:vsplit path/to/file.kt     " vertical split
:split path/to/file.kt      " horizontal split
:buffers                    " list open buffers
```

- Use `Ctrl+h/j/k/l` to switch between splits.
- Use `,l` / `,h` to switch files in the **focused** split.
- Bufferline shows a **global list of open buffers**, not separate tabs per split.
- A Neovim **tab page** contains its own window layout and is different from a buffer.
- To exit terminal input mode before using Normal-mode mappings: `Ctrl+\`, then `Ctrl+n`.

### Themes

```vim
:colorscheme                    " print active theme
:colorscheme catppuccin-mocha
:colorscheme tokyonight-moon
```

Use `,ut` for the custom theme selector. If theme persistence is enabled, the choice is saved in Neovim's local state directory, not Git.

## 7. Autocomplete: not installed yet

**`blink.cmp` is intentionally deferred.** Basic LSP navigation works without it, but automatic code suggestions won't have the full IDE-style completion menu until it is installed.

When ready, follow the [Blink v1 docs](https://cmp.saghen.dev/), add `lua/plugins/completion.lua` using `version = "1.*"`, and pass `require("blink.cmp").get_lsp_capabilities()` to the Java/Kotlin LSP configurations. Keep Blink v1 pinned for now: its current main branch targets a newer development series.

Do **not** list `blink.cmp` as already installed or add it to `lazy-lock.json` before actually installing it.

## 8. Configuration structure

```text
~/.config/nvim/
├── init.lua
├── lazy-lock.json           # commit this
├── README.md
└── lua/
    ├── config/
    │   ├── lazy.lua         # bootstrap + plugins
    │   ├── options.lua      # editor preferences
    │   ├── keymaps.lua      # personal shortcuts + LSP navigation
    │   └── autocmds.lua
    └── plugins/
        ├── editor.lua       # Snacks, which-key
        ├── treesitter.lua
        ├── git.lua
        ├── theme.lua
        ├── bufferline.lua
        ├── lualine.lua
        ├── opencode.lua     # per-process port + TUI
        └── lsp.lua          # Java/Kotlin (if committed)
```

Do not commit plugin binaries, Java language-server caches, Tree-sitter downloaded parsers, Neovim local state, API tokens, or backup files. For OpenCode sessions, authentication and user state remain machine-local.

## 9. Troubleshooting

| Symptom | Fix |
| --- | --- |
| `E5422` startup conflict | Remove/move `init.vim` when using `init.lua`. |
| `E185` colorscheme not found | Install theme via `:Lazy sync`, confirm `theme.lua`, restart. |
| `E492: Not an editor command: DiffviewOpen` | Ensure Diffview's lazy spec declares `cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", ... }`, or use `,Gd`. |
| `,g` opens Git instead of grep | Reserve lowercase `,g` for Snacks grep, uppercase `,G...` for Git mappings. |
| Missing/`?` file icons | Choose **FiraCode Nerd Font** in iTerm2. |
| Search finds no results | Verify `rg --version`; open Neovim at the project root. |
| Kotlin/Java highlighting missing | `:TSUpdate`, `:checkhealth nvim-treesitter`, `:set filetype?`. |
| `gd` doesn't jump | Check active LSP clients with `:checkhealth vim.lsp`; allow project import to finish. |
| JDTLS won't attach | Confirm `java -version` is 21+, `:echo executable("jdtls")` returns `1`. |
| Kotlin LSP won't attach | Confirm `kotlin-lsp --version`, Neovim executable path, and root markers (`settings.gradle.kts` etc.). |
| `,ot` missing | `:verbose nmap ,ot`, then `:messages` to inspect errors. |
| `,oy` missing in Normal mode | Expected: mapping is **Visual-mode-only**; use `:verbose xmap ,oy`. |
| OpenCode cannot connect | Match OpenCode CLI v1 to plugin v1.0.1; run `:checkhealth opencode`, `:messages`. |
| Multiple OpenCode terminals | Check `lua/plugins/opencode.lua` uses one Snacks terminal command and a per-Neovim port; do not use old hardcoded `4096` config. |

## 10. Maintenance

Inside Neovim:

```vim
:Lazy check          " inspect plugin updates
:Lazy update         " update plugins and lockfile
:Lazy restore        " restore versions from lazy-lock.json
:checkhealth         " overall health
:checkhealth vim.lsp " LSP diagnostics
```

After reviewing changes:

```sh
cd ~/.config/nvim
git add README.md lua/ lazy-lock.json
git status
git commit -m "docs: update Neovim setup and LSP guide"
git push
```

## References

- [Neovim LSP config](https://github.com/neovim/nvim-lspconfig) · [Neovim jumplist](https://neovim.io/doc/user/motion.html#jumplist)
- [Mason installation and commands](https://github.com/mason-org/mason.nvim)
- [Official Kotlin LSP](https://github.com/Kotlin/kotlin-lsp)
- [JDTLS config](https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jdtls.lua)
- [lazy.nvim](https://github.com/folke/lazy.nvim) · [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [OpenCode Neovim integration](https://github.com/nickjvandyke/opencode.nvim)
- [Blink completion (future)](https://github.com/saghen/blink.cmp)

