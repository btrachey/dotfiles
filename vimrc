" change leader to comma
" let mapleader = "'"
" general settings
"set relativenumber
"set number
"syntax on
"filetype on
"set shiftwidth=2
"set softtabstop=2
"set ignorecase smartcase
"set linebreak
"set showmatch
"set wrap!
"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
"highlight line and col of cursor
"set cuc cul
" toggle rainbow_parentheses
"nnoremap <leader>r :RainbowParentheses!!<cr>
" vim creates an undo file so that you can undo even after closing a file
"set undofile
" :qq to force quit
"cnoremap qq q!
" tab to match bracket pairs instead of %
"nnoremap <tab> %
"vnoremap <tab> %
" unmap % to force use of <tab>
"nnoremap % <Nop>
"vnoremap % <Nop>
" turn off number and relativenumber
"nnoremap <leader>n :set number! relativenumber!<cr>
" set path for searching for files
"set path=.,,**
" list buffers and start the go-to-buffer command
" nnoremap gb :ls<CR>:b<Space>
" set prefix to match tmux
"nnoremap <C-b> <C-w>
" move directly between splits
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l
" always show five lines ahead/before cursor
" if !&scrolloff
"   set scrolloff=5
" endif
" clear search highlight
"nnoremap <leader><space> :nohlsearch<cr>
" automatically add \v 'very magic' flag to searches
"nnoremap / /\v
"nnoremap ? ?\v
" highlight search
"set hlsearch
" highlight search results while typing
"set incsearch

" always display statusline
"set laststatus=2
" basic status line
" set statusline=%F                                                   " full path to file
" set statusline+=\ \-\                                               " ' - ' separator
" set statusline+=FileType:\ %y                                       " show vim detected filetype
" set statusline+=%=                                                  " switch to right side of statusline
" set statusline+=%l/%L                                               " current line / total lines

" function! TmuxMove(direction)
"         let wnr = winnr()
"         silent! execute 'wincmd ' . a:direction
"         " If the winnr is still the same after we moved, it is the last pane
"         if wnr == winnr()
"                 call system('tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR'))
"         end
" endfunction

" nnoremap <silent> <C-h> :call TmuxMove('h')<cr>
" nnoremap <silent> <C-j> :call TmuxMove('j')<cr>
" nnoremap <silent> <C-k> :call TmuxMove('k')<cr>
" nnoremap <silent> <C-l> :call TmuxMove('l')<cr>

" " status line highlight groups
" highlight GitSLHG ctermbg=22 
" highlight GitSLIHG ctermbg=237 ctermfg=22
" highlight FileDetailsSLHG ctermbg=54
" highlight FileDetailsSLIHG ctermbg=22 ctermfg=54
" highlight FileDetailsNoGitSLIHG ctermbg=237 ctermfg=54
" highlight FileLocationSLHG ctermbg=54
" highlight FileLocationSLIHG ctermbg=22 ctermfg=54
" highlight FileLocationNoGitSLIHG ctermbg=237 ctermfg=54
" highlight FileChangedSLHG ctermbg=52
" highlight FileChangedSLIHG ctermbg=54 ctermfg=52
" highlight NormalMode ctermbg=22
" highlight CommandMode ctermbg=88
" highlight InsertModeH ctermbg=58
" highlight VisualMode ctermbg=94
" highlight ReplaceMode ctermbg=26
" highlight NormalModeI ctermfg=22  ctermbg=54
" highlight CommandModeI ctermfg=88 ctermbg=54
" highlight InsertModeI ctermfg=58  ctermbg=54
" highlight VisualModeI ctermfg=94  ctermbg=54
" highlight ReplaceModeI ctermfg=26 ctermbg=54

" custom status line functions

"" helper function for getting the codes returned on 
"" mode changes; not used in actual statusline display
" function! InsertMode() abort
"   return getbufvar(expand('%'), '&insertmode-variable')
  " return get(v:, 'insertmode', {})
" endfunction

