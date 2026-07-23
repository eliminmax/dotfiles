-- Include Vim config directories and load .vimrc
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

nvim_version = vim.version()

-- restore error if swapfile exists
vim.cmd('autocmd! nvim.swapfile')

--- @@@@@@@@@@@ ---
--- @ Plugins @ ---
--- @@@@@@@@@@@ ---

vim.pack.add {{
  src = 'https://github.com/mrcjkb/rustaceanvim',
  -- To avoid being surprised by breaking changes,
  -- I recommend you set a version range
  version = vim.version.range('^9')
}}

vim.pack.add {{
    src = 'https://github.com/mrjones2014/codesettings.nvim',
    version= vim.version.range('^1')
}}

-- @@@@@@@@@@@@@ --
-- @ LSP stuff @ --
-- @@@@@@@@@@@@@ --

-- enable specific LSP servers
vim.lsp.enable('clangd')
vim.lsp.enable('pylsp', { settings = {
    pylsp = {
        plugins = {
            mypy = { enabled = true },
            black = { enabled = true }
        }
    }
}})
vim.lsp.enable("jdtls")

vim.lsp.config('rust-analyzer', {
    before_init = function(init_params, config)
        local codesettings = require('codesettings')
        codesettings.with_local_settings(config.name, config)

        if config.default_settings and config.default_settings[config.name] then
          init_params.initializationOptions = config.default_settings[config.name]
        end
    end,
})

-- LSP keymappings from nvim-lspconfig recommendations
vim.keymap.set('n', '<C-space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<C-space>q', vim.diagnostic.setloclist)

vim.keymap.set('n', '[d', function(opts) vim.diagnostic.jump({count = -1, float = true}) end)
vim.keymap.set('n', ']d', function(opts) vim.diagnostic.jump({count = 1, float = true }) end)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.api.nvim_create_user_command(
        "TypeHintsOn", "lua vim.lsp.inlay_hint.enable(true)", {}
    )
    vim.api.nvim_create_user_command(
        "TypeHintsOff", "lua vim.lsp.inlay_hint.enable(false)", {}
    )
    vim.api.nvim_create_user_command(
        "TypeHintsToggle",
        "lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())",
        {}
    )
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
-- create autocmd to do the above for me when switching from a different colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = colorscheme,
    callback = function(ev)
        vim.cmd('highlight ColorScheme guibg=#e65e72 guifg=#000000')
    end
})

vim.g.rustaceanvim = {
    tools = {
    },
    server = {
        on_attach = function(client, bufnr)
        end,
        default_settings = {
            ['rust-analyzer'] = {
                ['cargo'] = {
                    features = 'all'
                },
            },
        },
    },
    dap = {
    },
}

-- @@@@@@@@@@@@@@@@@@@@ --
-- @ Treesitter stuff @ --
-- @@@@@@@@@@@@@@@@@@@@ --

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "bash",
        "c",
        "cpp",
        "just",
        "lua",
        "markdown",
        "python",
        "java",
        "query",
        "rust",
        "vim",
        "vimdoc"
    },
    callback = function()
        vim.treesitter.start()
    end,
    group = nvimrc_augroup
})


-- work around messy indentation handling in python files
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python"}, callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
    gorup = nvimrc_augroup
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

require("jupytext").setup({})

 -- https://stackoverflow.com/a/27028488
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
