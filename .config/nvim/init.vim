set number
set ts=4 sw=4
" set spell
set scrolloff=5
set splitright
set splitbelow

	" important for Toggleterm
set switchbuf=useopen,vsplit

colorscheme kalankaboom

	" Conceal markdown links
autocmd BufRead,BufNewFile *.md set conceallevel=2

	" keybindings
nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
nnoremap <S-j> <S-Down>
nnoremap <S-k> <S-Up>
nnoremap <silent> <C-l> <C-w>v :let g:netrw_browse_split = 0 <bar> Explore <CR>
nnoremap <silent> <C-h> <C-w>s :let g:netrw_browse_split = 0 <bar> Explore <CR>

tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
tnoremap <ESC> <C-\><C-N>

noremap <A-h> <C-w>h
noremap <A-j> <C-w>j
noremap <A-k> <C-w>k
noremap <A-l> <C-w>l

nnoremap <A-CR> :lua vim.lsp.buf.code_action()<CR>

	" vim-plug
call plug#begin('~/.config/nvim/my-vim-plugins')
Plug 'skywind3000/asyncrun.vim'

Plug 'godlygeek/tabular', { 'for': 'markdown' }

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'p00f/nvim-ts-rainbow'

Plug 'windwp/nvim-autopairs'

Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'numToStr/Comment.nvim'

Plug 'mhinz/vim-startify'

Plug 'junegunn/fzf'
call plug#end()

	" vim-startify
let g:startify_lists = [
	\ { 'type': 'files',     'header': ['   Freshest  '] },
	\ { 'type': 'sessions',  'header': ['   Sessions  '] },
	\ { 'type': 'commands',  'header': ['   Commands  '] },
\ ]
let g:startify_enable_special = 0
let g:startify_padding_left = 5
let g:startify_files_number = 10

	" Quick Notes
function! Quicknote()
	let l:fpath = "~/Documents/Notes/Quick_Notes/" . strftime("%d-%m-%Y") . ".md"
	if filereadable(expand(l:fpath))
		execute "e " . l:fpath
		let l:penult = readfile(expand(l:fpath), '', -2)
		if match(l:penult[0], '# \d\d:\d\d:\d\d') != -1 && l:penult[1] == ''
			$
			d
			d
			d
		endif
	else
		e ~/Templates/quick.md
		execute "saveas " . l:fpath
		execute "e " . l:fpath
		write
		%s/title/\=strftime("%d-%m-%Y")
	endif
	call append(line('$'), ['', "# " . strftime("%T"), ''])
	$
	write
	startinsert
	return 1
endfunction

	" Template selector
let g:typeselected = ""
function! Tempselect()
	if g:typeselected == ""
		enew
		silent! setlocal
			\ bufhidden=wipe
			\ modifiable
			\ cursorline
			\ nobuflisted
			\ nonumber
			\ noreadonly
			\ nospell
			\ noswapfile
			\ signcolumn=no
			\ statusline=\ templates
		let l:filetypes = split(system('find ~/Templates/ -type f | grep -P -o "(?<=\.).+" | sort -u | grep -nE -o ".+"'), "\n")
		call append('1', '   Templates'))
		call map(l:filetypes, "'     ' . join(split(v:val, ':'), ': ')")
		call append('$', l:filetypes)
		nnoremap <silent> <CR> :let g:typeselected = getline('.') <bar> call Tempselect()<CR>
		syntax match TempNorm /[.a-z0-9]/
		highlight TempNorm ctermfg=yellow
		syntax match TempTit /   \w\+$/
		highlight TempTit cterm=bold ctermfg=cyan
		syntax match TempNum /\d\+:/
		highlight TempNum cterm=bold ctermfg=magenta
		syntax match TempSub /\(:\s\|\/\)\@<=\(\w\+\)\(\/\)\@=/
		highlight TempSub ctermfg=darkcyan
		syntax match TempSlash /\//
		highlight TempSlash ctermfg=darkmagenta
	else
		if g:typeselected == '   Templates'
			let g:typeselected = ""
			call feedkeys(":Startify\<CR>")	
			return 1
		else
			let g:typeselected = split(g:typeselected, ": ")[1]
		endif
		setlocal modifiable
		execute("1,$d")
		call append('1', toupper('   ' . g:typeselected))
		let l:temps = split(system('find ~/Templates/ -name *.' . g:typeselected . ' -type f | grep -nP -o "(?<=Templates/).+"'), "\n")
		call map(l:temps, "'     ' . join(split(v:val, ':'), ': ')")
		call append('$', l:temps)
		augroup postrename
			autocmd BufWritePost * :call feedkeys(":e#\<CR>:silent !rm tempname.*\<CR>:call Newnote()\<CR>:write\<CR>")
		augroup end
		nnoremap <CR> :let g:chosenpath = getline(".") <CR>
			\ :if g:chosenpath =~ '   \w\+$' <bar> let g:typeselected = "" <bar> call Tempselect() <bar> endif <CR>
			\ :let g:chosenpath = "~/Templates/" . split(g:chosenpath, ": ")[1] <CR>
			\ :let g:notespath = '~/Documents/Notes/' . g:typeselected . '/tempname.' . g:typeselected <CR>
			\ :execute('!cp ' . g:chosenpath . ' ' . g:notespath) <CR>
			\ :execute("e " . g:notespath) <CR>
			\ :execute ('cd ~/Documents/Notes/' . g:typeselected . '/') <CR>
			\ :write 
	endif
	3
	setlocal nomodifiable nomodified
	call feedkeys("^")
	return 1
