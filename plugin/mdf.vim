" Find parent line (header)
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
        let nextLineHeaderLevel = 0
        if (a:lnum < line('$')) 
                let nextLineHeaderLevel = GetHeaderLevel(a:lnum + 1)
        endif
        let isNextHeader = nextLineHeaderLevel > 0
        let ln = FindParentLine(a:lnum)
        let isHeader = ln == a:lnum
        let currentLevel = GetHeaderLevel(ln)

        if isHeader
                return currentLevel
        elseif isNextHeader && nextLineHeaderLevel <= currentLevel
                return "<" . nextLineHeaderLevel
        else 
                return "="
        endif
endfunction

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
