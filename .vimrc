""""""""""""""""""""""""""""""""""""""""""""""""""""""
"louie VIM 的配置文件             
"
"Change date: 2014.05.15      
"
"Email  louie.wang.g@gmail.com      
"""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""Common Setting""""""""""""
syn on                                           "语法高亮 
set helplang=cn	                                 "使用中文帮助文档
set backspace=2
set tabstop=4                                    "制表符的宽度
set softtabstop=4
set shiftwidth=4                                 "缩进的空格
set autoindent	                                 "自动缩进
set cindent                                      "C 插件
set number                                       "设置行号
"set ignorecase                                  "忽略大小写 （查找字符串时）
set nohlsearch                                   "高亮显示 （查找字符串是，找到后高亮显示）
set mouse=a                                      "使用鼠标
set ruler	                                     "在右下角显示光标位置
set showcmd	                                     "显示未敲完的命令
set cmdheight=1                                  "设定命令行的行数为 1
set laststatus=2                                 "显示状态栏 (默认值为 1, 无法显示状态栏)
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)\           " 设置在状态行显示的信息
set incsearch                                    "在输入搜索的字符串同时就开始搜索已经输入的部分
set nowrap                                       " 一行就一行，别弄到第二行去
set sidescroll=10	                             "屏幕放不下时，按一次屏幕移动一个字符	
set whichwrap=b,s,<,>,[,]	                     "跨行移动
set fileformats=unix,dos
set cursorline                                   "突出显示当前行
"set autochdir                                    "自动切换当前目录为当前文件所在的目录
set showmatch                                    "插入括号时，短暂地跳转到匹配的对应括号
set matchtime=2                                  "短暂跳转到匹配括号的时间
set smartindent                                  "开启新行时使用智能自动缩进

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

"set clipboard+=unnamed                          "与windows共享剪贴板 
"set pastetoggle=<F4>
"source $VIMRUNTIME/mswin.vim  
"behave mswin                                     "兼容windows下的快捷键  
"set selection=exclusive                          "使用鼠标（类似office中 ->  
"set selectmode=mouse,key                         "在工作区双击鼠标定位）  
set whichwrap+=<,>,h,l                            "允许backspace和光标键跨越行边界   



"let g:airline#extensions#tabline#enabled = 1
"let mapleader = ","
"nnoremap <space> :
"vnoremap <space> :
"=========================GUI setting========================
if has("gui_running") 
	set guioptions-=m " 隐藏菜单栏 
	set guioptions-=T " 隐藏工具栏 
	set guioptions-=L " 隐藏左侧滚动条 
	set guioptions-=r " 隐藏右侧滚动条 
	set guioptions-=b " 隐藏底部滚动条 
	set showtabline=0 " 隐藏Tab栏 
endif 


"=========================OS setting========================
"====return OS type, eg: windows, or linux, mac, et.st.. ====
" return OS type, eg: windows, or linux, mac, et.st..
 function! MySys()
 if has("win16") || has("win32") || has("win64") || has("win95")
 return "windows"
 elseif has("unix")
 return "linux"
 endif
 endfunction

"用户目录变量$VIMFILES
if MySys() == "windows"
	let $VIMFILES = $VIM.'/vimfiles'
elseif MySys() == "linux"
	let $VIMFILES = $HOME.'/.vim'
endif

" 设定doc文档目录
let helptags=$VIMFILES.'/doc'

" 设置字体 以及中文支持
if has("win32")
set guifont=Inconsolata:h12:cANSI
endif

" 配置多语言环境
if has("multi_byte")
set encoding=utf-8                    " UTF-8 编码
set termencoding=utf-8
set formatoptions+=mM
set fencs=utf-8,gbk

if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
set ambiwidth=double
endif

if has("win32")
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
language messages zh_CN.utf-8
endif
else
echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif


"=========================Louie setting=======================
"set background=dark
set fileencodings=ucs-bom,utf-8,GB18030,GBK,GB2312                      "字符编码支持中文
set nohlsearch                                                          "非高亮
"vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>  "p命令可以使用剪切板上的内容来替还选中的内容
"colorscheme louie

"记忆上次打开文件的位置
if has("autocmd")
	autocmd BufRead *.txt set tw=78
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\   exe "normal g'\"" |
endif

filetype plugin indent on                                     "自动识别文件类型，用文件类型plugin脚本，使用缩进定义文件

"java omni func
"au FileType java setlocal omnifunc=javacomplete#Complete      "设置Java代码的自动补全 
"setlocal completefunc=javacomplete#CompleteParamsInfo
"inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P>
"inoremap <buffer> <C-S-Space> <C-X><C-U><C-P>
"autocmd Filetype java inoremap <buffer> . .<C-X><C-O><C-P>

" 我的状态行显示的内容（包括文件类型和解码）
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
" 总是显示状态行
"set laststatus=2


"=========================键值映射============================
"nmap <F2> :nohlsearch<CR>
"map <F3> :copen<CR>:grep -R 
"imap <F7> <Esc>:w<CR><CR>:copen<CR>:make<CR><CR>
"map <F8> :cclose<CR>
"map <F9> :TlistToggle<CR>
"map <F2> GoDate: <Esc>:read !date<CR>kJ
map <silent> <F7> :!git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle3

"plugin shortcuts
function! RunShell(Msg, Shell)                                                                                                                               
	echo a:Msg . '...'
	call system(a:Shell)
	echon 'done'
endfunction


"nmap  <F6> :vimgrep /<C-R>=expand("<cword>")<cr>/ **/*.c **/*.h<cr><C-o>:cw<cr>
"nmap <F12> :call RunShell("Generate cscope", "~/.vim/cstags")<cr>

"窗口分割时,进行切换的按键热键需要连接两次,比如从下方窗口移动光标到上方窗口,
"需要<c-w><c-w>k,非常麻烦,现在重映射为<c-k>,切换的时候会变得非常方便.
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l

"========================折叠==================================
"set foldmethod=indent                                 "折叠模式
set foldcolumn=2                                       "折叠列的宽度
set foldlevel=3                                        "置折叠层级
"set foldclose=all                                     "设置为自动关闭折叠

"set foldenable " 开始折叠
"set foldmethod=syntax " 设置语法折叠
"set foldcolumn=0 " 设置折叠区域的宽度
"setlocal foldlevel=1 " 设置折叠层数为
" set foldclose=all " 设置为自动关闭折叠 
" " nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" " 用空格键来开关折叠

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"插件设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"========================netrw setting=============================
"let g:netrw_winsize = 20
"nmap <silent> <leader>fe :Sexplore!<cr>
"map <silent> <F5> : Vexplore<CR>	"开fileexploer，S代表当前分隔一个横向的窗口，V代表纵向


"========================Tag Lisg(ctags)=============================
"au BufWritePost *c,*cpp,*h !ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
"map <F8> :TlistToggle<CR>
"let Tlist_Ctags_Cmd = 'ctags'
"let Tlist_Show_One_File = 1
"let Tlist_Exit_OnlyWindow = 1
"let Tlist_Use_Right_Window = 1
"let Tlist_WinWidth = 20
"set tags=tags,./tags,/usr/include/tags,../tags

"let Tlist_File_Fold_Auto_Close=1        "自动折叠当前非编辑文件的方法列表
"let Tlist_Auto_Update = 1
"let Tlist_Auto_Open = 1
"let Tlist_Hightlight_Tag_On_BufEnter = 1
"let Tlist_Enable_Fold_Column =0
"let Tlist_Process_File_Always = 1
"let Tlist_Display_Prototype = 0
"let Tlist_Compact_Format = 1

"进行Tlist的设置
"TlistUpdate可以更新tags
"map <F3> :silent! Tlist<CR> "按下F3就可以呼出了
"let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
"let Tlist_Use_Right_Window=1 "让窗口显示在右边，0的话就是显示在左边
"let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表，如果想只有1个，设置为1
"let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
"let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
"let Tlist_Process_File_Always=0 "是否一直处理tags.1:处理;0:不处理。不是一直实时更新tags，因为没有必要
"let Tlist_Inc_Winwidth=0

""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F9> :TagbarToggle<CR>

"""""""""""""""""""""""""""""""
"" winManager setting
"""""""""""""""""""""""""""""""
"let g:winManagerWindowLayout = "FileExplorer|TagList"
"let g:winManagerWindowLayout = "NERDTree|BufExplorer|TagList"
"let g:winManagerWidth = 30
"nmap wm :WMToggle<CR>  
"nmap <silent> <F8> :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>

"============================minibufexpl.vim=========================
"let g:miniBufExplMapWindowNavVim = 1   
"let g:miniBufExplMapWindowNavArrows = 1   
"let g:miniBufExplMapCTabSwitchBufs = 1   
"let g:miniBufExplModSelTarget = 1  
"let g:miniBufExplMoreThanOne=0  
"let g:miniBufExplTabWrap = 1              "make tabs show complete (no broken on two lines)p <F1> :call MyCyclebuffer(0)<CR>
"nnoremap <F2> :bn<CR>
"CTRL+6  下一个文件

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


"=====================powerline==================="
"powerline{ 
set guifont=PowerlineSymbols\ for\ Powerline 
set nocompatible 
"set t_Co=256 
let g:Powerline_symbols = 'fancy' 
"} 


"=====================txtbrowser==================="
let tlist_txt_settings = 'txt;c:content;f:figures;t:tables'
au BufRead,BufNewFile *.txt setlocal ft=txt

"=====================OmniCppComplete.vim=====================
set completeopt=longest,menu
let g:OmniCpp_DefaultNamespaces=["std"]
let g:OmniCpp_SelectFirstItem=2
let OmniCpp_MayCompleteDot = 1                             " autocomplete with .
let OmniCpp_MayCompleteArrow = 1                           " autocomplete with ->
let OmniCpp_MayCompleteScope = 1                           " autocomplete with ::
let OmniCpp_SelectFirstItem = 2                            " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2                            " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 0                        " show function prototype  in popup window
let OmniCpp_GlobalScopeSearch=1
let OmniCpp_DisplayMode=1


"=================plugin - NeoComplCache.vim 自动补全插件=========
let g:AutoComplPop_NotEnableAtStartup         = 1
let g:NeoComplCache_EnableAtStartup           = 1
let g:NeoComplCache_SmartCase                 = 1
let g:NeoComplCache_TagsAutoUpdate            = 1
let g:NeoComplCache_EnableInfo                = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_MinSyntaxLength           = 3
let g:NeoComplCache_EnableSkipCompletion      = 1
let g:NeoComplCache_SkipInputTime             = '0.5'
let g:NeoComplCache_SnippetsDir = $VIMFILES.'/snippets'
"let g:neocomplcache_enable_at_startup         =1 
"inoremap <expr><TAB> pumvisible() ? 
""\<C-n>" : 
"\<TAB>" 
" snippets expand key
"imap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)
"smap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)

"========================cscope=============================
set cscopequickfix=s-,c-,d-,i-,t-,e-
"cscope -Rbkq
"1.索指定符号              cs find s <symbol>
"2.搜索定义                cs find g <var_name|func_name>
"3.搜索函数所调用的函数    cs find d <functions_invoked>
"4.搜索调用此函数的函数    cs find c <functions_invoking>
"5.搜索指定字符串          cs find t <text>
"6.搜索egrip指定的模式     cs find e <egrip>
"7.搜索文件                cs find f <filename>
"8.搜索包含本文件的文件    cs find i <including_files>


"""""""""""""""""""""""""""快捷方式 自动补全""""""""""""""""""""""""""""""
set complete=.,b,d,t,u " 而这个命令中可能出现的key值如下:
let g:SuperTabRetainCompletionType = 2
let g:SuperTabDefaultCompletionType = "<C-X><C-O>" 

