" ############ "
" Basic config "
" ############ "

" Settings specific to Vim but not Neovim or visa-versa
if has('nvim')
    au TermOpen * setlocal nonumber " no numbers in Neovim terminal
else
    set t_ut= " needed to be able to set background color properly in kitty
    set nocompatible " Don't attempt vi compatibility
endif

set linebreak " wrap lines at words, not at the last character that fits

" don't set these if running in vscode
if !exists('g:vscode')
    " General
    set number " Show line numbers by default
    set mouse=nvc " normal, visual, command, but not insert
    set background=dark " Use bright colors to better contrast a dark background
    set lazyredraw " Use a more efficient approach to buffer drawing
    " Folding behavior
    set foldlevelstart=8 " Decently high threshold for automatic folding
    set foldnestmax=8 " Avoid too many folds in memory at once
endif

" General
set splitbelow " Open new view below current view
set splitright " open vertical splits to the right
set encoding=utf-8 " Use UTF-8 encoding  by default
set showmatch " Show matching angle brackets

" Searching
set incsearch " Show search matches as query is typed
set hlsearch " Keep search matches highlighted
set ignorecase smartcase " Use smart case for pattern matching

" Indentation
set autoindent " indent automatically
set expandtab " Expand tabs to spaces
set shiftwidth=4 " Define level of indentation
set tabstop=4 " Define size of a \t character
set softtabstop=4 " Backspace and tab move up to this many chars

" Save Swap files to ~/.vim/swap and backup files to ~/.vim/backup instead of 
" the directory of the file; delete backup after successful write.
" doubling the trailing slash includes the full path in the name of the file
" so that foo/file.txt and bar/file.txt won't clash.
set nobackup writebackup backupdir=~/.vim/backup// directory=~/.vim/swap//

" readable statusline with useful info, not as fancy as airline, but good
" enough for my needs..
set statusline=%0.32(%f\ %h%w%y%r%m%)%=%(%{wordcount().words}\ words,\ 
            \%L\ lines\ \ current\ location:\ %l:%c%)

" Keybindings
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
inoremap <Down> <Esc>gjli
inoremap <Up> <Esc>gkli
nnoremap ; :nohlsearch<CR>
nnoremap <space> za

" disable the bell
set belloff=all noerrorbells visualbell t_vb=

" #################### "
" Function definitions
" #################### "
function! ShortTabs()
    setlocal shiftwidth=2
    setlocal tabstop=2
    setlocal softtabstop=2
endfunction
function! SemiShortTabs()
    setlocal shiftwidth=3
    setlocal tabstop=3
    setlocal softtabstop=3
endfunction
function! NormalTabs()
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal softtabstop=4
endfunction
function! LongTabs()
    setlocal shiftwidth=8
    setlocal tabstop=8
    setlocal softtabstop=8
endfunction

" ################################### "
" vim-plug plugin manager plugin list "
" ################################### "

" check if neovim is new enough for LSP and Treesitter stuff (i.e. at least 0.8)
let useTSandLSP = has('nvim') &&
            \ (v:lua.vim.version().major > 0 || v:lua.vim.version().minor >= 8)

