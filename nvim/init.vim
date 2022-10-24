call plug#begin('~/.vim/plugged')

" configurations for LSP client
Plug 'neovim/nvim-lspconfig'

" more rust-analyzer features
Plug 'simrat39/rust-tools.nvim'

" Automatic ctag generation
" requires separate installation of a ctag implementation
Plug 'ludovicchabant/vim-gutentags'

" Tag and LSP symbol viewer
Plug 'liuchengxu/vista.vim'

" Configurable statusline
Plug 'itchyny/lightline.vim'

" colorscheme
Plug 'arcticicestudio/nord-vim'

call plug#end()

" LSP setup (julia) 
lua << EOF
require'lspconfig'.julials.setup{}
EOF

" LSP setup (rust, through rust-tools)
lua << EOF
require('rust-tools').setup({})
EOF

" LSP shortcuts
nnoremap <silent> lh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> l[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> l] <cmd>lua vim.diagnostic.goto_next()<CR>

" default indentation
set tabstop=4 shiftwidth=4 expandtab

" hide -- INSERT -- at bottom of window---shown in lightline
set noshowmode

" use nord colorscheme
set termguicolors
colorscheme nord
let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \   'left':  [ [ 'mode', 'paste' ],
    \              [ 'readonly', 'filename', 'modified' ],
    \              [ 'current_function'] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ],
    \ },  
    \ 'component_function': {
    \   'current_function': 'LightlineCurrentFunctionVista',
    \ },
    \ }


" per-language settings
autocmd FileType julia call Julia_settings()
autocmd FileType rust call Rust_settings()
autocmd FileType cpp call Cpp_settings()

function! Julia_settings()
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal expandtab
endfunction

function! Rust_settings()
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal expandtab
    setlocal colorcolumn=80
endfunction

function! Cpp_settings()

    setlocal tabstop=3
    setlocal shiftwidth=3
    setlocal expandtab

    " Highlight extra whitespace with pure red (ugly on purpose)
    highlight ExtraWhitespace ctermbg=red guibg=red    
    match ExtraWhitspace /\s\+$/
    au BufWinEnter * match ExtraWhitespace /\s\+$/
    au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    au InsertLeave * match ExtraWhitespace /\s\+$/    
    au BufWinLeave * call clearmatches()
    
    " Remove extra whitespace with \rs
    nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

    " Highlight columns 81 and beyond
    let &colorcolumn=join(range(81,999),",")

    " Use shift-t to toggle vista sidebar
    nnoremap <silent> T :Vista!!<CR>

    " Activate display of current function in lightline
    au VimEnter * call vista#RunForNearestMethodOrFunction()

endfunction

" Return current function for display in lightline
function! LightlineCurrentFunctionVista() abort
    let l:fname = get(b:, 'vista_nearest_method_or_function', '')
    if l:fname != ''
        let l:fname = '[' . l:fname . ']'
    endif
    return l:fname
endfunction