"" detect the vim mode and display name and matched highlight color
" function! ModeSegment() abort
"   let ModeDict = {
"         \  'n':      {'modename': 'NORMAL ', 'highlight': 'NormalMode',  'ihighlight': 'NormalModeI'},
"         \  'c':      {'modename': 'COMMAND', 'highlight': 'CommandMode', 'ihighlight': 'CommandModeI'},
"         \  'i':      {'modename': 'INSERT ', 'highlight': 'InsertModeH', 'ihighlight': 'InsertModeI'},
"         \  'v':      {'modename': 'VISUAL ', 'highlight': 'VisualMode',  'ihighlight': 'VisualModeI'},
"         \  'V':      {'modename': 'VLINE  ', 'highlight': 'VisualMode',  'ihighlight': 'VisualModeI'},
"         \  "\<C-v>": {'modename': 'VBLOCK ', 'highlight': 'VisualMode',  'ihighlight': 'VisualModeI'},
"         \  "R":      {'modename': 'REPLACE', 'highlight': 'ReplaceMode', 'ihighlight': 'ReplaceModeI'},
"         \}
"   let modechar = mode()
"   let modeinfo = get(ModeDict, modechar, {'modename':''})
"   if empty(modeinfo) | return '' | endif
"   if strchars(modeinfo['modename']) > 0
"     return '%#' . modeinfo['highlight'] . '# ' . modeinfo['modename'] . '%#' . modeinfo['ihighlight'] . '#▙ %*'
"   endif
" endfunction

"" file name and type
" function! FileDetails() abort
"   return '%#FileDetailsSLHG#%<%t - %y %#FileDetailsNoGitSLIHG#▛%*'
" endfunction

"" inspect the output of coc status and hide if it says 'Metals'
" function! CocStatus() abort
"   let metalsstring = get(g:, "coc_status", '')
"   if metalsstring =~? "metals"
"     return ''
"   else
"     return metalsstring
"   endif
" endfunction

"" get errors/warnings from coc and display in a custom fashion
" function! CocIssues() abort
"   let info = get(b:, 'coc_diagnostic_info', {})
"   if empty(info) | return '' | endif
"   let errors = get(info, 'error', 0)
"   let warnings = get(info, 'warning', 0)
"   let returnstring = ''
"   if warnings 
"     let returnstring.=' ' . warnings
"   endif
"   if errors
"     let returnstring.='  ' . errors
"   endif
"   return returnstring
" endfunction

"" get enclosing function from coc
" function! CocFunc() abort
"   let func = get(b:, 'coc_current_function', '')
"   if strchars(func) > 0
"     return func
"   else
"     return ''
"   endif
" endfunction

"" git in statusline
" function! GitStatus() abort
"   let gitbranchname = FugitiveHead()
"   if strchars(gitbranchname) > 0
"     return '%#GitSLIHG#▟%#GitSLHG#  ' . gitbranchname . ' %*'
"   else
"     return ''
"   endif
" endfunction

"" file location and percent
" function! FileLocation() abort
"   let gitstatus = GitStatus()
"   if strchars(gitstatus) > 0
"     let highlightstring = '%#FileLocationSLIHG#'
"   else
"     let highlightstring = '%#FileLocationNoGitSLIHG#'
"   endif
"   let basestring = '▜%#FileLocationSLHG#  %l/%L [%p%%] %*'
"   return highlightstring . basestring
" endfunction

"" detect if the file has been modified and display
"" a diamond character if so, along with a highlight 
" function! FileModified() abort
"   if getbufvar(expand('%'), '&mod') > 0
"     return '%#FileChangedSLIHG#▟%#FileChangedSLHG# ⧫ %*'
"   else
"     return ''
"   endif
" endfunction

" function! NvimMetalsStatus() abort
"   let stat = get(g:, 'metals_status', '')
"   if strchars(stat) > 0
"     return stat
"   else
"     return ''
"   endif
" endfunction

" function! DAPStatus() abort
"   let stat = luaeval('require("dap").status()')
"   if strchars(stat) > 0
"     return stat
"   else
"     return ''
"   endif
" endfunction

" better status line 
" set statusline=%{%ModeSegment()%}    " mode with highlight color
" set statusline+=%{%FileDetails()%}   " path to file - filetype
" set statusline+=%=                   " add auto spaced group
" set statusline+=%{CocStatus()}       " coc-metals statuses in statusline
" set statusline+=%{NvimMetalsStatus()} " nvim-metals statuses in statusline
" set statusline+=%{DAPStatus()}       " nvim-dap statuses in statusline
" set statusline+=%=                   " add auto spaced group
" set statusline+=%{CocFunc()}         " displays name of enclosing function
" set statusline+=%=                   " add auto spaced group
" set statusline+=%{CocIssues()}       " coc-metals errors/warnings
" set statusline+=%=                   " add auto spaced group
" set statusline+=%{%GitStatus()%}     " vim-fugitive git branch name 
" set statusline+=%{%FileLocation()%}  " line num/total lines [percent through file]
" set statusline+=%{%FileModified()%}  " marker for if a file is modified

" switch H and L to go to beginning/end of line
" nnoremap H 0
" nnoremap L $
" copy to system clipboard all the time
" set clipboard=unnamed
" jk exits insert/command mode
"inoremap jk <Esc>
"cnoremap jk <Esc>
"vnoremap jk <Esc>
" ;v to split vertically, ;h to split horizontally
" nnoremap ;v :vsplit<cr>
" nnoremap ;h :split<cr>
" highligh cursor line on insert enter, stop highlighting on insert leave
" augroup line_highlight
"   autocmd!
"   autocmd InsertEnter,InsertLeave * set cul! cuc!
" augroup END
" custom commands to open files in bitbucket
" python version of opening bitbucket url
" command BB exe "! /Users/brian.tracey/protenus/workspace/my-scripts/_bitbucket_url %:p"
" command BL exe "! /Users/brian.tracey/protenus/workspace/my-scripts/_bitbucket_url %:p " . line(".")
" scala/ammonite version of opening bitbucket url
" command BB exe "! /Users/brian.tracey/protenus/workspace/my-scripts/open_in_bitbucket.sc %:p"
" command BL exe "! /Users/brian.tracey/protenus/workspace/my-scripts/open_in_bitbucket.sc %:p " . line(".")
" set cursor shape on insert/cmd mode
" insert mode
" let &t_SI = "\e[5 q"
" normal mode
" let &t_EI = "\e[2 q"
" replace mode
" let &t_SR = "\e[3 q"
" augroup myCmds
"   au!
"   autocmd VimEnter * silent !echo -ne "\e[2 q"
"   autocmd VimEnter * redraw!
" augroup END
"" TODO remove if built in folding from LSPs is working fine
""" set folds based on { and } for hocon
" augroup hocon_folding
"   autocmd!
"   autocmd FileType hocon set foldmethod=marker
"   autocmd FileType hocon set foldmarker={,}
"   autocmd BufNewFile,BufRead,BufEnter * :normal zR
" augroup END
""" run coc fold for every scala file
" augroup scala_folding
"   autocmd!
"   autocmd FileType scala :Fold
"  autocmd FileType scala :normal zR
" augroup END
""" set folds to indent for python
" augroup python_folding
"   autocmd!
"   autocmd FileType python set foldmethod=indent
"   autocmd BufNewFile,BufRead,BufEnter * :normal zR
" augroup END
" toggle fold with spacebar
" nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" create a fold of visual selection
" vnoremap <Space> zf

" recognize jenkinsfile as groovy
" augroup jenkinsfile
"   autocmd BufNewFile,BufRead,BufEnter Jenkinsfile* setf groovy
" augroup END

" function! WrapForTmux(s)
"   if !exists('$TMUX')
"     return a:s
"   endif

"   let tmux_start = "\<Esc>Ptmux;"
"   let tmux_end = "\<Esc>\\"

"   return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
" endfunction

" " insert mode - vertical bar cursor
" let &t_SI = WrapForTmux("\<Esc>]50;CursorShape=1\x7")
" " normal mode - block cursor
" let &t_EI = WrapForTmux("\<Esc>]50;CursorShape=0\x7")
" " replace mode - underline cursor
" let &t_SR = WrapForTmux("\<Esc>]50;CursorShape=2\x7")

" auto enter/exit paste mode to prevent auto indenting when pasting
" function! XTermPasteBegin()
"   set pastetoggle=<Esc>[201~
"   set paste
"   return ""
" endfunction

" inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" coc.nvim lsp mappings
" if filereadable(expand("~/.coc-mappings.vim"))
"   source ~/.coc-mappings.vim"
" endif

" extras for LilyPond format files
filetype off
set runtimepath+=/opt/homebrew/Cellar/lilypond/2.24.0_1/share/lilypond/2.24.0/vim
filetype on
syntax on
