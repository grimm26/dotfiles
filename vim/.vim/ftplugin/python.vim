setlocal nosmartindent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=88
setlocal smarttab
setlocal expandtab
autocmd BufWritePre *.py execute ':Black'
