# NvimConf

A minimal and clean **Neovim configuration** focused on C and C++ development using **clangd (LSP)**.

This configuration provides:

- LSP support via `clangd`
- Plugin management with `lazy.nvim`
- File explorer (`nvim-tree`)
- Statusline (`lualine`)
- Gruvbox theme
- System clipboard integration

---

## Requirements

### Neovim

Make sure Neovim is installed:

```bash
nvim --version
```

Neovim **0.10+** is recommended.

---

### clangd (Required for C/C++)

C and C++ language features such as:

- Autocomplete
- Go to definition
- Find references
- Diagnostics
- Code navigation

require **clangd**.

Install on Ubuntu/Debian:

```bash
sudo apt update
sudo apt install clangd
```

Verify installation:

```bash
clangd --version
```

---

## Installation

### 1. Clone the repository

```bash
git clone git@github.com:hyaldiz/NvimConf.git
```

### 2. Copy configuration to Neovim directory

Neovim config directory (Linux):

```
~/.config/nvim/
```

Copy the config:

```bash
mkdir -p ~/.config/nvim
cp -r NvimConf/nvim/* ~/.config/nvim/
```

Or sync:

```bash
rsync -av NvimConf/nvim/ ~/.config/nvim/
```

---

### 3. Install plugins

Start Neovim:

```bash
nvim
```

Then run:

```vim
:Lazy sync
```

Restart Neovim after plugin installation.

---

## C/C++ Setup (Important)

For proper C/C++ and Qt support, your project should contain a `compile_commands.json` file in the project root.

### If using CMake:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json compile_commands.json
```

This allows clangd to correctly detect:

- System headers
- External libraries
- Qt includes
- Compiler flags

---

## Qt Projects (Optional)

If Qt is installed under a custom directory (e.g. `~/Qt/...`), configure CMake with:

```bash
cmake -S . -B build \
  -DCMAKE_PREFIX_PATH=$HOME/Qt/6.x.x/gcc_64 \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

---

## Verifying LSP

Open a `.cpp` file and run:

```vim
:LspInfo
```

You should see:

```
clangd attached
```

If not attached:

- Open Neovim from the project root directory
- Ensure `compile_commands.json` exists
- Verify `clangd` is installed

---

## Useful Keybindings

- `<leader>e` → Toggle file explorer
- `Ctrl + x` then `Ctrl + o` → LSP completion (built-in)
- `:LspInfo` → Check LSP status

---

## Notes

- Minimal and performance-focused setup
- Designed for C/C++ development
- Easy to extend with additional plugins

---

Happy coding 🚀
