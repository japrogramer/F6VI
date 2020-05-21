" Modeline and Notes {{
" vim: set foldmarker={{,}} foldlevel=0 foldmethod=marker :
"
"   This is the personal .vimrc file of Japrogramer
"
" }}

" Environment {{
    " Basics {{
    set nocompatible        " must be first line
    " Figure out the system Python for Neovim.
    if exists("$VIRTUAL_ENV")
        let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
    else
        let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
    endif
    " }}

    " Windows Compatible {{
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if has('win32') || has('win64')
      set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    endif
    " }}

    " Setup Bundle Support {{
    " auto-install vim-plug
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
      silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall
    endif
    " Specify a directory for plugins
    call plug#begin('~/.vim/plugged')

    Plug 'airblade/vim-gitgutter'
    "Plug 'altercation/vim-colors-solarized'
    Plug 'autozimu/LanguageClient-neovim' ", {'tag': 'binary-0.1.13-x86_64-unknown-linux-musl'}
    Plug 'bitc/lushtags'
    Plug 'carlitux/deoplete-ternjs',  { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'chriskempson/base16-vim'
    Plug 'dyng/ctrlsf.vim'
    Plug 'editorconfig/editorconfig-vim'
    "Plug 'edkolev/tmuxline.vim'
    "Plug 'edkolev/promptline.vim'
    Plug 'godlygeek/tabular'
    Plug 'honza/vim-snippets'
    Plug 'kchmck/vim-coffee-script'
    Plug 'kien/ctrlp.vim'
    Plug 'Lokaltog/vim-easymotion'
    Plug 'majutsushi/tagbar'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'mattn/emmet-vim'
    Plug 'mileszs/ack.vim'
    Plug 'Raimondi/delimitMate'
    Plug 'racer-rust/vim-racer'
    Plug 'rust-lang/rust.vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'scrooloose/nerdtree'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'SirVer/ultisnips'
    Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'tomtom/tlib_vim'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'ujihisa/neco-ghc'
    Plug 'vim-airline/vim-airline' " , { 'commit': '470e9870f13830580d1938a2dae1be5b6e43d92a' }
    Plug 'vim-airline/vim-airline-themes'
    Plug 'vim-syntastic/syntastic'
    Plug 'zchee/deoplete-jedi'

    " Initialize plugin system
    call plug#end()


    if filereadable(expand("~/.vimrc_background"))
        let base16colorspace=256
        source ~/.vimrc_background
    endif
    " }}
    " Use before config if available {{
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }}

" }}

