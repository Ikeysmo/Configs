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




--[[ opts.lua ]]
local opt = vim.opt
local map = vim.api.nvim_set_keymap 

map('i', 'jj', '<ESC>', {noremap=true, silent=false})
-- [[ Context ]]
-- opt.colorcolumn = '80'           -- str:  Show col for max line length
opt.number = true                -- bool: Show line numbers
-- opt.relativenumber = true        -- bool: Show relative line numbers
-- opt.scrolloff = 4                -- int:  Min num lines of context
-- opt.signcolumn = "yes"           -- str:  Show the sign column

-- [[ Filetypes ]]
-- opt.encoding = 'utf8'            -- str:  String encoding to use
-- opt.fileencoding = 'utf8'        -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

-- [[ Search ]]
opt.ignorecase = true            -- bool: Ignore case in search patterns
opt.smartcase = true             -- bool: Override ignorecase if search contains capitals
opt.incsearch = true             -- bool: Use incremental search
opt.hlsearch = true             -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true             -- bool: Use spaces instead of tabs
opt.shiftwidth = 4               -- num:  Size of an indent
opt.softtabstop = 4              -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 4                  -- num:  Number of spaces tabs count for

-- [[ Splits ]]
opt.splitright = true            -- bool: Place new window to right of current one
opt.splitbelow = true            -- bool: Place new window below the current one
--set nocompatible 

--set ignorecase
--
--set hlsearch
--
--set incsearch
--
--set tabstop=4
--
--set expandtab
--
--set shiftwidth=4
--
--set autoindent 
--set number 
--filetype plugin indent on 
--syntax on 
--set mouse=a
--set clipboard=unnamedplus
--
--filetype plugin on 

require("lazy").setup(
    {
        {

          "nvim-tree/nvim-tree.lua",
          version = "*",
          lazy = false,
          dependencies = {
            "nvim-tree/nvim-web-devicons",
          },
          config = function()
            require("nvim-tree").setup {}
          end,
        },
        --{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
        { "morhetz/gruvbox"},
        { "nvim-lualine/lualine.nvim", opts = true,
            options= {icons_enabled = false}
        },
        {
            'kdheepak/tabline.nvim',
              config = function()
                require('tabline').setup {
                  -- Defaults configuration options
                  enable = true,
                  options = {
                  -- If lualine is installed tabline will use separators configured in lualine by default.
                  -- These options can be used to override those settings.
                    section_separators = {'', ''},
                    component_separators = {'', ''},
                    max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
                    show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
                    show_devicons = true, -- this shows devicons in buffer section
                    show_bufnr = false, -- this appends [bufnr] to buffer section,
                    show_filename_only = false, -- shows base filename only instead of relative path in filename
                    modified_icon = "+ ", -- change the default modified icon
                    modified_italic = false, -- set to true by default; this determines whether the filename turns italic if modified
                    show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
                  }

           }
           end,
        },
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            opts = {} -- this is equalent to setup({}) function
        },
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.5',
            -- or                              , branch = '0.1.x',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {
            'numToStr/Comment.nvim',
            opts = {
                -- add any options here
            },
            lazy = false,
        },
        {'williamboman/mason.nvim', lazy=false},
        {'williamboman/mason-lspconfig.nvim'},
        {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
        {'neovim/nvim-lspconfig'},
        { 'nvim-treesitter/nvim-treesitter', lazy = true },
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/nvim-cmp'},
        
        {'L3MON4D3/LuaSnip'},
        --{
          --"ibhagwan/fzf-lua",
          ---- optional for icon support
          --dependencies = { "nvim-tree/nvim-web-devicons" },
          --config = function()
            ---- calling `setup` is optional for customization
            --require("fzf-lua").setup({})
          --end
        --},
        {'junegunn/fzf'},
        {'junegunn/fzf.vim'},
    }

)

vim.o.background="dark"
vim.cmd([[colorscheme gruvbox]])
vim.cmd([[autocmd BufWinEnter,WinEnter term://* startinsert]])
vim.cmd([[autocmd TermOpen * setlocal nonumber]])
vim.cmd([[set autochdir]])
vim.cmd([[set t_TI= t_TE=]])


local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
lsp.setup()

--require('lspconfig').svls.setup({})

--vim.lsp.start({
--     name = 'svls_server',
--     cmd = {'svls'},
--     root_dir = vim.fs.dirname(vim.fs.find({'svls.toml'}, { upward = true })[1]),
--   })


require("nvim-web-devicons").setup({})
require("mason").setup({
    registries = { "github:mason-org/mason-registry@2023-05-15-next-towel"},
    providers = {"mason.providers.client",},
    github = {download_url_template = 'https://proxy.corporate.com/generic-github-releases/%s/releases/download/%s/%s',},
})
require('mason-lspconfig').setup({
  handlers = {
    lsp.default_setup,
    svlangserver = function() require('lspconfig').svlangserver.setup({
        settings = {systemverilog = {launchConfiguration = "verilator -sv -Wall --lint-only --timing",
                        linter = 'verilator',              
                        disableLinting = false}},
                    
    })
end
  },
})
vim.keymap.set("n", "<c-f>",
  "<cmd>Files<CR>", { silent = true })
vim.keymap.set("n", "<c-b>",
  "<cmd>Buffers<CR>", { silent = true })

