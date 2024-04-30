-- Include Vim config directories and load .vimrc
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')


nvim_version = vim.version()

if nvim_version.major > 0 or nvim_version.minor >= 8 then

    -- Treesitter stuff
    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "cpp", "rust", "bash" },
        sync_install = false,
        auto_install = false,
        highlight = {
            enable = true,
            -- workaround for indent issue
            -- GH: nvim-treesitter/nvim-treesitter issue 1573
            additional_vim_regex_highlighting = { "python", "vim" },
        },
    }
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


    -- @@@@@@@@@@@@@ --
    -- @ LSP stuff @ --
    -- @@@@@@@@@@@@@ --

    -- enable specific LSP servers
    require'lspconfig'.pylsp.setup{}
    require'lspconfig'.rls.setup{}
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

    -- @@@@@@@@@@@@@@@@@@@@@@@@@ --
    -- @ Plugin configurations @ --
    -- @@@@@@@@@@@@@@@@@@@@@@@@@ --

    -- rainbow-delimiters.nvim

    function set_rd_hl_colors(red, yellow, blue, orange, green, violet, cyan)
        vim.cmd('highlight RainbowDelimiterRed guifg=' .. red)
        vim.cmd('highlight RainbowDelimiterYellow guifg=' .. yellow)
        vim.cmd('highlight RainbowDelimiterBlue guifg=' .. blue)
        vim.cmd('highlight RainbowDelimiterOrange guifg=' .. orange)
        vim.cmd('highlight RainbowDelimiterGreen guifg=' .. green)
        vim.cmd('highlight RainbowDelimiterViolet guifg=' .. violet)
        vim.cmd('highlight RainbowDelimiterCyan guifg=' .. cyan)
    end

    function set_rd_hl_colors_for(colorscheme, red, yellow, blue, orange, green, violet, cyan)
        -- if it's already set to this colorscheme, then set the colors appropriately
        if vim.g.colors_name == colorscheme then
            set_rd_hl_colors(red, yellow, blue, orange, green, violet, cyan)
        end
        -- create an autocmd to run when switching to colorscheme
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = colorscheme,
            callback = function(ev)
                set_rd_hl_colors(red, yellow, blue, orange, green, violet, cyan)
            end
        })
    end

    -- sourcerer
    -- most colors are defined in https://github.com/xero/sourcerer/blob/master/sourcerer.Xresources
    -- the yellow is desaturated 50% using https://github.com/sharkdp/pastel
    -- the orange is from mixing the desaturated yellow and the default red (also using pastel)
    set_rd_hl_colors_for('sourcerer', '#aa4450', '#bf8c40', '#6688aa', '#b56a4a', '#719611', '#8f6f8f', '#528b8b')


    -- vylight
    -- colors from https://github.com/sharkdp/pastel
    -- salmon, darkkhaki, mediumslateblue, peru, forestgreen, darkorchid, teal
    set_rd_hl_colors_for('vylight', '#fa8072', '#bdb76b', '#7b68ee', '#cd853f', '#228b22', '#9932cc', '#008080')

    -- colors from https://github.com/sharkdp/pastel
    -- red, yellow, blue, orange, lime, violet, cyan
    set_rd_hl_colors_for('default', '#ff0000','#ffff00','#0000ff','#ffa500','#00ff00','#ee82ee','#00ffff')
end