endfunction

function! Newnote()
	if g:typeselected == "tex" || g:typeselected == "md"
		%s/\[today\]/\=strftime('%d-%m-%Y')
		%s/\[title\]/\=expand('%:t:r')
	endif
	autocmd! postrename
	return 1
endfunction

let g:startify_commands = [
	\ {'x': ['Explore', ':let g:netrw_browse_split = 0 | Explore']},
	\ {'f': ['Fuzzy', ':FZF']},
	\ {'n': ['Note', ' call Quicknote()']},
	\ {'t': ['Template', ' call Tempselect()']},
\ ]

let s:mushroom = [
\ "",
\ "",
\ "                          .-'~~~-.				",
\ "                        .'o  oOOOo`.			    ",
\ "                       :~~~-.oOo   o`.			",
\ "                        `. \\ ~-.  oOOo.			",
\ "                          `.; / ~.  OO:			",
\ "                          .'  ;-- `.o.'			",
\ "                         ,'  ; ~~--'~			",
\ "                         ;  ;					",
\ '   _______\|/__________\\;_\\//___\|/________	',
\ "",
\ "",
\ ]

let s:diver = [
\ "",
\ "",
\ "                             o							",
\ "                            o  o							",
\ "                            o o o						",
\ "                          o								",
\ "         .              o    ______          ______		",
\ "   \\_____)\\_____        _ *o(_||___)________/___			",
\ "   /--v____ __`<      O(_)(       o  ______/    \\		",
\ "           )/        > ^  `/------o-'            \\		",
\ "           '       D|_|___/								",
\ "",
\ "",
\ ]

let s:micro = [
\ "",
\ '                                        __			',
\ '                                        ||			',
\ '                                       ====			',
\ '                                       |  |__		',
\ '   -. .-.   .-. .-.   .-. .-.   .      |  |-.\		',
\ '   ||\|||\ /|||\|||\ /|||\|||\ /|      |__|  \\		',
\ '   |/ \|||\|||/ \|||\|||/ \|||\||       ||   ||		',
\ '   ~   `-~ `-`   `-~ `-`   `-~ `-     ======__|		',
\ '                                     ________||__	',
\ '                                    /____________\	',
\ "",
\ "",
\ ]

let s:mountains = [
\ "",
\ "",
\ "",
\ '           _    .  ,   .           .							',
\ "       *  / \\_ *  / \\_      _  *        *   /\\'__        *	",
\ "         /    \\  /    \\,   ((        .    _/  /  \\  *'.		",
\ "    .   /\\/\\  /\\/ :' __ \\_  `          _^/  ^/    `--.		",
\ "       /    \\/  \\  _/  \\-'\\      *    /.' ^_   \\_   .'\\  *	",
\ '     /\  .-   `. \/     \ /==~=-=~=-=-;.  _/ \ -. `_/   \	',
\ "    /  `-.__ ^   / .-'.--\\ =-=~_=-=~=^/  _ `--./ .-'  `-		",
\ "   /        `.  / /       `.~-^=-=~=^=.-'      '-._ `._		",
\ "",
\ "",
\ ]

let s:lonebeach = [
\ "             ___   ____										",	
\ "           /' --;^/ ,-_\\     \\ | /							",
\ "          / / --o\\ o-\\ \\\\   --(_)--							",
\ "         /-/-/|o|-|\\-\\\\|\\\\   / | \\							",
\ "          '`  ` |-|   `` '									",
\ "                |-|											",
\ "                |-|O											",
\ "                |-(\\,__										",
\ "             ...|-|\\--,\\_....								",
\ "         ,;;;;;;;;;;;;;;;;;;;;;;;;,.							",
\ "   ~~,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;~~~~~~~~~~~~~~~~~~~~~~~	",
\ "   ~;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,  ______   -------   ",
\ "",
\ ]

