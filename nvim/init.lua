-- ==========================================================
-- init.lua (Neovim 0.11.x) - C/C++ + CMake + Makefile/Autotools
-- LSP: clangd, cmake, autotools_ls
-- Completion: nvim-cmp
-- Formatting: conform.nvim (clang-format + optional cmake-format)
-- Plugin manager: lazy.nvim (auto bootstrap)
-- ==========================================================

-- -------------------------
-- Basic options
-- -------------------------
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"

-- -------------------------
-- Diagnostic
-- -------------------------
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "●", -- istersen "■" / "" vs.
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
})

-- -------------------------
-- Lazy.nvim bootstrap
-- -------------------------
local uv = vim.uv -- 0.11'de var
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- -------------------------
-- Plugins
-- -------------------------
require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  { "stevearc/conform.nvim" },

  -- Tema: gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- Statusline: lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "gruvbox" } })
    end,
  },

  -- Project/File Explorer: nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>", { silent = true, noremap = true })
    end,
  },
})

-- -------------------------
-- General keymaps
-- -------------------------
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- -------------------------
-- nvim-cmp (completion)
-- -------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- LSP capabilities (for completion)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Buffer-local LSP mappings
local function on_attach(_, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("gd", vim.lsp.buf.definition, "Go to Definition")
  nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
  nmap("gr", vim.lsp.buf.references, "References")
  nmap("gi", vim.lsp.buf.implementation, "Implementation")
  nmap("K", vim.lsp.buf.hover, "Hover")
  nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
end

-- -------------------------
-- Mason: install LSP servers
-- -------------------------
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",        -- C/C++
    "cmake",         -- CMake (cmake-language-server)
    "autotools_ls",  -- Makefile/Autotools (autotools-language-server)
  },
})

-- -------------------------
-- New Nvim 0.11+ LSP config style
-- -------------------------
vim.lsp.config("*", {
  capabilities = capabilities,
  on_attach = on_attach,
  root_markers = { ".git" },
})

-- C/C++
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--fallback-style=LLVM",
    -- Cross-compile / embedded gerekiyorsa aç:
    -- "--query-driver=/usr/bin/*gcc*,/usr/bin/*g++*,/opt/*/bin/*gcc*,/opt/*/bin/*g++*",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    "Makefile",
    ".git",
  },
})

-- CMake
vim.lsp.config("cmake", {
  filetypes = { "cmake" },
  root_markers = { "CMakePresets.json", "CMakeLists.txt", ".git" },
})

-- Makefile / Autotools
vim.lsp.config("autotools_ls", {
  root_markers = { "configure.ac", "configure.in", "Makefile.am", "Makefile", ".git" },
})

vim.lsp.enable({ "clangd", "cmake", "autotools_ls" })

-- -------------------------
-- Formatting (conform.nvim)
-- -------------------------
require("conform").setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    cmake = { "cmake_format" }, -- optional; yoksa sorun değil
  },
  format_on_save = {
    timeout_ms = 800,
    lsp_fallback = true,
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })
