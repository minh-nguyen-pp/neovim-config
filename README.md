# My Neovim Configuration

A lightweight, Lua-based Neovim setup for editing code on macOS. It keeps my Vim habits (`,` as the leader key, two-space indentation, and familiar navigation) while adding a file explorer, fuzzy search, Git tools, syntax highlighting, themes, and OpenCode integration.

> **Scope:** This repository intentionally does **not** configure Java/Kotlin language servers, completion, debugging, or formatters yet.

## Features

- **Plugin manager:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Explorer and search:** [snacks.nvim](https://github.com/folke/snacks.nvim) + [`ripgrep`](https://github.com/BurntSushi/ripgrep) + [`fd`](https://github.com/sharkdp/fd)
- **Syntax highlighting:** [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- **Git:** [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) + [diffview.nvim](https://github.com/sindrets/diffview.nvim)
- **Tabs/statusline:** [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) + [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **Themes:** [TokyoNight](https://github.com/folke/tokyonight.nvim) and [Catppuccin](https://github.com/catppuccin/nvim)
- **Shortcuts:** [which-key.nvim](https://github.com/folke/which-key.nvim)
- **AI:** [opencode.nvim](https://github.com/nickjvandyke/opencode.nvim) with an embedded, reusable OpenCode TUI per Neovim instance

## Requirements

- macOS and a terminal such as **iTerm2**
- **Neovim 0.12+** (required by the Tree-sitter configuration used here)
- Git, curl, a C compiler, `ripgrep`, `fd`, and `tree-sitter-cli` (0.26.1+)
- A Nerd Font for icons (this setup uses **FiraCode Nerd Font**)
- **OpenCode v1** for the current pinned `opencode.nvim` **v1.0.1** integration; see the OpenCode section below

### 1. Install Homebrew (if needed)

Follow the official instructions: <https://brew.sh/>.

Verify:

```sh
brew --version
```

### 2. Install prerequisites

```sh
# macOS Command Line Tools (compiler); skip if already installed
xcode-select --install

brew update
brew install neovim git ripgrep fd tree-sitter-cli
brew install --cask font-fira-code-nerd-font
```

Verify:

```sh
nvim --version
rg --version
fd --version
tree-sitter --version
git --version
```

**iTerm2 font:** Open **iTerm2 → Settings → Profiles → Text**, choose **FiraCode Nerd Font Mono**, and restart iTerm2 if necessary. The normal Fira Code font does not contain all Nerd Font icons.

### 3. Clone this configuration

Back up your current Neovim configuration **only if it already exists**:

```sh
if [ -e "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)"
fi

mkdir -p "$HOME/.config"
```

Clone your repository (replace the placeholder with your actual URL):

```sh
git clone git@github.com:YOUR_USERNAME/nvim-config.git "$HOME/.config/nvim"
```

HTTPS alternative:

```sh
git clone https://github.com/YOUR_USERNAME/nvim-config.git "$HOME/.config/nvim"
```

> If you still have an old `~/.config/nvim/init.vim`, move it out of the config directory. Neovim cannot start when both `init.lua` and `init.vim` exist in the same config directory (`E5422`).

### 4. Install Neovim plugins

```sh
nvim
```

The bootstrap code in `lua/config/lazy.lua` installs **lazy.nvim**, then lazy.nvim installs the plugins defined in `lua/plugins/` on first launch.

Inside Neovim:

```vim
:Lazy
```

If `lazy-lock.json` is committed, restore the pinned plugin versions:

```vim
:Lazy restore
```

Otherwise, or to install/update/remove plugins according to the current configuration:

```vim
:Lazy sync
```

Restart Neovim when installation finishes.

### 5. Install or update syntax parsers

The configuration manages the listed Tree-sitter parsers. If highlighting is missing or parsers need updating, run:

```vim
:TSUpdate
:checkhealth nvim-treesitter
```

For example, open a `.kt` file and check `:set filetype?`; it should show `filetype=kotlin`. Use `:Inspect` with the cursor on a keyword to inspect the active syntax captures.

### 6. Install OpenCode v1 (optional)

This configuration currently pins `nickjvandyke/opencode.nvim` to **v1.0.1**, for compatibility with the **OpenCode v1** CLI used in this setup. **Do not assume the latest OpenCode CLI (v2+) will work with this pinned plugin.**

If OpenCode v1 is already installed, keep that installation and simply check:

```sh
opencode --version
which -a opencode
```

For a reproducible OpenCode v1 installation using npm (requires Node.js/npm), one option is:

```sh
brew install node
npm install -g opencode-ai@1.18.35
opencode --version
```

Avoid installing multiple copies that shadow each other on your `PATH`. Configure your OpenCode provider/credentials through OpenCode's own setup—**do not commit API keys** to this repository.

**One TUI per Neovim / worktree:**

```sh
cd /path/to/your/git-worktree
nvim .
```

Inside Neovim, `,ot` opens an OpenCode TUI in a right-hand terminal split. The configuration allocates an available local port for **this Neovim process**; subsequent commands reuse the same instance. Start another Neovim process from a different worktree for another independent OpenCode TUI. No fixed global port `4096` is needed.

To send a visual selection, select code with `V` / `j` and use `,oy` to append its file/line context to OpenCode **without submitting a prompt**, then write your own instruction in the TUI. Use `,oe` to submit the predefined *Explain @this and its context* prompt.

> The `@this` context generally refers to file paths and selected line ranges rather than copying the source literally; **save your edits first** so OpenCode sees current file contents.

## Keybindings

The leader key is a **comma**: `<leader> = ,`.

| Keys | Action |
| --- | --- |
| `,w` | Save the current file |
| `Space` | Search forward (`/`) |
| `Ctrl+h/j/k/l` | Navigate between split windows |
| `,l` / `,h` | Next / previous buffer |
| `,fb` | Pick from open buffers |
| `,bd` | Close current buffer |
| `,e` | Toggle file explorer |
| `,f` | Find files |
| `,g` | Search file contents across the project |
| `,Gd` | Open Git diff view |
| `,GD` | Close Git diff view |
| `,Gp` | Preview Git hunk |
| `,Gb` | Git blame current line |
| `,ut` | Choose a colorscheme |
| `,ot` | Open/focus the embedded OpenCode TUI |
| `,oy` (Visual) | Append selected-code context; don't submit |
| `,oe` (Normal/Visual) | Explain the current code/selection |
| `,oa` (Normal/Visual) | Ask OpenCode with a custom prompt |
| `,os` (Normal/Visual) | Open OpenCode actions |
| `,tn` / `,tc` | New tab / close tab |
| `,ss` | Toggle spell-checking |
| `,q` / `,x` | Open personal scratch file / Markdown scratch file |

The authoritative bindings are in `lua/config/keymaps.lua` and the plugin specs under `lua/plugins/`. If your branch differs, use `:verbose nmap ,ot` or `:verbose xmap ,oy` to inspect active mappings.

### Splits and buffers

```vim
:vsplit path/to/file.kt   " side-by-side
:split path/to/file.kt    " above/below
:buffers                  " list open buffers
```

Use `Ctrl+h/j/k/l` to move between windows. Buffers are files; **Neovim tab pages** are separate layouts. Bufferline displays the open buffers at the top.

### Themes

```vim
:colorscheme catppuccin-mocha
:colorscheme tokyonight-moon
:colorscheme
```

Use `,ut` for the configured theme selector. If theme persistence is enabled, the selected theme is stored in local Neovim state and is **not** part of this repository; a new machine starts with the configured default.

## Configuration layout

```text
~/.config/nvim/
├── init.lua
├── lazy-lock.json            # commit this
├── lua/
│   ├── config/
│   │   ├── options.lua       # editor settings
│   │   ├── keymaps.lua       # personal mappings
│   │   ├── autocmds.lua      # autocommands
│   │   └── lazy.lua          # plugin manager bootstrap
│   └── plugins/
│       ├── editor.lua        # Snacks + which-key
│       ├── treesitter.lua
│       ├── git.lua
│       ├── bufferline.lua
│       ├── lualine.lua
│       ├── theme.lua
│       └── opencode.lua
└── README.md
```

Installed plugins, downloaded parsers, caches, and local editor state are **not** committed; lazy.nvim recreates the plugin installation from this config. Your personal OpenCode accounts/keys are also not included.

## Troubleshooting

| Problem | What to check |
| --- | --- |
| `E5422: Conflicting configs` | Move the old `init.vim` away; keep only `init.lua` as the startup config. |
| `E185: Cannot find color scheme` | Run `:Lazy sync`; confirm the theme plugin is installed and loaded; restart. |
| `:DiffviewOpen` says `E492` | Confirm `diffview.nvim` is installed and has a `cmd = { "DiffviewOpen", ... }` lazy-load trigger; use `,Gd`. |
| Missing/misrendered file icons | Select **FiraCode Nerd Font** in iTerm2; check that `nvim-web-devicons` is installed. |
| File search shows no content results | Confirm `rg --version`; run Neovim from your project directory. |
| Kotlin/Java highlighting is missing | Run `:TSUpdate`, check `:checkhealth nvim-treesitter`, and inspect `:set filetype?`. |
| `,ot` isn't recognized | Check `:verbose nmap ,ot`; confirm OpenCode mappings exist in `lua/plugins/opencode.lua`. |
| `,oy` doesn't appear in Normal mode | That's expected: it is **Visual-mode-only**; use `:verbose xmap ,oy`. |
| OpenCode does not connect | Check `opencode --version`, `:checkhealth opencode`, and `:messages`; verify CLI v1/plugin v1 compatibility. |
| Need to leave terminal input mode | Press `Ctrl+\`, then `Ctrl+n`, then navigate normally. |

## Maintenance

```vim
:Lazy check       " check for available plugin updates
:Lazy update      " update plugins and lazy-lock.json
:Lazy restore     " restore pinned versions from lazy-lock.json
:checkhealth      " diagnose Neovim environment
```

After deliberate plugin updates, review and commit changes to `lazy-lock.json` together with any config changes.

## References

- [lazy.nvim installation](https://lazy.folke.io/installation)
- [nvim-treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- [Snacks documentation](https://github.com/folke/snacks.nvim)
- [OpenCode Neovim integration](https://github.com/nickjvandyke/opencode.nvim)
- [FiraCode Nerd Font on Homebrew](https://formulae.brew.sh/cask/font-fira-code-nerd-font)