let s:desert = [
\ "              ,,                               .-.			",
\ "             || |                               ) )			",
\ "             || |   ,                          '-'			",
\ "             || |  | |										",
\ "             || '--' |										",
\ "       ,,    || .----'										",
\ "      || |   || |											",
\ "      |  '---'| |											",
\ "      '------.| |                                  _____		",
\ '      ((_))  || |      (  _                       / /|\ \	',
\ "      (o o)  || |      ))(\"),                    | | | | |	",
\ '   ____\_/___||_|_____((__^_))____________________\_\|/_/__	',
\ "",
\ ]

let s:taj = [	
\ '                          !							',
\ '                         /^\							',
\ '                       /     \						',
\ '    |               | (       ) |               |	',
\ '   /^\  |          /^\ \     / /^\          |  /^\	',
\ '   |O| /^\        (   )|-----|(   )        /^\ |O|	',
\ '   |_| |-|    |^-^|---||-----||---|^-^|    |-| |_|	',
\ '   |O| |O|    |/^\|/^\||  |  ||/^\|/^\|    |O| |O|	',
\ '   |-| |-|    ||_|||_||| /^\ |||_|||_||    |-| |-|	',
\ '   |O| |O|    |/^\|/^\||(   )||/^\|/^\|    |O| |O|	',
\ '   |-| |-|    ||_|||_||||   ||||_|||_||    |-| |-|	',
\ '   |O| |_|----|___|___|||___|||___|_|_|    |O| |O|	',
\ '   |_|                                         |_|	',
\ ]

let g:asciibanners = [
\	s:mushroom,
\	s:diver,
\	s:micro,
\	s:mountains,
\	s:lonebeach,
\	s:desert,
\	s:taj,
\]

let g:dayarray = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

let g:startify_custom_header = g:asciibanners[index(g:dayarray, strftime("%a"))]

	" Configure netrw
let g:netrw_active = 1
function! Togglenetrw()
	let g:netrw_browse_split = 4
	if g:netrw_active
		Vexplore
		let g:netrw_active = 0
	else
		bd NetrwTreeListing
		let g:netrw_active = 1
	endif
	return 1
endfunction
nnoremap <silent> <C-f> :call Togglenetrw()<CR>
let g:netrw_bufsettings = 'noma nomod nonu nowrap ro buflisted'
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 20
let g:netrw_altv = 1

	" Toggle terminal
let g:term_active = 1
function! Toggleterm()
	if g:term_active
		vsplit
		set nonumber
		terminal
		file Terminal
		startinsert
		let g:term_active = 0
	else
		sb Terminal
		startinsert
		call feedkeys("exit\<CR>")
		let g:term_active = 1
	endif
	return 1
endfunction
nnoremap <silent> <C-q> :call Toggleterm()<CR>
tnoremap <silent> <C-q> <C-\><C-n> :call Toggleterm()<CR>

	" split zathura
" function! Splitzathura()
" 	!xdotool search --sync --onlyvisible --class zathura windowactivate
" 	!xdotool key alt+2 alt+Tab alt+9 alt+1
" 	return 1
" endfunction

	" auto-compile latex
let g:autocomplat=1
function! Latautocompfunc()
	if g:autocomplat
		augroup latcomp
			autocmd BufWritePost *.tex silent! AsyncRun! latexmk -outdir=%:p:h -pdf %:p
			autocmd QuitPre *.tex AsyncRun! rm %:p:r.bcf %:p:r.fls %:p:r.aux %:p:r.bbl %:p:r.blg %:p:r.fdb_latexmk %:p:r.log %:p:r.run.xml %:p:r.toc
		augroup end
		if filereadable(expand("%:p:r.pdf"))
			" AsyncRun! -post=call\ Splitzathura() zathura --fork %:p:r.pdf
			AsyncRun! zathura --fork %:p:r.pdf
		else
			" AsyncRun! -post=call\ Splitzathura() latexmk -outdir=%:p:h -pdf %:p && zathura --fork %:p:r.pdf
			AsyncRun! latexmk -outdir=%:p:h -pdf %:p && zathura --fork %:p:r.pdf
		endif
		let g:autocomplat=0
		echohl MoreMsg
		echo 'Compilation started!'
		echohl None
	else
		autocmd! latcomp BufWritePost *.tex
		let g:autocomplat=1
		echohl WarningMsg
		echo 'Compilation stopped!'
		echohl None
	endif
	return 1
endfunction
autocmd FileType tex nnoremap \ll :call Latautocompfunc()<CR>

	" auto-compile markdown