"g:SuperTabRetainCompletionType的值缺省为1，意为记住你上次的补全方式，直到使用其它的补全命令改变它；如果把它设成2，意味着记住上次的补全方式，直到按ESC退出插入模式为止；如果设为0，意味着不记录上次的补全方式。
"g:SuperTabDefaultCompletionType的值设置缺省的补全方式，缺省为CTRL-P。
". 当前文件
"b 已被装缓冲区,但是没有在窗口内的文件
"d 在当前的文件中定义和由#include包含进来的文件
"i 由#include包含进来的文件
"k 由dictionary选项定义的文件
"kfile 名为{file}的文件
"t 标记(tags)文件
"u 没有载入的缓冲区
"w 在其他窗口中的文件
" % 括号匹配
" gd 跳转到局部变量定义 
" * 转到当前光标所指的单词下一次出现的地方
" # 转到当前光标所指的单词上一次出现的地方
" 然后按下“Ctrl-P”（向前搜索可匹配的单词并完成）就可以得到完整的变量名（没有得到想要的结果的话，多按几下“Ctrl-P”；或者前面多输入几个字符，如“aLongV”）。
" Ctrl-N”（向后搜索可匹配的单词并完成）、
" Ctrl-X Ctrl-L”（搜索可匹配的行并完成）、
" Ctrl-X Ctrl-F”（搜索可匹配的文件名并完成）等
"vim有万能补全<c+x><c+o>，函数名和类名都没有问题
"宏定义也有<c+x><c+d>补全
"
"整行补全                        CTRL-X CTRL-L
"根据当前文件里关键字补全        CTRL-X CTRL-N
"根据字典补全                    CTRL-X CTRL-K
"根据同义词字典补全              CTRL-X CTRL-T
"根据头文件内关键字补全          CTRL-X CTRL-I
"根据标签补全                    CTRL-X CTRL-]
"补全文件名                      CTRL-X CTRL-F
"补全宏定义                      CTRL-X CTRL-D
"补全vim命令                     CTRL-X CTRL-V
"用户自定义补全方式              CTRL-X CTRL-U
"拼写建议                        CTRL-X CTRL-S



"""""""""""""""""""""""""""""""""""VUNDLE setting"""""""""""""""""""""""""""""""""""""""""""
"""""
set nocompatible               " be iMproved
filetype off                   " required!
	set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

	" let Vundle manage Vundle
	" required! 
	Bundle 'gmarik/vundle'

	" vim-scripts repos
	"Bundle 'minibufexpl.vim'
	Bundle 'bufexplorer.zip'
	"Bundle 'taglist.vim'
	"Bundle 'c.vim'
	Bundle 'cscope.vim'
	"Bundle 'winmanager'
	Bundle 'The-NERD-Commenter'
	Bundle 'snipMate'
	Bundle 'The-NERD-tree'
	Bundle 'TxtBrowser'
	Bundle 'Tagbar'
	Bundle 'genutils'
	Bundle 'ctrlp.vim'
	"Bundle 'lookupfile'
	"Bundle 'LeaderF'

    "github repos.
	"Bundle 'fholgado/minibufexpl.vim'
	Bundle 'tpope/vim-fugitive'
	Bundle 'Shougo/neocomplcache.vim'
	Bundle 'ervandew/supertab'
	Bundle 'simplyzhao/cscope_maps.vim'
	Bundle 'vim-scripts/EasyGrep'
	"Bundle 'bling/vim-airline'
	
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
" zz    将光标所在的行放在屏幕中间
" zt    将光标所在的行放在屏幕第一行 top
" zb    将光标所在的行放在屏幕最后一行 botton

"＊	查找光标所在处的单词
"%	括号之间跳() {}	#if...#enfif 之间
"gd	中转到局部变量的定义处
"gf	跳到光标所在的头文件处，ctrl＋o 跳回来

"cw	删除一个单词并进入插入模式
"dw	删除一个单词并
"[I	查看函数的声明：显示include文件中匹配这个函数名的一个清单
