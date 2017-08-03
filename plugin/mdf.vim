" Find parent header line, that this line 'belongs to'
function! FindParentLine(lnum)
        let ln = a:lnum
        while !IsLineHeader(ln) && ln > 1
                let ln -= 1
        endwhile
        return ln
endfunction

" Check if specified line is a header, i.e starts with #
function! IsLineHeader(lnum)
        return getline(a:lnum) =~ '^#' && !IsInPreBlock(a:lnum)
endfunction

" Check if the line is inside a Pre block. 
function! IsInPreBlock(lnum)
        let qbs = 0
        let i = 1
        while i < a:lnum
                if getline(i) =~ '^```'
                        let qbs += 1
                endif
                let i += 1
        endwhile
        return qbs % 2 == 1
endfunction

function! GetMarkdownFold(lnum)
        " looking if next line is a header
        let nextLineHeaderLevel = 0
        if (a:lnum < line('$')) 
                let nextLineHeaderLevel = GetHeaderLevel(a:lnum + 1)
        endif
        let isNextHeader = nextLineHeaderLevel > 0

        " searching for parent line
        let ln = FindParentLine(a:lnum)
        let isHeader = ln == a:lnum
        let currentLevel = GetHeaderLevel(ln)

        if isHeader
                " if this line is a header, then we just return its level
                return currentLevel
        elseif isNextHeader && nextLineHeaderLevel <= currentLevel
                " if next line is a header with level less than or equal to current level,
                " (i.e. this line is the end of folding level),
                " then we finish the level
                return "<" . nextLineHeaderLevel
        else 
                " otherwise just leave it as is
                return "="
        endif
endfunction

" Get level of header line (i.e. 1, 2, etc.). If the line is not header, will
" return 0
function! GetHeaderLevel(lnum)
        let h = 0
        if IsLineHeader(a:lnum)
                 for ch in split(getline(a:lnum), '\zs')
                         if (ch == '#')
                                 let h += 1
                         else
                                 break
                         endfor
                 endfor
        endif
        return h
endfunction
