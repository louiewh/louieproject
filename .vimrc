""""""""""""""""""""""""""""""""""""""""""""""""""""""
"louie VIM 的配置文件             
"
"Change date: 2014.05.15      
"
"Email  louie.wang.g@gmail.com      
"""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""Common Setting""""""""""""
syn on                                           "语法高亮 
set helplang=cn                                  "使用中文帮助文档
set backspace=2
set tabstop=4                                    "制表符的宽度
set expandtab
set softtabstop=4
set shiftwidth=4                                 "缩进的空格
set autoindent                                   "自动缩进
set cindent                                      "C 插件
set number                                       "设置行号
set ignorecase                                   "忽略大小写 （查找字符串时）
set nohlsearch                                   "高亮显示 （查找字符串是，找到后高亮显示）
set mouse=a                                      "使用鼠标
set ruler                                        "在右下角显示光标位置
set showcmd                                      "显示未敲完的命令
set cmdheight=1                                  "设定命令行的行数为 1
set laststatus=2                                 "显示状态栏 (默认值为 1, 无法显示状态栏)
set incsearch                                    "在输入搜索的字符串同时就开始搜索已经输入的部分
set nowrap                                       "一行就一行，别弄到第二行去
set sidescroll=10                                "屏幕放不下时，按一次屏幕移动一个字符  
set whichwrap=b,s,<,>,[,]                        "跨行移动
set fileformats=unix,dos
set cursorline                                   "突出显示当前行
set showmatch                                    "插入括号时，短暂地跳转到匹配的对应括号
set matchtime=2                                  "短暂跳转到匹配括号的时间
set smartindent                                  "开启新行时使用智能自动缩进
filetype plugin on                               "自动识别文件类型，用文件类型plugin脚本，使用缩进定义文件
"set autochdir                                   "自动切换当前目录为当前文件所在的目录

"粘贴复制的一些操作
vmap <C-c> "+y                                   "选中状态下 Ctrl+c 复制
nmap <C-c> "+yy                                  "选中状态下 Ctrl+c 复制
nmap <C-v> "+p                                   "正常模式下粘贴
nmap <C-a> ggvG                                  "正常模式下全选
vmap <C-x> dd<Esc>                               "正常模式下DEL

nmap <leader>s :call SaveFile()<CR> 
imap <leader>s <ESC>:call SaveFile()<CR> 
vmap <leader>s <ESC>:call SaveFile()<CR> 
func! SaveFile()     
     exec "w" 
endfunc  

"set pastetoggle=<F4>
"set clipboard+=unnamed                           "与windows共享剪贴板 
"source $VIMRUNTIME/mswin.vim  
"behave mswin                                     "兼容windows下的快捷键  
"set selection=exclusive                          "使用鼠标（类似office中 ->  
"set selectmode=mouse,key                         "在工作区双击鼠标定位）  
"
"=========================GUI setting========================
if has("gui_running") 
    set guioptions-=m " 隐藏菜单栏 
    set guioptions-=T " 隐藏工具栏 
    set guioptions-=L " 隐藏左侧滚动条 
    set guioptions-=r " 隐藏右侧滚动条 
    set guioptions-=b " 隐藏底部滚动条 
    set showtabline=0 " 隐藏Tab栏 
    set guifont=Consolas:h12
    "set guifontwide=Microsoft\ Yahei:h12
    "colorscheme desert
endif 


"记忆上次打开文件的位置
if has("autocmd")
    autocmd BufRead *.txt set tw=78
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" |
endif

autocmd BufWritePre * :%s/\s+\+$//e
autocmd BufWritePre *.java  :%retab!
set autochdir
set tags=tags;

set whichwrap+=<,>,h,l                                                                             "允许backspace和光标键跨越行边界   
set fileencodings=ucs-bom,utf-8,GB18030,GBK,GB2312                                                 "字符编码支持中文
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\           "设置在状态行显示的信息


" 在不同的窗口移动
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:iswindows=1
else
    let g:iswindows=0
endif
autocmd BufEnter * lcd %:p:h
map <F10> :call Do_CsTag()<CR>
"nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
"nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
"nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
"nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
"nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
"nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
"nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function! Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
   if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        "silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        let cmd="!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ".dir
        execute cmd
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find $PWD -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

"============================NERDTree.vim=========================
nmap <F2> :NERDTreeToggle<cr>
let NERDChristmasTree=1
let g:NERDTreeWinPos="left"
let g:NERDTreeWinSize=25
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeQuitOnOpen=0
let g:NERDTree_title="[NERDTree]"  
  
function! NERDTree_Start()  
    exec 'NERDTree'  
endfunction  
  
function! NERDTree_IsValid()  
    return 1  
endfunction
"============================END NERDTree.vim=========================


"============================TagBar.vim=========================
"nnoremap <F12> :TagbarToggle<CR>
"autocmd FileType c,cpp nested :TagbarOpen

"nmap <Leader>wm :TagbarToggle<CR>
nnoremap wm :TagbarToggle<CR>
let g:tagbar_width=30
autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx call tagbar#autoopen()
"============================END TagBar.vim=========================


"""""""""""""""""""""""""""ctrlp"""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_by_filename = 0
let g:ctrlp_open_multiple_files = 'v'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_linkse',
  \ }
"""""""""""""""""""""END ctrlp"""""""""""""""""""""""""""""



""""""""""""""""""""""""""""YCM"""""""""""""""""""""""""""""""
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>                          "按jd 会跳转到定义
"nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>                          "按jd 会跳转到定义
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'   "配置默认的ycm_extra_conf.py
let g:ycm_confirm_extra_conf=0                                                               "打开vim时不再询问是否加载ycm_extra_conf.py配置
let g:ycm_collect_identifiers_from_tag_files = 1                                             "使用ctags生成的tags文件

