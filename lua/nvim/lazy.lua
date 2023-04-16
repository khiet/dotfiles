local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ 
  { "nvim-telescope/telescope.nvim", tag = "0.1.1", dependencies = { "nvim-lua/plenary.nvim" } },
  { url = "git@github.com:khiet/dracula-pro.git" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "ThePrimeagen/harpoon" },
  { "airblade/vim-gitgutter" },
  { "kyazdani42/nvim-tree.lua" },
  { "voldikss/vim-floaterm" },
  { "dominikduda/vim_current_word" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "tpope/vim-rails" },
  { "junegunn/vim-easy-align" },
  { "FooSoft/vim-argwrap" },
  { "sheerun/vim-polyglot" },
  { "janko-m/vim-test" },
  { "benmills/vimux" },
  { "vimwiki/vimwiki", branch = "dev" },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" }
  },
})