" function used to simplify conditionally loading plugins with vim-plug
" from https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" define list of plug-ins to use
call plug#begin('~/.vim/plugged')
" LSP and Treesitter configuration tooling for Neovim
Plug 'neovim/nvim-lspconfig', Cond(useTSandLSP)
Plug 'nvim-treesitter/nvim-treesitter', Cond(useTSandLSP, {'do': ':TSUpdate'})
" Neovim completion plugin powered by Treesitter and LSP
Plug 'ms-jpq/coq_nvim', Cond(useTSandLSP)
" Better tab name management
Plug 'gcmt/taboo.vim'
" Change defaults to something friendlier
Plug 'tpope/vim-sensible'
" Git integration that's "so awesome, it should be illegal!"
Plug 'tpope/vim-fugitive'
" Sidebar with overview of file contents - requires either exuberant ctags
" or universal ctags, which are external executables
Plug 'preservim/tagbar'
" NERDTree - file sidebar
Plug 'preservim/nerdtree'
" git info in NERDtree
Plug 'Xuyuanp/nerdtree-git-plugin'
" Nerd Font logos in NERDTree
Plug 'ryanoasis/vim-devicons'
" highlighting in NERDTree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" See git changes right beside line numbers
Plug 'airblade/vim-gitgutter'
" multi-line selection done easy
Plug 'mg979/vim-visual-multi'
" Moonfly color scheme
Plug 'bluz71/vim-moonfly-colors'
" add multi-line comment toggling
Plug 'tpope/vim-commentary'
" Text alignment tool - needed for some vim-markdown functionality, even if I
" don't use it myself
Plug 'godlygeek/tabular'
" EditorConfig support
Plug 'editorconfig/editorconfig-vim'
" #################################### "
" Improved/Additional Language Support "
" #################################### "
" Syntax highlighting for Kotlin
Plug 'udalov/kotlin-vim'
" Automatically generated Markdown Table of Contents
Plug 'mzlogin/vim-markdown-toc'
" Jupyter (via jupytext)
Plug 'goerz/jupytext.vim'
" Better than default markdown support
Plug 'preservim/vim-markdown', {'for': 'markdown'}
" nginx configuration syntax support
Plug 'vim-scripts/nginx.vim'
" syntax support for the assembly-like language from the game Mindustry
Plug 'purofle/vim-mindustry-logic'
" Indent according to python's PEP-8 style standard
Plug 'Vimjas/vim-python-pep8-indent'
" Add a built-in Autopep8 tool on non-Neovim systems
Plug 'tell-k/vim-autopep8', Cond(!has('nvim'))
" javascript syntax + improved indentation
Plug 'pangloss/vim-javascript'
" support for the Caddy web server's Caddyfile configuration format
Plug 'isobit/vim-caddyfile'
" Syntax highlighting Cisco IOS command language
Plug 'CyCoreSystems/vim-cisco-ios'
" Official Rust Vim Plugin
Plug 'rust-lang/rust.vim', Cond(!exists('g:vscode'), {'for': 'rust'})
" Syntax highlighting for kitty terminal config file
Plug 'fladson/vim-kitty'
" Syntax highlighting for xonsh
Plug 'meatballs/vim-xonsh'
" Syntax highlighting for Redox's ion shell
Plug 'vmchale/ion-vim'
" Syntax highlighting for OpenWRT's Universal Configuration Interface
Plug 'cmcaine/vim-uci'
" Syntax highlighting for Zig
Plug 'ziglang/zig.vim'
" Syntax highlighting for Nim
Plug 'zah/nim.vim'
" Highlight POSIX C types as types.
Plug 'eliminmax/posix-ctypes.vim'
" Syntax highlighting for Vala
Plug 'arrufat/vala.vim'
" Syntax highlighting for OCaml
Plug 'ocaml/vim-ocaml'
" Syntax highlighting for Algol 68
Plug 'sterpe/vim-algol68'
" Brainfuck interpreter + syntax highlighting
Plug 'fruit-in/brainfuck-vim'
" Syntax highlighting for Jinja templates
Plug 'HiPhish/jinja.vim'
" Syntax highlighting for Babalang
Plug 'eliminmax/babalang.vim'
" Syntax highlighting for Rockstar
Plug 'sirosen/vim-rockstar'
" Syntax highlighting for LLVM IR
Plug 'rhysd/vim-llvm'
" Syntax highlighting for Odin
Plug 'Tetralux/odin.vim'
" Syntax highlighting for Elixir
Plug 'elixir-editors/vim-elixir'
call plug#end()

" ###################### "
" Filetype configuration "
" ###################### "

" Don't use filetype-specific indentation settings
filetype indent off

" call ShortTabs() for specific file types
autocmd FileType yaml call ShortTabs()
autocmd FileType cisco call ShortTabs()
autocmd FileType markdown call ShortTabs()
autocmd FileType markdown.jinja call ShortTabs()

