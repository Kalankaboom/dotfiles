"%% SiSU Vim color file
:set background=dark
:highlight clear
if version > 580
 hi clear
 if exists("syntax_on")
 syntax reset
 endif
endif
let colors_name = "kalankaboom"
:hi VertSplit ctermfg=darkblue
:hi Folded ctermfg=grey ctermbg=darkblue
:hi FoldColumn ctermfg=4 ctermbg=7
:hi IncSearch cterm=none ctermfg=yellow ctermbg=green
:hi ModeMsg cterm=none ctermfg=white
:hi MoreMsg cterm=bold ctermfg=green
:hi NonText cterm=bold ctermfg=blue
:hi Question ctermfg=green
:hi Search cterm=none ctermfg=grey ctermbg=blue
:hi SpecialKey ctermfg=darkgreen
:hi StatusLine cterm=bold,reverse ctermfg=magenta
:hi StatusLineNC cterm=reverse ctermfg=cyan
:hi Title cterm=bold ctermfg=yellow
:hi Statement ctermfg=cyan
:hi Visual cterm=reverse ctermbg=black
:hi WarningMsg cterm=bold ctermfg=1 ctermbg=darkred
:hi String ctermfg=yellow
:hi Comment cterm=bold ctermfg=brown
:hi Constant ctermfg=yellow
:hi Special ctermfg=magenta
:hi Identifier cterm=none ctermfg=green
:hi Include ctermfg=yellow
:hi PreProc ctermfg=yellow
:hi Operator ctermfg=magenta
:hi Define ctermfg=yellow
:hi Type ctermfg=2
:hi Function ctermfg=darkcyan
:hi Structure ctermfg=green
:hi LineNr ctermfg=blue
:hi Ignore cterm=bold ctermfg=7
:hi Directory ctermfg=darkcyan
:hi ErrorMsg cterm=bold ctermfg=1 ctermbg=darkred
:hi WildMenu ctermfg=0 ctermbg=3
:hi DiffAdd ctermbg=4
:hi DiffChange ctermbg=5
:hi DiffDelete cterm=bold ctermfg=4 ctermbg=6
:hi DiffText cterm=bold ctermbg=1
:hi Underlined cterm=underline ctermfg=5
:hi Error cterm=bold ctermfg=1 ctermbg=darkred
:hi SpellErrors cterm=bold ctermfg=1
:hi SpellBad cterm=undercurl ctermfg=1 ctermbg=none

:hi MatchParen cterm=bold ctermbg=blue

:hi Pmenu cterm=none ctermfg=grey ctermbg=darkblue
:hi PmenuSel cterm=bold ctermfg=white ctermbg=darkmagenta
:hi PmenuSbar cterm=none ctermbg=darkblue 
:hi PmenuThumb cterm=none ctermbg=blue

":hi FZFPrompt ctermfg=magenta
":hi FZFSelection ctermfg=white ctermbg=darkmagenta
":hi FZFMatching ctermfg=darkcyan
":hi FZFCaret ctermfg=cyan
":hi FZFMulti ctermfg=yellow
":hi FZFBorder ctermfg=white ctermbg=none
":hi FZFCounter ctermfg=blue

":hi TelescopePromptPrefix ctermfg=magenta
":hi TelescopeSelection cterm=bold ctermfg=white ctermbg=darkmagenta
":hi TelescopeSelectionCaret cterm=bold ctermfg=white ctermbg=darkmagenta
":hi TelescopeMultiSelection cterm=bold ctermfg=white ctermbg=darkmagenta
":hi TelescopeMultiIcon cterm=bold ctermfg=white ctermbg=darkmagenta
":hi TelescopePromptBorder ctermfg=cyan
":hi TelescopePromptTitle ctermfg=cyan ctermbg=cyan
":hi TelescopePromptCounter ctermfg=darkcyan
":hi TelescopeMatching cterm=bold ctermfg=yellow

:hi StartifyBracket ctermfg=cyan 
:hi StartifyFile ctermfg=yellow
":hi StartifyFooter     the custom footer       |  linked to Title
:hi StartifyHeader ctermfg=darkcyan 
:hi StartifyNumber cterm=bold ctermfg=magenta 
:hi StartifyPath ctermfg=darkcyan
:hi StartifySection cterm=bold ctermfg=cyan
:hi StartifySelect cterm=reverse 
:hi StartifySlash ctermfg=darkmagenta 
:hi StartifySpecial ctermfg=yellow
":hi StartifyVar        environment variables   |  linked to StartifyPath
