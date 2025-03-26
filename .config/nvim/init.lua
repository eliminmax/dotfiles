-- Include Vim config directories and load .vimrc
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

nvim_version = vim.version()

-- restore error if swapfile exists in nvim 0.10
if nvim_version.major == 0 and nvim_version.minor == 10 then
    vim.cmd('autocmd! nvim_swapfile')
end

if nvim_version.major > 0 or nvim_version.minor >= 8 then
    -- @@@@@@@@@@@@@@@@@@@@ --
    -- @ Treesitter stuff @ --
    -- @@@@@@@@@@@@@@@@@@@@ --

    require('tree-sitter-just').setup({})

    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "cpp", "rust", "bash", "markdown", "just" },
        sync_install = false,
        auto_install = false,
        highlight = {
            enable = true,
            disable = { "awk" },
            -- workaround for indent issue
            -- GH: nvim-treesitter/nvim-treesitter issue 1573
            additional_vim_regex_highlighting = { "python", "vim", "markdown" },
        },
        indent = {
            enable = true,
        },
    }
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


    -- @@@@@@@@@@@@@ --
    -- @ LSP stuff @ --
    -- @@@@@@@@@@@@@ --

    -- enable specific LSP servers
    require'lspconfig'.pylsp.setup{}
    require'lspconfig'.clangd.setup{}
    -- LSP keymappings from nvim-lspconfig recommendations
    vim.keymap.set('n', '<C-space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<C-space>q', vim.diagnostic.setloclist)

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<C-space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<C-space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<C-space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<C-space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<C-space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<C-space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<C-space>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
    })

    -- @@@@@@@@@@@@@@@@@ --
    -- @ Miscellaneous @ --
    -- @@@@@@@@@@@@@@@@@ --
    
    -- I prefer a more intense colorcolumn, so set background to color taken from Moonfly's Cranberry
    if vim.g.colors_name == 'moonfly' then
        vim.api.nvim_set_hl(0, "ColorColumn", { fg = "#000000", bg = "#e65e72" })
    end
    -- create autocmd to do the above for me
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = colorscheme,
        callback = function(ev)
            vim.cmd('highlight ColorScheme guibg=#e65e72 guifg=#000000')
        end
    })
    
    
    local rocks_config = {
        rocks_path = vim.env.HOME .. "/.local/share/nvim/rocks",
    }
    
    vim.g.rocks_nvim = rocks_config
    
    local luarocks_path = {
        vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
        vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
    }
    package.path = package.path .. ";" .. table.concat(luarocks_path, ";")
    
    local luarocks_cpath = {
        vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
        vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
        -- Remove the dylib and dll paths if you do not need macos or windows support
        vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dylib"),
        vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dylib"),
        vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dll"),
        vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dll"),
    }
    package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")
    
    vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*"))

end
