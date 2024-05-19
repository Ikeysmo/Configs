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

vim.api.nvim_exec([[
au BufNewFile,BufRead *.vh set ft=systemverilog
au BufNewFile,BufRead *.vs set ft=systemverilog
au BufNewFile,BufRead *.cjson set ft=jsonc
au BufNewFile,BufRead *.list set ft=python
au BufNewFile,BufRead *.jsonc set ft=jsonc
au BufNewFile,BufRead *.pb set ft=perl
au BufNewFile,BufRead *.max set ft=perl

]], false)

vim.api.nvim_exec([[

command SetDebugMode :%s/$RTLMODELS\/dkt\/pbatomc\/pbatomc-ertl-dkt-head0-latest/\/nfs\/site\/disks\/userdisk000_itsmoak\/pbatomc-ertl-dkt-head0/g
command SetDebugModeARW :%s/$RTLMODELS\/arw\/pbatomc\/pbatomc-ertl-arw-head0-latest/\/nfs\/site\/disks\/userdisk000_itsmoak\/arw_pbatomc/g
command ResetDebugMode :%s/\/nfs\/site\/disks\/userdisk000_itsmoak\/pbatomc-ertl-dkt-head0/$RTLMODELS\/dkt\/pbatomc\/pbatomc-ertl-dkt-head0-latest/g
command ResetDebugModeARW :%s/\/nfs\/site\/disks\/userdisk000_itsmoak\/arw_pbatomc/$RTLMODELS\/arw\/pbatomc\/pbatomc-ertl-arw-head0-latest/g
command GetFilePath :lua print(vim.api.nvim_buf_get_name(0))
]], false)
vim.api.nvim_exec([[

function! ParseMe(filename)
    let cur_buf = a:filename
    let cur_line = line(".")
    echom "File to use "
    echom cur_buf
    execute 'vnew PARSED_'.cur_buf 
    noautocmd execute 'r!$WORKDISK/scripts/tools/bnl_debug_parser.py -o -i '. cur_buf
    noautocmd execute cur_line
    
endfunction
]], false)


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


function includeAllBufs() 
    print("hello")
    -- print(vim.api.nvim_get_buffer)
    cur_buf = vim.api.nvim_get_current_buf()
    local f=vim.api.nvim_list_bufs()
    print(vim.inspect(f))
    for i , k in ipairs(f) do
       if(vim.api.nvim_buf_is_loaded(k) and vim.api.nvim_buf_is_valid(k) and vim.api.nvim_buf_get_option(k, 'buflisted') and k ~= cur_buf ) then 
        vim.fn.append(0, ".include " ..vim.api.nvim_buf_get_name(k))
        print(vim.api.nvim_buf_get_name(k))
        end
    end
    vim.fn.expand("%:p")
    -- vim.api.nvim_set_current_line("woowwow")
    -- vim.api.nvim_buf_set_lines(0,  3, 4, False,{"woowwow"})

end

function addStdHeader(dut)
    local dut = dut or "cpu1_h4c_4M"
    local lst = {".defaults -execcfg $MODEL_ROOT/valid/dfx/sim_cfg/cpu_dfx_uei.cfg",
"+defaults -ms -vcs +FSDB_LIST=$MODEL_ROOT/valid/dfx/debug/fsdb_scope.list -vcs- -ms-",
".overrides -dut " ..dut .." -dirtag "..dut 
}
    vim.fn.append(0, lst )
    -- .defaults -execcfg $MODEL_ROOT/valid/dfx/sim_cfg/cpu_dfx_uei.cfg
    -- +defaults -ms -vcs +FSDB_LIST=$MODEL_ROOT/valid/dfx/debug/fsdb_scope.list -vcs- -ms- 
    -- .overrides -dut cpu1_h2c_4M_NOUPF -dirtag cpu1_h2c_4M_NOUPF
    -- #.overrides -dut cpu1_h4c_2M -dirtag cpu1_h4c_2M 
    -- #.overrides -dut cpu_2cg1m   -dirtag cpu_2cg1m 
    -- #.overrides -dut cpu_2cs1m   -dirtag cpu_2cs1m 
    -- vim.api.nvim_set_current_line("woowwow")
    -- vim.api.nvim_buf_set_lines(0,  3, 4, False,{"woowwow"})

