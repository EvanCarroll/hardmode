" hardmode.vim - Vim: HARD MODE!!!
" Authors:      Matt Parrott <parrott.matt@gmail.com>, Xeross <contact@xeross.me>, Evan Carroll <me@evancarroll.com>
" Version:      1.0

if exists('g:HardMode_loaded')
    finish
endif
let g:HardMode_loaded = 1

if !exists('g:HardMode_currentMode')
    let g:HardMode_currentMode = 'easy'
end

if !exists('g:HardMode_level')
    let g:HardMode_level = 'advanced'
end

if !exists('g:HardMode_echo')
    let g:HardMode_echo = 1
end

if !exists('g:HardMode_hardmodeMsg')
    let g:HardMode_hardmodeMsg = "VIM: Hard Mode [ ':call EasyMode()' to exit ]"
end
if !exists('g:HardMode_easymodeMsg')
    let g:HardMode_easymodeMsg = "You are weak..."
end

fun! HardModeEcho(message)
    " Some plugins create normal buffers and change their buftype later.
    " Disable hardmode in these buffers on the first key press.
    if !empty(&buftype)
        call s:Easy(1)
    else
        if g:HardMode_echo
            echo a:message
        end
    end
endfun

fun! s:SafeMap(keys, modes, enable)
    let l:nmodes = strlen(a:modes) - 1
    let l:i = 0
    while l:i < l:nmodes
        for l:key in a:keys
            if a:enable
                if maparg(l:key, a:modes[i]) =~ 'HardMode'
                    execute 'silent! '. a:modes[i] .'unmap <buffer> '. l:key
                endif
            else
                if empty(maparg(l:key, a:modes[i]))
                    execute a:modes[i] .'noremap <silent> <buffer> '. l:key .' <Esc>:call HardModeEcho(g:HardMode_hardmodeMsg)<CR>'
                endif
            endif
        endfor
        let l:i += 1
    endwhile
endfun

fun! Arrows(enable)

    call s:SafeMap(['<Left>', '<Right>', '<Up>', '<Down>', '<PageUp>', '<PageDown>'], 'niv', a:enable)

endfun

fun! Letters(enable)

    call s:SafeMap(['h', 'j', 'k', 'l', '-', '+', 'gj', 'gk'], 'nv', a:enable)

endfun

fun! Backspace(enable)

    "let l:bs = a:enable ? 'indent,eol,start' : 0
    "execute 'set backspace='. l:bs
    call s:SafeMap(['<BS>'], 'niv', a:enable)

endfun

fun! HardMode()
    call Arrows(0)
    if g:HardMode_level != 'wannabe'
        call Letters(0)
        call Backspace(0)
    end
    let g:HardMode_currentMode = 'hard'
    call HardModeEcho(g:HardMode_hardmodeMsg)
endfun

fun! EasyMode()
    call Arrows(1)
    call Letters(1)
    call Backspace(1)
    let g:HardMode_currentMode = 'easy'
    call HardModeEcho(g:HardMode_easymodeMsg)
endfun

fun! ToggleHardMode()
    if g:HardMode_currentMode == 'hard'
        call EasyMode()
    else
        call HardMode()
    end
endfun

augroup hardmode
    autocmd VimEnter,BufNewFile,BufReadPost * if exists('g:hardmode') && g:hardmode && empty(&buftype)|silent! call HardMode()|endif
augroup END

if !hasmapto('ToggleHardMode')
    nnoremap <leader>h <Esc>:call ToggleHardMode()<CR>
endif
