" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker :
" 
"   This is the personal .vimrc file of Japrogramer
"
" }

" Environment {
    " Basics {
        set nocompatible        " must be first line
        set background=dark     " Assume a dark background
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier. 
        if has('win32') || has('win64')
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
    " 
    " Setup Bundle Support {
    " The next two lines ensure that the ~/.vim/bundle/ system works
        runtime! bundle/vim-pathogen/autoload/pathogen.vim
        silent! call pathogen#helptags()
        silent! call pathogen#runtime_append_all_bundles()
    " }

" }

" General {
    set background=dark         " Assume a dark background
    if !has('win32') && !has('win64')
        set term=$TERM       " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " syntax highlighting
    set mouse=a                 " automatically enable mouse usage
    "set autochdir              " always switch to the current file directory.. Messes with some plugins, best left commented out
    " not every vim is compiled with this, use the following line instead
    " If you use command-t plugin, it conflicts with this, comment it out.
     "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    scriptencoding utf-8

    " set autowrite                  " automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    set history=1000                " Store a ton of history (default is 20)
    set spell                       " spell checking on
    
    " Setting up the directories {
        set backup                      " backups are nice ...
        set undofile                    " so is persistent undo ...
        set undolevels=1000 "maximum number of changes that can be undone
        set undoreload=10000 "maximum number lines to save for undo on a buffer reload
        " Moved to function at bottom of the file
        "set backupdir=$HOME/.vimbackup//  " but not when they clog .
        "set directory=$HOME/.vimswap//     " Same for swap files
        "set viewdir=$HOME/.vimviews//  " same for view files
        
        "" Creating directories if they don't exist
        "silent execute '!mkdir -p $HVOME/.vimbackup'
        "silent execute '!mkdir -p $HOME/.vimswap'
        "silent execute '!mkdir -p $HOME/.vimviews'
        au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
        au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
    " }
" }

