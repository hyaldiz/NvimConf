# NvimConf

A minimal and clean **Neovim configuration** focused on C and C++ development using **clangd (LSP)**.

  - init.lua (Neovim 0.11.x) - C/C++ + CMake + Makefile/Autotools
  - LSP: clangd, cmake, autotools_ls
  - Completion: nvim-cmp
  - Formatting: conform.nvim (clang-format + optional cmake-format)
  - Plugin manager: lazy.nvim (auto bootstrap)
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

For proper C/C++ , your project should contain a `compile_commands.json` file in the project root.

### If using CMake:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json compile_commands.json
```
iler flags

```bash
cmake -S . -B build \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

---

Happy coding 🚀