""""""""""""""""""""""""""""END YCM"""""""""""""""""""""""""""""""


let g:nodejs_complete_config = {
            \  'js_compl_fn': 'jscomplete#CompleteJS',
            \  'max_node_compl_len': 15
            \}


filetype plugin on   
autocmd FileType python set omnifunc=pythoncomplete#Complete   
let g:pydiction_location = '~/.vim/bundle/Pydiction/complete-dict'
"""""""""""""""""""""""""""""""""""VUNDLE setting"""""""""""""""""""""""""""""""""""""""""""
map <silent> <F7> :!git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
set nocompatible               " be iMproved
filetype off                   " required!
    set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

    " let Vundle manage Vundle
    Bundle 'gmarik/vundle'

    " vim-scripts repos
    "Bundle 'minibufexpl.vim'
    "Bundle 'bufexplorer.zip'
    "Bundle 'taglist.vim'
    "Bundle 'c.vim'
    "Bundle 'winmanager'
    "Bundle 'The-NERD-Commenter'
    "Bundle 'snipMate'
    "Bundle 'TxtBrowser'
    "Bundle 'genutils'
    "Bundle 'lookupfile'
    "Bundle 'LeaderF'
    Bundle 'The-NERD-tree'
    "Bundle 'ctrlp.vim'
    "Bundle 'cscope.vim'
    "Bundle 'Tagbar'

    "github repos.
    "Bundle 'fholgado/minibufexpl.vim'
    "Bundle 'bling/vim-airline'
    "Bundle 'tpope/vim-fugitive'
    "Bundle 'Shougo/neocomplcache.vim'
    "Bundle 'ervandew/supertab'
    "Bundle 'simplyzhao/cscope_maps.vim'
    Bundle 'vim-scripts/EasyGrep'
    Bundle 'kien/ctrlp.vim'
    Bundle 'majutsushi/tagbar'
    Bundle 'brookhong/cscope.vim'
    Bundle 'scrooloose/nerdtree'
    Bundle 'moll/vim-node'
    Bundle 'jelera/vim-javascript-syntax'
    Bundle 'ahayman/vim-nodejs-complete'
    Bundle 'marijnh/tern_for_vim'
    Bundle 'hdima/python-syntax'
    Bundle 'vim-scripts/Pydiction'
    "Plugin 'Valloric/YouCompleteMe'
    "file repos or git repos
    "Bundle 'git://git.wincent.com/command-t.git'
    "Bundle 'https://github.com/Lokaltog/powerline'

    filetype plugin indent on     " required!

    "
    " Brief help
    " :BundleList          - list configured bundles
    " :BundleInstall(!)    - install(update) bundles
    " :BundleSearch(!) foo - search(or refresh cache first) for foo
    " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
    "
    " see :h vundle for more details or wiki for FAQ
    " NOTE: comments after Bundle command are not allowed..

""""""""""""""""""""""""END VUNDLE""""""""""""""""""""""""""    
"