" Vim UI {
    color molokai                   " load a colorscheme
    set tabpagemax=15               " only show 15 tabs
    set showmode                    " display the current mode

    set cursorline                  " highlight current line
    set cursorcolumn                " highlight current line
    hi cursorline guibg=#333333     " highlight bg color of current line
    hi CursorColumn guibg=#333333   " highlight cursor

    if has('cmdline_info')
        set ruler                   " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
                                    " selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\    " Filename
        set statusline+=%w%h%m%r " Options
        set statusline+=%{fugitive#statusline()} "  Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " filetype
        set statusline+=\ [%{getcwd()}]          " current dir
        "set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " backspace for dummys
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " show matching brackets/parenthesis
    set incsearch                   " find as you type search
    set hlsearch                    " highlight search terms
    set winminheight=0              " windows can be 0 line high 
    set ignorecase                  " case insensitive search
    set smartcase                   " case sensitive when uc present
    set smartindent                 " context sensitive indenting
    set wildmenu                    " show list instead of just completing
    set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
    set scrolljump=5                " lines to scroll when cursor leaves screen
    set scrolloff=3                 " minimum lines to keep above and below cursor
    set foldenable                  " auto fold code
    set gdefault                    " the /g flag on :s substitutions by default
    set list
    set listchars=tab:>.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace


" }

" Formatting {
    set nowrap                      " wrap long lines
    set autoindent                  " indent at the same level of the previous line
    set shiftwidth=4                " use indents of 4 spaces
    set tabstop=4                   " an indentation every four columns
    set softtabstop=4               " let backspace delete indent
    set expandtab                   " tabs are spaces, not tabs
    "set matchpairs+=<:>                " match, to be used with % 
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" }

" Key (re)Mappings {

    "The default leader is '\', but many people prefer ',' as it's in a standard
    "location
    let mapleader = ','

    " Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
    nnoremap ; :
    "quick escape
    imap ;; <Esc>

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_
    
    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk
    nnoremap <M-j> <C-f>
    nnoremap <M-k> <C-b>

    " The following two lines conflict with moving to top and bottom of the
    " screen
    " If you prefer that functionality, comment them out.
    map <S-H> gT          
    map <S-L> gt

    " Stupid shift key fixes
    cmap W w                        
    cmap WQ wq
    cmap wQ wq
    cmap Q q
    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$
        
    """ Code folding options
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

    "clearing highlighted search
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv 

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0
        
    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null
" }

" Plugins {

        " for cabal bin "Directory"
        let $PATH=$PATH.":/home/japrogramer/.cabal/bin"
    " Command-t {
        "let g:CommandTSearchPath = $HOME . '/Code'
        "nnoremap <silent> <Leader>t :CommandT<CR>
        "nnoremap <silent> <Leader>b :CommandTBuffer<CR>
    " }
    " Delimitmate {
        au FileType * let b:delimitMate_autoclose = 1

        " If using html auto complete (complete closing tag)
        au FileType xml,html,xhtml let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
    " }
" EasyMotion {
    "let g:EasyMotion_keys = '1234567890'
    "let g:EasyMotion_do_shade = 0
    "let g:EasyMotion_leader_key = '<Leader>'
    "let g:EasyMotion_mapping_f = '_f'
    "let g:EasyMotion_mapping_T = '<C-T>'
"}
    " headlights {
        let g:headlights_use_plugin_menu = 0
        "Default value: 0
        "Create menus for bundle script files: >
        let g:headlights_show_files = 0
        "Default value: 0
        "Create menus for bundle commands: >
        let g:headlights_show_commands = 1
        "Default value: 1
        "Create menus for bundle mappings: >
        let g:headlights_show_mappings = 1
        "Default value: 1
        "Create menus for bundle abbreviations: >
        let g:headlights_show_abbreviations = 0
        "Default value: 0
        "Create menus for global bundle functions: >
        let g:headlights_show_functions = 0
        "Default value: 0
        "Create menus for bundle highlights: >
        let g:headlights_show_highlights = 0
        "Default value: 0
        "Create menus for load order of plugin files: >
        let g:headlights_show_load_order = 0
        "Default value: 0
        "Group bundles that share the same root together: >
        let g:headlights_smart_menus = 1
        "Default value: 1
        "Enable debug mode and create menus to access the log file: >
        let g:headlights_debug_mode = 0
        "Default value: 0 (1 in the event of a Headlights exception)
    " }
    " NerdTree {
        map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
    " }
    " Neocomplete {
        autocmd FileType python set omnifunc=pythoncomplete#Complete
        autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
        autocmd FileType css set omnifunc=csscomplete#CompleteCSS
        autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
        autocmd FileType php set omnifunc=phpcomplete#CompletePHP
        autocmd FileType c set omnifunc=ccomplete#Complete
        let g:neocomplcache_enable_at_startup = 1
        " Recommended key-mappings.
        inoremap <expr><CR>  neocomplcache#close_popup()."\<CR>"
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        " SuperTab like snippets behavior.
        "inoremap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
        inoremap <expr><C-y>  neocomplcache#close_popup()
        inoremap <expr><C-e>  neocomplcache#cancel_popup()
        if !exists('g:neocomplcache_omni_patterns')
            let g:neocomplcache_omni_patterns = {}
        endif
    " }
    "  neco-ghc {
        "let $PATH=$PATH."/home/japrogramer/.cabal/bin"
        "p..................................sld;..
    "}
    "  tagbar {
       nnoremap <silent> <F12> :TagbarToggle<CR>
    "}
    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Steve Francia <steve.francia@gmail.com>'
        " Shortcut for reloading snippets, useful when developing
        nnoremap ,smr <esc>:exec ReloadAllSnippets()<cr>
    " }
    " sparkup {
        "function! SparkKey()
            "ru ftplugin/html/sparkup.vim
            let g:sparkup = 'sparkup'
            "if !exists('g:sparkupArgs')
                let g:sparkupArgs  = '--no-last-newline'
            "endif
            if !exists('g:sparkupExecuteMapping')
                let g:sparkupExecuteMapping = '<c-s>'
            endif
            "if !exists('g:sparkupNextMapping')
                let g:sparkupNextMapping = '<c-t>'
            "endif
        "endfunction
        "au FileType html call SparkKey()
    " }

" }

" GUI Settings {
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
        set term=builtin_ansi       " Make arrow and other keys work
    endif
" }

function! InitializeDirectories()
  let separator = "."
  let parent = $HOME 
  let prefix = '.vim'
  let dir_list = { 
              \ 'backup': 'backupdir', 
              \ 'views': 'viewdir', 
              \ 'swap': 'directory', 
              \ 'undo': 'undodir' }

  for [dirname, settingname] in items(dir_list)
      let directory = parent . '/' . prefix . dirname . "/"
      if exists("*mkdir")
          if !isdirectory(directory)
              call mkdir(directory)
          endif
      endif
      if !isdirectory(directory)
          echo "Warning: Unable to create backup directory: " . directory
          echo "Try: mkdir -p " . directory
      else  
          let directory = substitute(directory, " ", "\\\\ ", "")
          exec "set " . settingname . "=" . directory
      endif
  endfor
endfunction
call InitializeDirectories() 

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

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }
