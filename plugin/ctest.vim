autocmd Filetype cpp call Ctest()
autocmd Filetype output call TestfileSetting()
autocmd BufNewFile,BufRead *.in set filetype=input
autocmd BufNewFile,BufRead *.out set filetype=output

let s:fn = fnameescape(expand('%'))
let s:cmdtest = "python ctest.py"
let g:ctest_fnwoext = fnameescape(expand('%:t:r'))
let g:ctest_dirname = 'testcase'

command! Uva w| exec("!uva send " . str2nr(split(s:fn, "_")[0]))

function! Ctest()
    command! Rund w| exec("!clear && g++ -O2 -std=c++11 -DDEBUG " . s:fn . " && ./a.out")
    command! -nargs=1 Cin      w|call Cin(<f-args>)
    command! -nargs=1 Cout     w|call Cout(<f-args>)
    command! -nargs=1 Cinout   w|call Cinout(<f-args>)
    command! Ctest             w| exec("! " . s:cmdtest. " " . s:fn)
    command! Cdebug            w| exec("! " . s:cmdtest . " "  . s:fn . " debug")
    command! Cdiff             w| exec("!clear && " . s:cmdtest . " " . s:fn . " diff")
    command! Cdiffall          w| exec("!clear && " . s:cmdtest . " " . s:fn . " diff all")
    command! -nargs=1 Ccase    w| exec("!" . s:cmdtest . " " . s:fn . " diff case " . <f-args>)
    command! -nargs=1 Ccaseall w| exec("!" . s:cmdtest . " " . s:fn . " diff all case " . <f-args>)
endfunction

function! TestfileSetting()
    setl binary
    setl noeol
endfunction

function! ExistDir()
    if !isdirectory(g:ctest_dirname)
        call mkdir(g:ctest_dirname)
    endif
endfunction

function! Cin(number)
    call ExistDir()
    exec 'e '.g:ctest_dirname.'/'.g:ctest_fnwoext.'_'.a:number.'.in'
endfunction

function! Cout(number)
    call ExistDir()
    exec 'e '.g:ctest_dirname.'/'.g:ctest_fnwoext.'_'.a:number.'.out'
endfunction

function! Cinout(number)
    call Cin(a:number)
    exec 'bp'
    call Cout(a:number)
    exec 'bn'
    exec 'bn'
endfunction

