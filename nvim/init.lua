-- =========================
--  Genel Ayarlar / Leader
-- =========================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =========================
--  Temel Neovim Ayarları
-- =========================
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"

-- =========================
--  lazy.nvim bootstrap
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
--  LSP: clangd (GARANTİ)
-- =========================
-- .c/.cpp açılınca clangd'yi başlatır
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function()
    local root = vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1]
    if not root then
      return
    end
    local root_dir = vim.fs.dirname(root)

    vim.lsp.start({
      name = "clangd",
      cmd = { "clangd", "--background-index" },
      root_dir = root_dir,
    })
  end,
})

-- =========================
--  Pluginler
-- =========================
require("lazy").setup({
  -- (Opsiyonel) LSP config: nvim-lspconfig
  -- İstersen kalsın, ama yukarıdaki vim.lsp.start zaten clangd'yi başlatıyor.
  { "neovim/nvim-lspconfig" },

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
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, noremap = true })
    end,
  },
})