" Makefiles can't use spaces, and tabs are 8 characters for them as far as wc
" is concerned, so might as well go with the flow on that one.
autocmd Filetype make call LongTabs()

" ############################## "
" Plugin-specific configurations "
" ############################## "

" autopep8 - don't run automatically.
let g:autopep8_disable_show_diff = 1
let g:autopep8_on_save = 0

" Do not run in VSCode/Codium
if !exists('g:vscode')
    " jupytext.vim - specify flags used to convert from markdown to ipynb file
    let g:jupytext_to_ipynb_opts = '--update --set-kernel python3 --to=ipynb '.
                \'--update-metadata ''{"jupytext":{"notebook_metadata_filter":'.
                \'"-all"},"cell_metadata_filter": "-all"}'''

    " NERDTree configuration
    "launch if vim opens a directory without stdin
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && 
                \isdirectory(argv()[0]) && !exists('s:std_in') |
        \ execute 'NERDTree' argv()[0] | wincmd p | enew | 
        \ execute 'cd '.argv()[0] | endif

    " Make sure that EditorConfig plays nice with fugitive, and does not attemt
    " to load on remote files
    let g:EditorConfig_exclude_patterns = ['\(fugitive\|scp\|fetch\|dav\|davs'.
                \'\|https\|http\|rcp\|rsync\|sftp\)://.*']

    " vim-markdown settings
    let vim_markdown_new_list_item_indent = 0
    let g:vim_markdown_strikethrough = 1
    let g:vim_markdown_no_extensions_in_markdown = 0
    let g:vim_markdown_autowrite = 1
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_conceal_code_blocks = 0
    " "foo=bar" means that a code block beginning with "```foo" will be
    " treated as though it began with "bar"
    let g:vim_markdown_fenced_languages = ['pwsh=ps1', 'posh=ps1',
                \'powershell=ps1']

    " Force 256-color in GNU Screen
        if $TERM == 'screen'
            set t_Co=256
        endif
    " Theming
    if $COLORTERM == 'truecolor'
        set termguicolors
    endif
    if $TERM == 'linux'
        colorscheme default
        " if LIGHT_MODE is set*, use a light color scheme from the vim-scripts
        " Debian Package
        " (*typically by ~/.config/bashrc.d/21-kitty-functions.sh)
    elseif ($LIGHT_MODE == '1')
        colorscheme chela_light
        " moonfly throws an error if on Neovim versions older than 0.9, but
        " not Vim or newer versions of Neovim
        "
        " Debian's editor command is a symlink to the default system editor,
        " which for my system, is Neovim 0.7.2 as packaged for Debian 12, so
        " that error sometimes appears. Fall back on blacksea from the
        " vim-scripts Debian package if that would happen.
    elseif (!has('nvim')) || ( v:lua.vim.version().major > 0 ||
                \v:lua.vim.version().minor >= 9 )
        colorscheme moonfly
    else
        colorscheme blacksea
    endif
endif

" Project-specific configs

" I use Jinja in my mkdocs-powered tech journal, use markdown.jinja as the
" filetype for it
autocmd BufRead,BufNewFile ~/Git/tech-journal/*.md set filetype=markdown.jinja
" For eambfc, my personal brainfuck compiler project, non-brainfuck code
" should have column 81 hightlighted.
autocmd BufRead,BufNewFile ~/Git/eambfc* if match(&filetype, "brainfuck") < 0
            \ | set colorcolumn=81 | endif
" For the rust rewrite, overwrite the column limit to 100 for rust files
autocmd BufRead,BufNewFile ~/Git/eambfc-rs* if match(&filetype, "rust") >= 0
            \ | set colorcolumn=101 | endif
" For eamsh as well, my attempt to write a minimal shell, code should have
" column 81 highlighted
autocmd BufRead,BufNewFile ~/Git/eamsh/* set colorcolumn=81

" highlight column 81 to help ensure a hard 80-column limit for this file
" vim: colorcolumn=81
