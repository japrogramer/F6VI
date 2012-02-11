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