let g:autocompmark=1
function! Markautocompfunc()
	if g:autocompmark 
		augroup markcomp
			if expand("%:p:r") == "/home/kalankaboom/Documents/Notes/index"
				cmap wq w
				autocmd BufWriteCmd index.md %s/\.tex\|\.md/.pdf/g | cmap q <ESC>| write | AsyncRun! pandoc %:p /home/kalankaboom/Templates/metadata.yaml -s -o %:p:r.pdf
				autocmd User AsyncRunStop undo | write | cmap q q
			else
				autocmd BufWritePost *.md AsyncRun! pandoc %:p /home/kalankaboom/Templates/metadata.yaml -s -o %:p:r.pdf
			endif
		augroup end
		if filereadable(expand("%:p:r.pdf"))
			" AsyncRun! -post=call\ Splitzathura() zathura --fork %:p:r.pdf
			AsyncRun! zathura --fork %:p:r.pdf
		else
			" AsyncRun! -post=call\ Splitzathura() pandoc %:p:r.md /home/kalankaboom/Templates/metadata.yaml -s -o %:p:r.pdf && zathura --fork %:p:r.pdf
			AsyncRun! pandoc %:p /home/kalankaboom/Templates/metadata.yaml -s -o %:p:r.pdf && zathura --fork %:p:r.pdf
		endif
		let g:autocompmark=0
		echohl MoreMsg
		echo 'Compilation started!'
		echohl None
	else
		autocmd! markcomp BufWritePost *.md
		let g:autocompmark=1
		echohl WarningMsg
		echo 'Compilation stopped!'
		echohl None
	endif
	return 1
endfunction
autocmd FileType markdown nnoremap \ll :call Markautocompfunc()<CR>

	"auto-compile c/cpp
let g:autocompc=1
function! Cautocompfunc()
	if g:autocompc
		call Toggleterm()
		call feedkeys("\<C-\>\<C-N>\<C-w>h")
		augroup ccomp
			autocmd BufWritePost *.cpp AsyncRun! -post=vert\ sb\ Terminal\ |\ startinsert\ |\ call\ feedkeys("\<C-l>./%:r\<CR>\<C-\>\<C-N>\<C-w>h") g++ %:p:r.cpp -o %:p:r
			autocmd BufWritePost *.c AsyncRun! -post=vert\ sb\ Terminal\ |\ startinsert\ |\ call\ feedkeys("\<C-l>./%:r\<CR>\<C-\>\<C-N>\<C-w>h") gcc %:p:r.c -o %:p:r
		augroup end
		let g:autocompc=0
		echohl MoreMsg
		echo 'Compilation started!'
		echohl None
	else
		call Toggleterm()
		autocmd! ccomp BufWritePost *.c,*.cpp
		let g:autocompc=1
		" echohl WarningMsg
		" echo 'Compilation stopped!'
		" echohl None
	endif
	return 1
endfunction
autocmd FileType c,cpp nnoremap \ll :call Cautocompfunc()<CR>
" autocmd FileType c,cpp :!cd

	" fzf
nnoremap fz :FZF <CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7, 'border': 'sharp' } }
" export FZF_DEFAULT_OPTS='--color bg+:5,border:15,spinner:14,hl:6,prompt:13,info:12,pointer:14,marker:11,fg+:15,hl+:6,gutter:-1'
	" cmp
set completeopt=menu,menuone,noselect

lua <<EOF
	-- Setup autopairs
require("nvim-autopairs").setup{}

	-- Setup nvim-treesitter
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "all", -- language parsers
	ignore_install = { "" }, -- parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the extension
		disable = { "" }, -- list of languages that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "" } },
	rainbow = {
    	enable = true,
    	-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    	extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    	max_file_lines = nil, -- Do not enable for files with more than n lines, int
    	-- colors = {}, -- table of hex strings
    	termcolors = {"green", "yellow", "magenta", "cyan", "darkgreen", "brown", "darkmagenta", "darkcyan", "darkred"} -- table of colour name strings
  },
  context_commentstring = { -- used by nvim-ts-context-commentstring for autocomments
    enable = true
  }
})

	-- Setup Comment.nvim with nvim-ts-context-commentstring
require('Comment').setup({
    ---@param ctx CommentCtx
    pre_hook = function(ctx)
        -- Only calculate commentstring for tsx filetypes
        if vim.bo.filetype == 'typescriptreact' then
            local U = require('Comment.utils')

            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.line and '__default' or '__multiline'

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.block then
                location = require('ts_context_commentstring.utils').get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require('ts_context_commentstring.utils').get_visual_start_location()
            end

            return require('ts_context_commentstring.internal').calculate_commentstring({
                key = type,
                location = location,
            })
        end
    end,
	post_hook = function(ctx)
        if ctx.range.srow == ctx.range.erow then
            -- do something with the current line
        else
            -- do something with lines range
        end
    end,
})

  -- Setup nvim-cmp.
local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

  --   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
	formatting = {
    	fields = { "kind", "abbr"},
    	format = function(entry, vim_item)
		vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      	return vim_item
	end,
  	},
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
		else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
     }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, 
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['texlab'].setup {
   capabilities = capabilities
  }
  require('lspconfig')['clangd'].setup {
   capabilities = capabilities
  }
EOF
