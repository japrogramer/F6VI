" Add this type definition to your vimrc
" or do
" coffeetags --vim-conf >> <PATH TO YOUR VIMRC>
" if you want your tags to include vars/objects do:
" coffeetags --vim-conf --include-vars
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