end
vim.api.nvim_create_user_command('BufInclude', includeAllBufs, {})
vim.api.nvim_create_user_command('AddHeader', 
    function(opts)
        addStdHeader(opts.fargs[1])
    end,
    {nargs = "*"} )

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
            "kylechui/nvim-surround",
            version = "*", -- Use for stability; omit to use `main` branch for the latest features
            event = "VeryLazy",
            config = function()
                require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                })
            end
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
            'numToStr/Comment.nvim',
            opts = {
                -- add any options here
            },
            lazy = false,
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
        { 'nvim-treesitter/nvim-treesitter', lazy = false}, -- , dependencies={'nvim-treesitter/nvim-treesitter-textobjects' },
        { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = false ,
            config = function()
                    require ('nvim-treesitter.configs').setup( {
                      textobjects = {
                        select = {
                          enable = true,

                          -- Automatically jump forward to textobj, similar to targets.vim
                          lookahead = true,

                          keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                            ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
                            ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                            ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" }, 
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                          },
                          -- You can choose the select mode (default is charwise 'v')
                          --
                          -- Can also be a function which gets passed a table with the keys
                          -- * query_string: eg '@function.inner'
                          -- * method: eg 'v' or 'o'
                          -- and should return the mode ('v', 'V', or '<c-v>') or a table
                          -- mapping query_strings to modes.
                          selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                          },
                          -- If you set this to `true` (default is `false`) then any textobject is
                          -- extended to include preceding or succeeding whitespace. Succeeding
                          -- whitespace has priority in order to act similarly to eg the built-in
                          -- `ap`.
                          --
                          -- Can also be a function which gets passed a table with the keys
                          -- * query_string: eg '@function.inner'
                          -- * selection_mode: eg 'v'
                          -- and should return true or false
                          include_surrounding_whitespace = true,
                        },
                      },
                    })
                end
    },
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
-- vim.cmd([[set autochdir]])
vim.cmd([[set t_TI= t_TE=]])
vim.cmd([[command ParseBNL :exec "call ParseMe(expand('%'))"]])
vim.cmd([[command ParseBNLI :exec "!$WORKDISK/scripts/tools/bnl_debug_parser.py -o -i %"]])


local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
lsp.setup()

--require('lspconfig').svls.setup({})

-- vim.lsp.start({
--      name = 'svls_server',
--      cmd = {'svls'},
--      root_dir = vim.fs.dirname(vim.fs.find({'svls.toml'}, { upward = true })[1]),
--    })


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


local function cd_root()
    -- vim.api.nvim_clear_autocmds({group="GitCd"})
    buf_path = vim.api.nvim_buf_get_name(0)
    -- local base_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
    local base_dir = vim.fn.fnamemodify(buf_path, ":h")
    vim.fn.chdir(base_dir)
    -- print("BASE_DIR: " .. base_dir)

    local repo_git =vim.fn.finddir(".git" , ".;" )
    -- print("REPO_DIR: " .. repo_git)

    local repo = vim.fn.fnamemodify(repo_git, ":h")
    -- print("REPO FINAL: " .. repo)
    if (repo == ".") then
        -- print(vim.api.nvim_buf_get_name(0))
        repo = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
    end
    vim.api.nvim_set_current_dir(repo)
    if (repo ~= ".") then 
        print("Changed dir to: " ..vim.fn.getcwd())
        vim.fn.chdir(repo)
    end
end

vim.api.nvim_create_user_command("CdRootGit", cd_root, {})
vim.api.nvim_create_augroup('GitCd', {})
vim.api.nvim_create_autocmd("BufEnter", 
    {
        pattern= '*.*',
        callback = cd_root,
        group = 'GitCd'
    })
