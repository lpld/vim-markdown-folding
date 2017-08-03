" override folding of VimWiki
if &ft != 'vimwiki'
        finish
endif

setlocal foldexpr=GetMarkdownFold(v:lnum)
