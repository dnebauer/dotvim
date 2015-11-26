"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

" For developing
let s:file = expand('<sfile>')
execute 'nnoremap <leader>as :so ' . s:file . '<cr>:call statusline#init()<cr>'
execute 'nnoremap <leader>ae :ed ' . s:file . '<cr>'

function! statusline#init() " {{{1
  augroup statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter   * call statusline#refresh()
    autocmd FileType,VimResized             * call statusline#refresh()
    autocmd BufHidden,BufWinLeave,BufUnload * call statusline#refresh()
  augroup END

  highlight StatusLine   ctermfg=10 ctermbg=15  guifg=#657b83 guibg=#eee8d5
  highlight StatusLineNC ctermfg=10 ctermbg=8   guifg=#839496 guibg=#eee8d5
  highlight SLHighlight  ctermbg=10 ctermfg=220 guibg=#657b83 guifg=#ffe055
  highlight SLAlert      ctermbg=10 ctermfg=202 guibg=#657b83 guifg=#ff8888
endfunction

" }}}1
function! statusline#refresh() " {{{1
  for nr in range(1, winnr('$'))
    if !s:ignored(nr)
      call setwinvar(nr, '&statusline', '%!statusline#main(' . nr . ')')
    endif
  endfor
endfunction

"}}}1
function! statusline#main(winnr) " {{{1
  let l:winnr = winbufnr(a:winnr) == -1 ? 1 : a:winnr
  let l:active = l:winnr == winnr()
  let l:bufnr = winbufnr(l:winnr)
  let l:buftype = getbufvar(l:bufnr, '&buftype')
  let l:filetype = getbufvar(l:bufnr, '&filetype')

  if l:buftype ==# 'help'
    return s:help(l:bufnr, l:active)
  elseif l:filetype ==# 'unite'
    return s:unite(l:bufnr, l:active)
  elseif l:filetype ==# 'vimwiki'
    return s:wiki(l:bufnr, l:active)
  else
    return s:main(l:bufnr, l:active)
  endif
endfunction

" }}}1

"
" Main statusline funcs
"
function! s:main(bufnr, active) " {{{1
  let stat  = s:color(' %<%f', 'SLHighlight', a:active)
  let stat .= getbufvar(a:bufnr, '&modifiable')
        \ ? '' : s:color(' [Locked]', 'SLAlert', a:active)
  let stat .= getbufvar(a:bufnr, '&readonly')
        \ ? s:color(' [‼]', 'SLAlert', a:active) : ''
  let stat .= getbufvar(a:bufnr, '&modified')
        \ ? s:color(' [+]', 'SLAlert', a:active) : ''

  let stat .= '%='

  let stat .= fugitive#head(12)
  let stat .= ' '

  return stat
endfunction

" }}}1
function! s:help(bufnr, active) " {{{1
  let l:name = bufname(a:bufnr)
  return s:color(' ' . fnamemodify(l:name, ':t:r') . ' %= HELP ',
        \ 'SLHighlight', a:active)
endfunction

" }}}1
function! s:unite(bufnr, active) " {{{1
  let stat  = s:color(' Unite', 'SLAlert', a:active)
  let stat .= ' -- '

  " Source info
  for l:source in unite#loaded_sources_list()
    " Source name
    let stat .= s:color(unite#helper#convert_source_name(l:source.name),
          \ 'SLHighlight', a:active)

    " Number of (visible) candidates
    let stat .= ' (' . l:source.unite__len_candidates
    if l:source.unite__orig_len_candidates != l:source.unite__len_candidates
      let stat .= '/' . l:source.unite__orig_len_candidates
    endif
    let stat .= ') '
  endfor

  if !exists('b:unite') | return stat | endif
  let stat .= '%='

  let l:msgs = get(b:unite.msgs, 0, '')
  if l:msgs !=# ''
    let l:msgs = substitute(l:msgs, '^\[.\{-}\]\s*', '', '')
    let l:msgs = substitute(l:msgs, 'directory', 'path', '')
  endif

  let stat .= b:unite.context.path !=# ''
        \ ? '[' . b:unite.context.path . ']'
        \ : (b:unite.is_async || msgs ==# '') ? '' : msgs

  return stat . ' '
endfunction

" }}}1
function! s:wiki(bufnr, active) " {{{1
  let stat  = s:color(' Vimwiki: ', 'SLAlert', a:active)
  let stat .= s:color(fnamemodify(bufname(a:bufnr), ':t:r'),
        \ 'SLHighlight', a:active)
  let stat .= getbufvar(a:bufnr, '&modifiable')
        \ ? '' : s:color(' [Locked]', 'SLAlert', a:active)
  let stat .= getbufvar(a:bufnr, '&readonly')
        \ ? s:color(' [‼]', 'SLAlert', a:active) : ''
  let stat .= getbufvar(a:bufnr, '&modified')
        \ ? s:color(' [+]', 'SLAlert', a:active) : ''
  return stat
endfunction

" }}}1

"
" Tabline
"
function! statusline#init_tabline() " {{{1
  set tabline=%!statusline#get_tabline()
  highlight TabLine
        \ cterm=none ctermbg=12 ctermfg=8
        \ gui=none guibg=#657b83 guifg=#eee8d5 guisp=#657b83
  highlight TabLineSel
        \ cterm=none ctermbg=12 ctermfg=15
        \ gui=none guibg=#657b83 guifg=#ffe055 guisp=#657b83
  highlight TabLineFill
        \ cterm=none ctermbg=12 ctermfg=8
        \ gui=none guibg=#657b83 guifg=#eee8d5 guisp=#657b83
endfunction

" }}}1
function! statusline#get_tabline() " {{{1
  let s = ' '
  for i in range(1, tabpagenr('$'))
    let s .= s:color('%{statusline#get_tablabel(' . i . ')} ',
          \ 'TabLineSel', i == tabpagenr())
  endfor

  return s
endfunction

" }}}1
function! statusline#get_tablabel(n) " {{{1
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)

  let name = bufname(buflist[winnr - 1])
  if name !=# ''
    let label = fnamemodify(name, ':t')
  else
    let type = getbufvar(buflist[winnr - 1], '&buftype')
    if type !=# ''
      let label = '[' . type . ']'
    else
      let label = '[No Name]'
    endif
  endif

  return printf('%1s %-15s', a:n, label)
endfunction

" }}}1

"
" Utilities
"
function! s:color(content, group, active) " {{{1
  if a:active
    return '%#' . a:group . '#' . a:content . '%*'
  else
    return a:content
  endif
endfunction

" }}}1
function! s:ignored(winnr) " {{{1
  let l:name = bufname(winbufnr(a:winnr))

  if l:name =~# '^\%(undotree\|diffpanel\)'
    return 1
  endif

  return 0
endfunction

" }}}1