" General {{

    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

    set background=dark         " Assume a dark background
    if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=c                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8
    set encoding=utf-8

    if has ('x') && has ('gui') " On Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui')          " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:F6VI_no_autochdir = 1
    if !exists('g:F6VI_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    "set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:F6VI_no_restore_cursor = 1
    if !exists('g:F6VI_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {{
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:F6VI_no_views = 1
        if !exists('g:F6VI_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }}

" }}

" Vim UI {{

    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="high"
        let g:solarized_visibility="high"
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line
    set cursorcolumn                " Highlight current column
    set synmaxcol=128
    set lazyredraw
    syntax sync minlines=256

    highlight clear SignColumn      " SignColumn should match background for
                                    " things like vim-gitgutter

    highlight clear LineNr          " Current line number row will have same background color in relative mode.
                                    " Things like vim-gitgutter will match LineNr highlight
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set rnu                         " Relative line number
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }}

" Formatting {{

    set nowrap                      " Wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>            " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/ " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType html setlocal foldmethod=syntax
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
    " play well with django
    autocmd BufNewFile,BufRead $ENV_DIR/*/*.py set filetype=python.django

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }}

" Key (re)Mappings {{

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.before.local file:
    "   let g:F6VI_leader='\'
    if !exists('g:F6VI_leader')
        let mapleader = ','
    else
        let mapleader=g:F6VI_leader
    endif

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:F6VI_no_easyWindows = 1
    if !exists('g:F6VI_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Faster navigation from normal to ex and from insert to normal mode
    nnoremap ; :
    imap ;; <Esc>
    " delete current line and return to insert mode
    inoremap <c-d> <Esc>ddi
    " file path completion
    inoremap <c-f> <c-x><c-f>

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:F6VI_no_fastTabs = 1
    if !exists('g:F6VI_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
    endif

    " Stupid shift key fixes
    if !exists('g:F6VI_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following to your .vimrc.before.local file:
    "   let g:F6VI_clear_search_highlight = 1
    if exists('g:F6VI_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif


    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

" }}

" Plugins {{

    " ternjs {{
    " Set bin if you have many instalations
    "let g:deoplete#sources#ternjs#tern_bin = '$(npm bin)/tern'
    let g:deoplete#sources#ternjs#timeout = 1

    " Whether to include the types of the completions in the result data. Default: 0
    let g:deoplete#sources#ternjs#types = 1

    " Whether to include the distance (in scopes for variables, in prototypes for 
    " properties) between the completions and the origin position in the result 
    " data. Default: 0
    let g:deoplete#sources#ternjs#depths = 1

    " Whether to include documentation strings (if found) in the result data.
    " Default: 0
    let g:deoplete#sources#ternjs#docs = 1

    " When on, only completions that match the current word at the given point will
    " be returned. Turn this off to get all results, so that you can filter on the 
    " client side. Default: 1
    let g:deoplete#sources#ternjs#filter = 0

    " Whether to use a case-insensitive compare between the current word and 
    " potential completions. Default 0
    let g:deoplete#sources#ternjs#case_insensitive = 1

    " When completing a property and no completions are found, Tern will use some 
    " heuristics to try and return some properties anyway. Set this to 0 to 
    " turn that off. Default: 1
    let g:deoplete#sources#ternjs#guess = 0

    " Determines whether the result set will be sorted. Default: 1
    let g:deoplete#sources#ternjs#sort = 0

    " When disabled, only the text before the given position is considered part of 
    " the word. When enabled (the default), the whole variable name that the cursor
    " is on will be included. Default: 1
    let g:deoplete#sources#ternjs#expand_word_forward = 0

    " Whether to ignore the properties of Object.prototype unless they have been 
    " spelled out by at least to characters. Default: 1
    let g:deoplete#sources#ternjs#omit_object_prototype = 0

    " Whether to include JavaScript keywords when completing something that is not 
    " a property. Default: 0
    let g:deoplete#sources#ternjs#include_keywords = 1

    " If completions should be returned when inside a literal. Default: 1
    let g:deoplete#sources#ternjs#in_literal = 0


    "Add extra filetypes
    let g:deoplete#sources#ternjs#filetypes = [
                    \ 'jsx',
                    \ 'javascript.jsx',
                    \ 'vue',
                    \ '...'
                    \ ]
    " Use tern_for_vim.
    let g:tern#command = ["tern"]
    let g:tern#arguments = ["--persistent"]
    "}}

    " backgroundcolor {{
    set background=dark         " Assume a dark background

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>
    "}}

    " ctrlp {{
        let g:ctrlp_map = '<Leader>t'
        nmap <Leader>b :CtrlPBuffer<CR>
        let g:ctrlp_working_path_mode = 0
        set wildignore+=*/.git/*,*/.hg/*,*/.svn/*  " Linux
    "}}

    " ctrlsf.vim {{
        nmap <Leader>s <Plug>CtrlSFPrompt
    "}}

    " Delimitmate {{
        au FileType * let b:delimitMate_autoclose = 1

        " If using html auto complete (complete closing tag)
        au FileType xml,html,xhtml let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
    " }}

    " deoplete {{
        " Use deoplete.
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#omni_patterns = {}
        let g:deoplete#omni_patterns.javascript = '[^. *\t]\.\w*'
        let g:deoplete#custom#var = {}
        let g:deoplete#custom#var.javascript = ['tern#Complete']
        set completeopt=longest,menuone,preview
        let g:deoplete#custom#option = {}
        let g:deoplete#custom#option['javascript.jsx'] = ['file', 'ternjs']
        " or just disable the preview entirely
        set completeopt-=preview
    " }}

    " EasyMotion {{
        let g:EasyMotion_keys = 'asdfgzxcvbqwert;lkjhyuiopnm'
        "let g:EasyMotion_do_shade = 1
        let g:EasyMotion_grouping = 2
        "hi EasyMotionTarget ctermbg=none ctermfg=#5B40BF
        "hi EasyMotionShade ctermbg=none ctermfg=blue
        "let g:EasyMotion_leader_key = '<Leader>'
        "let g:EasyMotion_mapping_f = '_f'
        "let g:EasyMotion_mapping_T = '<C-T>'
    "}}

    " Fugitive {{
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>:GitGutter<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        nnoremap <silent> <leader>gg :GitGutterToggle<CR>
    " }}

    " NerdTree {{
        map <C-d> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=2
        let NERDTreeQuitOnOpen=1
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
    " }}

" emmet {{
    let g:user_emmet_mode='a'    " Enable all function in all mode.
    "let g:user_emmet_install_global = 0
    autocmd FileType html,css,js EmmetInstall " Enable just for html/css
" }}

    " Tabularize {{
        "AddTabularPattern 1=    /^[^=]*\zs=
        "AddTabularPattern 1==   /^[^=]*\zs=/r0c0l0

        nmap <Leader>a& :Tabularize /&<CR>
        vmap <Leader>a& :Tabularize /&<CR>
        nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
        vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
        nmap <Leader>a=> :Tabularize /=><CR>
        vmap <Leader>a=> :Tabularize /=><CR>
        nmap <Leader>a: :Tabularize /:<CR>
        vmap <Leader>a: :Tabularize /:<CR>
        nmap <Leader>a:: :Tabularize /:\zs<CR>
        vmap <Leader>a:: :Tabularize /:\zs<CR>
        nmap <Leader>a, :Tabularize /,<CR>
        vmap <Leader>a, :Tabularize /,<CR>
        nmap <Leader>a,, :Tabularize /,\zs<CR>
        vmap <Leader>a,, :Tabularize /,\zs<CR>
        nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    " }}

    "Nerdcommenter {{
    "let g:NERDCustomDelimiters = {"\ 'haskell': { 'left': '{-', 'right': '-}',
        "'leftAlt': '{-|', 'rightAlt': '-}'}
        "\}
    " }}

    "  neco-ghc {{
        " for cabal bin "Directory"
        let $PATH=$PATH.":/home/japrogramer/.cabal/bin"
    "}}

    "  tagbar {{
       nnoremap <leader> <bar> :TagbarToggle<CR>
       if executable('coffeetags')
          let g:tagbar_type_coffee = {
                     \ 'ctagsbin' : 'coffeetags',
                     \ 'ctagsargs' : ' --include-vars ',
                     \ 'kinds' : [
                         \ 'f:functions:0',
                         \ 'o:objecs:1',
                     \ ],
                     \ 'sro' : ".",
                     \ 'kind2scope' : {
                         \ 'f' : 'functions',
                         \ 'o' : 'objecs',
                     \ }
                 \ }
      endif

    "}}

    " ultisnips {{
    let g:UltiSnipsExpandTrigger       = "<tab>"
    let g:UltiSnipsJumpForwardTrigger  = "<c-j>"
    let g:UltiSnipsJumpBackwardTrigger = "<c-p>"
    let g:UltiSnipsListSnippets        = "<c-k>" "List possible snippets based on current file
    " }}

    " rust.vim {{
        au FileType rust nmap gd <Plug>(rust-def)
        au FileType rust nmap gs <Plug>(rust-def-split)
        au FileType rust nmap gx <Plug>(rust-def-vertical)
        au FileType rust nmap <leader>gd <Plug>(rust-doc)
        let g:rustfmt_autosave = 1
    "}}

    " << LSP >> {{
        " a basic set up for LanguageClient-Neovim
        " if you want it to turn on automatically
        " let g:LanguageClient_autoStart = 1
        let g:LanguageClient_autoStart = 0
        nnoremap <leader>lcs :LanguageClientStart<CR>

        let g:LanguageClient_serverCommands = {
                    \ 'python': ['pyls'],
                    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
                    \ 'javascript': ['javascript-typescript-stdio'],
                    \ 'go': ['go-langserver'] }

        noremap <silent> <leader>H :call LanguageClient_textDocument_hover()<CR>
        noremap <silent> <leader>I :call LanguageClient_rustDocument_implementations()<CR>
        noremap <silent> <leader>Z :call LanguageClient_textDocument_definition()<CR>
        noremap <silent> <leader>R :call LanguageClient_textDocument_rename()<CR>
        noremap <silent> <leader>F :call LanguageClient_textDocument_formatting()<CR>
        noremap <silent> <leader>A :call LanguageClient_textDocument_codeAction()<CR>
    "}}

    " surround {{
        let b:surround_{char2nr("v")} = "{{ \r }}"
        let b:surround_{char2nr("{")} = "{{ \r }}"
        let b:surround_{char2nr("%")} = "{% \r %}"
        let b:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
        let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
        let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
        let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
        let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"
        let g:surround_{char2nr("C")} = "{# \r #}"
    " }}

" syntastic {{
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_aggregate_errors = 1

    let g:syntastic_python_checkers = ['flake8', 'pyflakes', 'pylint', 'python']
    let g:syntastic_python_flake8_args='--ignore=E501'
    let g:syntastic_javascript_checkers=['eslint']
    let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
    let g:syntastic_javascript_eslint_exec = '/bin/ls'
    let g:syntastic_javascript_eslint_args=['--cache']

    nmap <leader>sp :call <SID>SynStack()<CR>
    function! <SID>SynStack()
      if !exists("*synstack")
        return
      endif
      echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunc

    nmap [l :lprev<cr>
    nmap ]l :lnext<cr>
" }}

" }}

" GUI Settings {{
    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " remove the toolbar
        set guioptions-=m
        set guioptions-=b
        set guioptions-=l
        set guioptions-=L
        set guioptions-=r
        set lines=40                " 40 lines of text instead of 24,
    else
        "set term=builtin_ansi       " Make arrow and other keys work
    endif
" }}

" Functions {{

    " Initialize directories {{
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:F6VI_consolidated_directory = <full path to desired directory>
        "   eg: let g:F6VI_consolidated_directory = $HOME . '/.vim/'
        if exists('g:F6VI_consolidated_directory')
            let common_dir = g:F6VI_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }}

    " Initialize NERDTree as needed {{
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }}

    " Strip whitespace {{
    function! StripTrailingWhitespace()
        " To disable the stripping of whitespace, add the following to your
        " .vimrc.before.local file:
        "   let g:F6VI_keep_trailing_whitespace = 1
        if !exists('g:F6VI_keep_trailing_whitespace')
            " Preparation: save last search, and cursor position.
            let _s=@/
            let l = line(".")
            let c = col(".")
            " do the business:
            %s/\s\+$//e
            " clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endif
    endfunction
    " }}

" }}

" Use local vimrc if available {{
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }}
