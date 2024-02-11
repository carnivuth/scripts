" PLUGINS
call plug#begin()

    " theme
    Plug 'dracula/vim', {'as':'dracula'}
    
    " icons
    Plug 'ryanoasis/vim-devicons'
    
    " snippets
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    
    " folder
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'

    " plugin for statusline
    Plug 'nvim-lualine/lualine.nvim'
    
    " If you want to have icons in your statusline choose one of these
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'preservim/nerdcommenter'
    Plug 'mhinz/vim-startify'
    
    " code completions
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
    
    " python notebooks plugin
    Plug 'luk400/vim-jukit' 

    " git plugin
    Plug 'tpope/vim-fugitive'
    
call plug#end()


