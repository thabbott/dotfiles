call plug#begin('~/.vim/plugged')

" configurations for LSP client
Plug 'neovim/nvim-lspconfig'

" colorscheme
Plug 'arcticicestudio/nord-vim'

call plug#end()

" LSP setup 
lua << EOF
require'lspconfig'.julials.setup{}
EOF

" LSP shortcuts
nnoremap <silent> lh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> l[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> l] <cmd>lua vim.diagnostic.goto_next()<CR>

set termguicolors
colorscheme nord
