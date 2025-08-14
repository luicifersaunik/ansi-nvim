-- Some useful links for making your own colorscheme:
--
-- https://github.com/chriskempson/base16
-- https://colourco.de/
-- https://color.adobe.com/create/color-wheel
-- http://vrl.cs.brown.edu/color

local M = {}

-- This is a bit of syntactic sugar for creating highlight groups.
--
-- local colorscheme = require('colorscheme')
-- local hi = colorscheme.highlight
-- hi.Comment = { guifg='#ffffff', guibg='#000000', gui='italic', guisp=nil }
-- hi.LspDiagnosticsDefaultError = 'DiagnosticError' -- Link to another group
--
-- This is equivalent to the following vimscript
--
-- hi Comment guifg=#ffffff guibg=#000000 gui=italic
-- hi! link LspDiagnosticsDefaultError DiagnosticError
M.highlight = setmetatable({}, {
    __newindex = function(_, hlgroup, args)
        if ('string' == type(args)) then
            vim.api.nvim_set_hl(0, hlgroup, { link = args })
            return
        end

        local ctermfg, ctermbg, cterm = args.ctermfg or nil, args.ctermbg or nil, args.cterm or nil
        local val = {}
        if ctermfg then val.ctermfg = ctermfg end
        if ctermbg then val.ctermbg = ctermbg end
        if cterm then
            for x in string.gmatch(cterm, '([^,]+)') do
                if x ~= "none" then
                    val[x] = true
                end
            end
        end
        vim.api.nvim_set_hl(0, hlgroup, val)
    end
})

function M.with_config(config)
    M.config = vim.tbl_extend("force", {
        telescope = true,
        telescope_borders = false,
        indentblankline = true,
        notify = true,
        ts_rainbow = true,
        cmp = true,
        illuminate = true,
        lsp_semantic = true,
        mini_completion = true,
        dapui = true,
    }, config or M.config or {})
end

--- Creates a base16 colorscheme using the colors specified.
--
-- Builtin colorschemes can be found in the M.colorschemes table.
--
-- The default Vim highlight groups (including User[1-9]), highlight groups
-- pertaining to Neovim's builtin LSP, and highlight groups pertaining to
-- Treesitter will be defined.
--
-- It's worth noting that many colorschemes will specify language specific
-- highlight groups like rubyConstant or pythonInclude. However, I don't do
-- that here since these should instead be linked to an existing highlight
-- group.
--
-- @param colors (table) table with keys 'base00', 'base01', 'base02',
--   'base03', 'base04', 'base05', 'base06', 'base07', 'base08', 'base09',
--   'base0A', 'base0B', 'base0C', 'base0D', 'base0E', 'base0F'. Each key should
--   map to a valid 6 digit hex color. If a string is provided, the
--   corresponding table specifying the colorscheme will be used.
function M.setup(colors, config)
    M.with_config(config)

    if type(colors) == 'string' then
        colors = M.colorschemes[colors]
    end

    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end

    -- BASE16_THEME in a tmux session cannot be trusted because of how envs in tmux panes work.
    local base16_colorscheme = nil
    if vim.env.TMUX == nil and vim.env.BASE16_THEME ~= nil then
        -- Only trust BASE16_THEME if not inside a tmux pane:
        base16_colorscheme = M.colorschemes[vim.env.BASE16_THEME]
    end
    M.colors                              = colors or base16_colorscheme or
        M.colorschemes['schemer-dark']
    local hi                              = M.highlight

    -- Vim editor colors
    hi.Normal                             = { ctermfg = M.colors.cterm05, ctermbg =  nil }
    hi.Bold                               = { cterm = 'bold' }
    hi.Debug                              = { ctermfg = M.colors.cterm08 }
    hi.Directory                          = { ctermfg = M.colors.cterm0D }
    hi.Error                              = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.ErrorMsg                           = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.Exception                          = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.FoldColumn                         = { ctermfg = M.colors.cterm0C, ctermbg = M.colors.cterm00 }
    hi.Folded                             = { ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm01 }
    hi.IncSearch                          = { ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm09, cterm = 'none' }
    hi.Italic                             = { ctermfg = nil, ctermbg = nil, cterm = 'italic' }
    hi.Macro                              = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.MatchParen                         = { ctermfg = nil, ctermbg = M.colors.cterm03 }
    hi.ModeMsg                            = { ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.MoreMsg                            = { ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.Question                           = { ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Search                             = { ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm0A }
    hi.Substitute                         = { ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm0A, cterm = 'none' }
    hi.SpecialKey                         = { ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.TooLong                            = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Underlined                         = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Visual                             = { ctermfg = nil, ctermbg = M.colors.cterm02 }
    hi.VisualNOS                          = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.WarningMsg                         = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.WildMenu                           = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm0A }
    hi.Title                              = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'none' }
    hi.Conceal                            = { ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.Cursor                             = { ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm05 }
    hi.NonText                            = { ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.LineNr                             = { ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm00 }
    hi.SignColumn                         = { ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm00 }
    hi.StatusLine                         = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.StatusLineNC                       = { ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.WinBar                             = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.WinBarNC                           = { ctermfg = M.colors.cterm04, ctermbg = nil, cterm = 'none' }
    hi.VertSplit                          = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00, cterm = 'none' }
    hi.ColorColumn                        = { ctermfg = nil, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.CursorColumn                       = { ctermfg = nil, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.CursorLine                         = { ctermfg = nil, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.CursorLineNr                       = { ctermfg = M.colors.cterm04, ctermbg = M.colors.cterm01 }
    hi.QuickFixLine                       = { ctermfg = nil, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.PMenu                              = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.PMenuSel                           = { ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm05 }
    hi.TabLine                            = { ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.TabLineFill                        = { ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.TabLineSel                         = { ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm01, cterm = 'none' }

    -- Standard syntax highlighting
    hi.Boolean                            = { ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Character                          = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.Comment                            = { ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.Conditional                        = { ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.Constant                           = { ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Define                             = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.Delimiter                          = { ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.Float                              = { ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Function                           = { ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Identifier                         = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.Include                            = { ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.Keyword                            = { ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.Label                              = { ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Number                             = { ctermfg = M.colors.cterm09, ctermbg = nil }
    hi.Operator                           = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.PreProc                            = { ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Repeat                             = { ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Special                            = { ctermfg = M.colors.cterm0C, ctermbg = nil }
    hi.SpecialChar                        = { ctermfg = M.colors.cterm0F, ctermbg = nil }
    hi.Statement                          = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.StorageClass                       = { ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.String                             = { ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.Structure                          = { ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.Tag                                = { ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.Todo                               = { ctermfg = M.colors.cterm0A, ctermbg = M.colors.cterm01 }
    hi.Type                               = { ctermfg = M.colors.cterm0A, ctermbg = nil, cterm = 'none' }
    hi.Typedef                            = { ctermfg = M.colors.cterm0A, ctermbg = nil }

    -- Diff highlighting
    hi.DiffAdd                            = { ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.DiffChange                         = { ctermfg = M.colors.cterm03, ctermbg = M.colors.cterm00 }
    hi.DiffDelete                         = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.DiffText                           = { ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.DiffAdded                          = { ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.DiffFile                           = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.DiffNewFile                        = { ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.DiffLine                           = { ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.DiffRemoved                        = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }

    -- Git highlighting
    hi.gitcommitOverflow                  = { ctermfg = M.colors.cterm08, ctermbg = nil }
    hi.gitcommitSummary                   = { ctermfg = M.colors.cterm0B, ctermbg = nil }
    hi.gitcommitComment                   = { ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitUntracked                 = { ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitDiscarded                 = { ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitSelected                  = { ctermfg = M.colors.cterm03, ctermbg = nil }
    hi.gitcommitHeader                    = { ctermfg = M.colors.cterm0E, ctermbg = nil }
    hi.gitcommitSelectedType              = { ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.gitcommitUnmergedType              = { ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.gitcommitDiscardedType             = { ctermfg = M.colors.cterm0D, ctermbg = nil }
    hi.gitcommitBranch                    = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'bold' }
    hi.gitcommitUntrackedFile             = { ctermfg = M.colors.cterm0A, ctermbg = nil }
    hi.gitcommitUnmergedFile              = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'bold' }
    hi.gitcommitDiscardedFile             = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'bold' }
    hi.gitcommitSelectedFile              = { ctermfg = M.colors.cterm0B, ctermbg = nil, cterm = 'bold' }

    -- GitGutter highlighting
    hi.GitGutterAdd                       = { ctermfg = M.colors.cterm0B, ctermbg = M.colors.cterm00 }
    hi.GitGutterChange                    = { ctermfg = M.colors.cterm0D, ctermbg = M.colors.cterm00 }
    hi.GitGutterDelete                    = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm00 }
    hi.GitGutterChangeDelete              = { ctermfg = M.colors.cterm0E, ctermbg = M.colors.cterm00 }

    -- Spelling highlighting
    hi.SpellBad                           = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }
    hi.SpellLocal                         = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }
    hi.SpellCap                           = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }
    hi.SpellRare                          = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }

    hi.DiagnosticError                    = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.DiagnosticWarn                     = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.DiagnosticInfo                     = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'none' }
    hi.DiagnosticHint                     = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
    hi.DiagnosticUnderlineError           = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }
    hi.DiagnosticUnderlineWarning         = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }
    hi.DiagnosticUnderlineWarn            = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }
    hi.DiagnosticUnderlineInformation     = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }
    hi.DiagnosticUnderlineHint            = { ctermfg = nil, ctermbg = nil, cterm = 'undercurl' }

    hi.LspReferenceText                   = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
    hi.LspReferenceRead                   = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
    hi.LspReferenceWrite                  = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
    hi.LspDiagnosticsDefaultError         = 'DiagnosticError'
    hi.LspDiagnosticsDefaultWarning       = 'DiagnosticWarn'
    hi.LspDiagnosticsDefaultInformation   = 'DiagnosticInfo'
    hi.LspDiagnosticsDefaultHint          = 'DiagnosticHint'
    hi.LspDiagnosticsUnderlineError       = 'DiagnosticUnderlineError'
    hi.LspDiagnosticsUnderlineWarning     = 'DiagnosticUnderlineWarning'
    hi.LspDiagnosticsUnderlineInformation = 'DiagnosticUnderlineInformation'
    hi.LspDiagnosticsUnderlineHint        = 'DiagnosticUnderlineHint'

    hi.TSAnnotation                       = { ctermfg = M.colors.cterm0F, ctermbg = nil, cterm = 'none' }
    hi.TSAttribute                        = { ctermfg = M.colors.cterm0A, ctermbg = nil, cterm = 'none' }
    hi.TSBoolean                          = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'none' }
    hi.TSCharacter                        = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSComment                          = { ctermfg = M.colors.cterm03, ctermbg = nil, cterm = 'italic' }
    hi.TSConstructor                      = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'none' }
    hi.TSConditional                      = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.TSConstant                         = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'none' }
    hi.TSConstBuiltin                     = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'italic' }
    hi.TSConstMacro                       = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSError                            = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSException                        = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSField                            = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSFloat                            = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'none' }
    hi.TSFunction                         = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'none' }
    hi.TSFuncBuiltin                      = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'italic' }
    hi.TSFuncMacro                        = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSInclude                          = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'none' }
    hi.TSKeyword                          = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.TSKeywordFunction                  = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.TSKeywordOperator                  = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.TSLabel                            = { ctermfg = M.colors.cterm0A, ctermbg = nil, cterm = 'none' }
    hi.TSMethod                           = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'none' }
    hi.TSNamespace                        = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSNone                             = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSNumber                           = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'none' }
    hi.TSOperator                         = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSParameter                        = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSParameterReference               = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSProperty                         = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSPunctDelimiter                   = { ctermfg = M.colors.cterm0F, ctermbg = nil, cterm = 'none' }
    hi.TSPunctBracket                     = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSPunctSpecial                     = { ctermfg = M.colors.cterm0F, ctermbg = nil, cterm = 'none' }
    hi.TSRepeat                           = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
    hi.TSString                           = { ctermfg = M.colors.cterm0B, ctermbg = nil, cterm = 'none' }
    hi.TSStringRegex                      = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
    hi.TSStringEscape                     = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
    hi.TSSymbol                           = { ctermfg = M.colors.cterm0B, ctermbg = nil, cterm = 'none' }
    hi.TSTag                              = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSTagDelimiter                     = { ctermfg = M.colors.cterm0F, ctermbg = nil, cterm = 'none' }
    hi.TSText                             = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
    hi.TSStrong                           = { ctermfg = nil, ctermbg = nil, cterm = 'bold' }
    hi.TSEmphasis                         = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'italic' }
    hi.TSUnderline                        = { ctermfg = M.colors.cterm00, ctermbg = nil, cterm = 'underline' }
    hi.TSStrike                           = { ctermfg = M.colors.cterm00, ctermbg = nil, cterm = 'strikethrough' }
    hi.TSTitle                            = { ctermfg = M.colors.cterm0D, ctermbg = nil, cterm = 'none' }
    hi.TSLiteral                          = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'none' }
    hi.TSURI                              = { ctermfg = M.colors.cterm09, ctermbg = nil, cterm = 'underline' }
    hi.TSType                             = { ctermfg = M.colors.cterm0A, ctermbg = nil, cterm = 'none' }
    hi.TSTypeBuiltin                      = { ctermfg = M.colors.cterm0A, ctermbg = nil, cterm = 'italic' }
    hi.TSVariable                         = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
    hi.TSVariableBuiltin                  = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'italic' }

    hi.TSDefinition                       = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
    hi.TSDefinitionUsage                  = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
    hi.TSCurrentScope                     = { ctermfg = nil, ctermbg = nil, cterm = 'bold' }

    hi.LspInlayHint                       = { ctermfg = M.colors.cterm03, ctermbg = nil, cterm = 'italic' }

    if vim.fn.has('nvim-0.8.0') then
        hi['@comment']                  = 'TSComment'
        hi['@error']                    = 'TSError'
        hi['@none']                     = 'TSNone'
        hi['@preproc']                  = 'PreProc'
        hi['@define']                   = 'Define'
        hi['@operator']                 = 'TSOperator'
        hi['@punctuation.delimiter']    = 'TSPunctDelimiter'
        hi['@punctuation.bracket']      = 'TSPunctBracket'
        hi['@punctuation.special']      = 'TSPunctSpecial'
        hi['@string']                   = 'TSString'
        hi['@string.regex']             = 'TSStringRegex'
        hi['@string.escape']            = 'TSStringEscape'
        hi['@string.special']           = 'SpecialChar'
        hi['@character']                = 'TSCharacter'
        hi['@character.special']        = 'SpecialChar'
        hi['@boolean']                  = 'TSBoolean'
        hi['@number']                   = 'TSNumber'
        hi['@float']                    = 'TSFloat'
        hi['@function']                 = 'TSFunction'
        hi['@function.call']            = 'TSFunction'
        hi['@function.builtin']         = 'TSFuncBuiltin'
        hi['@function.macro']           = 'TSFuncMacro'
        hi['@method']                   = 'TSMethod'
        hi['@method.call']              = 'TSMethod'
        hi['@constructor']              = 'TSConstructor'
        hi['@parameter']                = 'TSParameter'
        hi['@keyword']                  = 'TSKeyword'
        hi['@keyword.function']         = 'TSKeywordFunction'
        hi['@keyword.operator']         = 'TSKeywordOperator'
        hi['@keyword.return']           = 'TSKeyword'
        hi['@conditional']              = 'TSConditional'
        hi['@repeat']                   = 'TSRepeat'
        hi['@debug']                    = 'Debug'
        hi['@label']                    = 'TSLabel'
        hi['@include']                  = 'TSInclude'
        hi['@exception']                = 'TSException'
        hi['@type']                     = 'TSType'
        hi['@type.builtin']             = 'TSTypeBuiltin'
        hi['@type.qualifier']           = 'TSKeyword'
        hi['@type.definition']          = 'TSType'
        hi['@storageclass']             = 'StorageClass'
        hi['@attribute']                = 'TSAttribute'
        hi['@field']                    = 'TSField'
        hi['@property']                 = 'TSProperty'
        hi['@variable']                 = 'TSVariable'
        hi['@variable.builtin']         = 'TSVariableBuiltin'
        hi['@constant']                 = 'TSConstant'
        hi['@constant.builtin']         = 'TSConstant'
        hi['@constant.macro']           = 'TSConstant'
        hi['@namespace']                = 'TSNamespace'
        hi['@symbol']                   = 'TSSymbol'
        hi['@text']                     = 'TSText'
        hi['@text.diff.add']            = 'DiffAdd'
        hi['@text.diff.delete']         = 'DiffDelete'
        hi['@text.strong']              = 'TSStrong'
        hi['@text.emphasis']            = 'TSEmphasis'
        hi['@text.underline']           = 'TSUnderline'
        hi['@text.strike']              = 'TSStrike'
        hi['@text.title']               = 'TSTitle'
        hi['@text.literal']             = 'TSLiteral'
        hi['@text.uri']                 = 'TSUri'
        hi['@text.math']                = 'Number'
        hi['@text.environment']         = 'Macro'
        hi['@text.environment.name']    = 'Type'
        hi['@text.reference']           = 'TSParameterReference'
        hi['@text.todo']                = 'Todo'
        hi['@text.note']                = 'Tag'
        hi['@text.warning']             = 'DiagnosticWarn'
        hi['@text.danger']              = 'DiagnosticError'
        hi['@tag']                      = 'TSTag'
        hi['@tag.attribute']            = 'TSAttribute'
        hi['@tag.delimiter']            = 'TSTagDelimiter'

        hi['@function.method']          = '@method'
        hi['@function.method.call']     = '@method.call'
        hi['@comment.error']            = '@text.danger'
        hi['@comment.warning']          = '@text.warning'
        hi['@comment.hint']             = 'DiagnosticHint'
        hi['@comment.info']             = 'DiagnosticInfo'
        hi['@comment.todo']             = '@text.todo'
        hi['@diff.plus']                = '@text.diff.add'
        hi['@diff.minus']               = '@text.diff.delete'
        hi['@diff.delta']               = 'DiffChange'
        hi['@string.special.url']       = '@text.uri'
        hi['@keyword.directive']        = '@preproc'
        hi['@keyword.directive.define'] = '@define'
        hi['@keyword.storage']          = '@storageclass'
        hi['@keyword.conditional']      = '@conditional'
        hi['@keyword.debug']            = '@debug'
        hi['@keyword.exception']        = '@exception'
        hi['@keyword.import']           = '@include'
        hi['@keyword.repeat']           = '@repeat'
        hi['@variable.parameter']       = '@parameter'
        hi['@variable.member']          = '@field'
        hi['@module']                   = '@namespace'
        hi['@number.float']             = '@float'
        hi['@string.special.symbol']    = '@symbol'
        hi['@string.regexp']            = '@string.regex'
        hi['@markup.strong']            = '@text.strong'
        hi['@markup.italic']            = 'Italic'
        hi['@markup.link']              = '@text.link'
        hi['@markup.strikethrough']     = '@text.strikethrough'
        hi['@markup.heading']           = '@text.title'
        hi['@markup.raw']               = '@text.literal'
        hi['@markup.link']              = '@text.reference'
        hi['@markup.link.url']          = '@text.uri'
        hi['@markup.link.label']        = '@string.special'
        hi['@markup.list']              = '@punctuation.special'
    end

    if M.config.ts_rainbow then
        hi.rainbowcol1 = { ctermfg = M.colors.cterm06 }
        hi.rainbowcol2 = { ctermfg = M.colors.cterm09  }
        hi.rainbowcol3 = { ctermfg = M.colors.cterm0A }
        hi.rainbowcol4 = { ctermfg = M.colors.cterm07  }
        hi.rainbowcol5 = { ctermfg = M.colors.cterm0C  }
        hi.rainbowcol6 = { ctermfg = M.colors.cterm0D  }
        hi.rainbowcol7 = { ctermfg = M.colors.cterm0E  }
    end

    hi.NvimInternalError = { ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm08, cterm = 'none' }

    hi.NormalFloat       = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.FloatBorder       = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.NormalNC          = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
    hi.TermCursor        = { ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm05, cterm = 'none' }
    hi.TermCursorNC      = { ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm05 }

    hi.User1             = { ctermfg = M.colors.cterm08, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.User2             = { ctermfg = M.colors.cterm0E, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.User3             = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.User4             = { ctermfg = M.colors.cterm0C, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.User5             = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.User6             = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm01, cterm = 'none' }
    hi.User7             = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.User8             = { ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm02, cterm = 'none' }
    hi.User9             = { ctermfg = M.colors.cterm00, ctermbg = M.colors.cterm02, cterm = 'none' }

    hi.TreesitterContext = { ctermfg = nil, ctermbg = M.colors.cterm01, cterm = 'italic' }

    if M.config.telescope then
        hi.TelescopeBorder       = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.TelescopePromptBorder = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.TelescopePromptNormal = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.TelescopePromptPrefix = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.TelescopeNormal       = { ctermbg = M.colors.cterm00 }
        hi.TelescopePreviewTitle = { ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm0B }
        hi.TelescopePromptTitle  = { ctermfg = M.colors.cterm01, ctermbg = M.colors.cterm08 }
        hi.TelescopeResultsTitle = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.TelescopeSelection    = { ctermbg = M.colors.cterm01 }
        hi.TelescopePreviewLine  = { ctermbg = M.colors.cterm01, cterm = 'none' }
    end

    if M.config.notify then
        hi.NotifyERRORBorder = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
        hi.NotifyWARNBorder  = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
        hi.NotifyINFOBorder  = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
        hi.NotifyDEBUGBorder = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
        hi.NotifyTRACEBorder = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
        hi.NotifyERRORIcon   = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
        hi.NotifyWARNIcon    = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
        hi.NotifyINFOIcon    = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
        hi.NotifyDEBUGIcon   = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
        hi.NotifyTRACEIcon   = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
        hi.NotifyERRORTitle  = { ctermfg = M.colors.cterm08, ctermbg = nil, cterm = 'none' }
        hi.NotifyWARNTitle   = { ctermfg = M.colors.cterm0E, ctermbg = nil, cterm = 'none' }
        hi.NotifyINFOTitle   = { ctermfg = M.colors.cterm05, ctermbg = nil, cterm = 'none' }
        hi.NotifyDEBUGTitle  = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
        hi.NotifyTRACETitle  = { ctermfg = M.colors.cterm0C, ctermbg = nil, cterm = 'none' }
        hi.NotifyERRORBody   = 'Normal'
        hi.NotifyWARNBody    = 'Normal'
        hi.NotifyINFOBody    = 'Normal'
        hi.NotifyDEBUGBody   = 'Normal'
        hi.NotifyTRACEBody   = 'Normal'
    end

    if M.config.indentblankline then
        hi.IndentBlanklineChar        = { ctermfg = M.colors.cterm02, cterm = 'nocombine' }
        hi.IndentBlanklineContextChar = { ctermfg = M.colors.cterm04, cterm = 'nocombine' }
        hi.IblIndent                  = { ctermfg = M.colors.cterm02, cterm = 'nocombine' }
        hi.IblWhitespace              = 'Whitespace'
        hi.IblScope                   = { ctermfg = M.colors.cterm04, cterm = 'nocombine' }
    end

    if M.config.cmp then
        hi.CmpDocumentationBorder   = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.CmpDocumentation         = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
        hi.CmpItemAbbr              = { ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm01 }
        hi.CmpItemAbbrDeprecated    = { ctermfg = M.colors.cterm03, ctermbg = nil, cterm = 'strikethrough' }
        hi.CmpItemAbbrMatch         = { ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemAbbrMatchFuzzy    = { ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindDefault       = { ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.CmpItemMenu              = { ctermfg = M.colors.cterm04, ctermbg = nil }
        hi.CmpItemKindKeyword       = { ctermfg = M.colors.cterm0E, ctermbg = nil }
        hi.CmpItemKindVariable      = { ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindConstant      = { ctermfg = M.colors.cterm09, ctermbg = nil }
        hi.CmpItemKindReference     = { ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindValue         = { ctermfg = M.colors.cterm09, ctermbg = nil }
        hi.CmpItemKindFunction      = { ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindMethod        = { ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindConstructor   = { ctermfg = M.colors.cterm0D, ctermbg = nil }
        hi.CmpItemKindClass         = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindInterface     = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindStruct        = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindEvent         = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindEnum          = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindUnit          = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindModule        = { ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.CmpItemKindProperty      = { ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindField         = { ctermfg = M.colors.cterm08, ctermbg = nil }
        hi.CmpItemKindTypeParameter = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindEnumMember    = { ctermfg = M.colors.cterm0A, ctermbg = nil }
        hi.CmpItemKindOperator      = { ctermfg = M.colors.cterm05, ctermbg = nil }
        hi.CmpItemKindSnippet       = { ctermfg = M.colors.cterm04, ctermbg = nil }
    end

    if M.config.illuminate then
        hi.IlluminatedWordText  = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
        hi.IlluminatedWordRead  = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
        hi.IlluminatedWordWrite = { ctermfg = nil, ctermbg = nil, cterm = 'underline' }
    end

    if M.config.lsp_semantic then
        hi['@class'] = 'TSType'
        hi['@struct'] = 'TSType'
        hi['@enum'] = 'TSType'
        hi['@enumMember'] = 'Constant'
        hi['@event'] = 'Identifier'
        hi['@interface'] = 'Structure'
        hi['@modifier'] = 'Identifier'
        hi['@regexp'] = 'TSStringRegex'
        hi['@typeParameter'] = 'Type'
        hi['@decorator'] = 'Identifier'

        hi['@lsp.type.namespace'] = '@namespace'
        hi['@lsp.type.type'] = '@type'
        hi['@lsp.type.class'] = '@type'
        hi['@lsp.type.enum'] = '@type'
        hi['@lsp.type.interface'] = '@type'
        hi['@lsp.type.struct'] = '@type'
        hi['@lsp.type.parameter'] = '@parameter'
        hi['@lsp.type.variable'] = '@variable'
        hi['@lsp.type.property'] = '@property'
        hi['@lsp.type.enumMember'] = '@constant'
        hi['@lsp.type.function'] = '@function'
        hi['@lsp.type.method'] = '@method'
        hi['@lsp.type.macro'] = '@function.macro'
        hi['@lsp.type.decorator'] = '@function'
    end

    if M.config.mini_completion then
        hi.MiniCompletionActiveParameter = 'CursorLine'
    end

    if M.config.dapui then
        hi.DapUINormal = 'Normal'
        hi.DapUINormal    = "Normal"
        hi.DapUIVariable  = "Normal"
        hi.DapUIScope     = { ctermfg = M.colors.cterm0D }
        hi.DapUIType      = { ctermfg = M.colors.cterm0E }
        hi.DapUIValue     = "Normal"
        hi.DapUIModifiedValue = { ctermfg = M.colors.cterm0D, cterm = "bold" }
        hi.DapUIDecoration = { ctermfg = M.colors.cterm0D }
        hi.DapUIThread    = { ctermfg = M.colors.cterm0B }
        hi.DapUIStoppedThread = { ctermfg = M.colors.cterm0D }
        hi.DapUIFrameName = "Normal"
        hi.DapUISource    = { ctermfg = M.colors.cterm0E }
        hi.DapUILineNumber = { ctermfg = M.colors.cterm0D }
        hi.DapUIFloatNormal = "NormalFloat"
        hi.DapUIFloatBorder = { ctermfg = M.colors.cterm0D }
        hi.DapUIWatchesEmpty = { ctermfg = M.colors.cterm08 }
        hi.DapUIWatchesValue = { ctermfg = M.colors.cterm0B }
        hi.DapUIWatchesError = { ctermfg = M.colors.cterm08 }
        hi.DapUIBreakpointsPath = { ctermfg = M.colors.cterm0D }
        hi.DapUIBreakpointsInfo = { ctermfg = M.colors.cterm0B }
        hi.DapUIBreakpointsCurrentLine = { ctermfg = M.colors.cterm0B, cterm = "bold" }
        hi.DapUIBreakpointsLine = "DapUILineNumber"
        hi.DapUIBreakpointsDisabledLine = { ctermfg = M.colors.cterm02 }
        hi.DapUICurrentFrameName = "DapUIBreakpointsCurrentLine"
        hi.DapUIStepOver  = { ctermfg = M.colors.cterm0D }
        hi.DapUIStepInto  = { ctermfg = M.colors.cterm0D }
        hi.DapUIStepBack  = { ctermfg = M.colors.cterm0D }
        hi.DapUIStepOut   = { ctermfg = M.colors.cterm0D }
        hi.DapUIStop      = { ctermfg = M.colors.cterm08 }
        hi.DapUIPlayPause = { ctermfg = M.colors.cterm0B }
        hi.DapUIRestart   = { ctermfg = M.colors.cterm0B }
        hi.DapUIUnavailable = { ctermfg = M.colors.cterm02 }
        hi.DapUIWinSelect = { ctermfg = M.colors.cterm0D, cterm = "bold" }
        hi.DapUIEndofBuffer = "EndOfBuffer"
        hi.DapUINormalNC  = "Normal"
        hi.DapUIPlayPauseNC = { ctermfg = M.colors.cterm0B }
        hi.DapUIRestartNC = { ctermfg = M.colors.cterm0B }
        hi.DapUIStopNC    = { ctermfg = M.colors.cterm08 }
        hi.DapUIUnavailableNC = { ctermfg = M.colors.cterm02 }
        hi.DapUIStepOverNC = { ctermfg = M.colors.cterm0D }
        hi.DapUIStepIntoNC = { ctermfg = M.colors.cterm0D }
        hi.DapUIStepBackNC = { ctermfg = M.colors.cterm0D }
        hi.DapUIStepOutNC = { ctermfg = M.colors.cterm0D }
    end


    vim.g.terminal_color_0  = M.colors.cterm00
    vim.g.terminal_color_1  = M.colors.cterm08
    vim.g.terminal_color_2  = M.colors.cterm0B
    vim.g.terminal_color_3  = M.colors.cterm0A
    vim.g.terminal_color_4  = M.colors.cterm0D
    vim.g.terminal_color_5  = M.colors.cterm0E
    vim.g.terminal_color_6  = M.colors.cterm0C
    vim.g.terminal_color_7  = M.colors.cterm05
    vim.g.terminal_color_8  = M.colors.cterm03
    vim.g.terminal_color_9  = M.colors.cterm08
    vim.g.terminal_color_10 = M.colors.cterm0B
    vim.g.terminal_color_11 = M.colors.cterm0A
    vim.g.terminal_color_12 = M.colors.cterm0D
    vim.g.terminal_color_13 = M.colors.cterm0E
    vim.g.terminal_color_14 = M.colors.cterm0C
    vim.g.terminal_color_15 = M.colors.cterm07

end

function M.available_colorschemes()
    return vim.tbl_keys(M.colorschemes)
end

M.colorschemes = {}
setmetatable(M.colorschemes, {
    __index = function(t, key)
        t[key] = require(string.format('colors.%s', key))
        return t[key]
    end,
})

-- Default ANSI colorscheme mapping
M.colorschemes['schemer-dark'] = {
    base00 = 0, base01 = 8, base02 = 8, base03 = 8,
    base04 = 7, base05 = 15, base06 = 7, base07 = 15,
    base08 = 1, base09 = 3, base0A = 3, base0B = 2,
    base0C = 6, base0D = 4, base0E = 5, base0F = 8,
    cterm00 = 0, cterm01 = 8, cterm02 = 8, cterm03 = 8,
    cterm04 = 7, cterm05 = 15, cterm06 = 7, cterm07 = 15,
    cterm08 = 1, cterm09 = 3, cterm0A = 3, cterm0B = 2,
    cterm0C = 6, cterm0D = 4, cterm0E = 5, cterm0F = 8,
}
M.colorschemes['schemer-medium'] = {
    base00 = 0, base01 = 8, base02 = 8, base03 = 8,
    base04 = 7, base05 = 15, base06 = 7, base07 = 15,
    base08 = 1, base09 = 3, base0A = 3, base0B = 2,
    base0C = 6, base0D = 4, base0E = 5, base0F = 8,
    cterm00 = 0, cterm01 = 8, cterm02 = 8, cterm03 = 8,
    cterm04 = 7, cterm05 = 15, cterm06 = 7, cterm07 = 15,
    cterm08 = 1, cterm09 = 3, cterm0A = 3, cterm0B = 2,
    cterm0C = 6, cterm0D = 4, cterm0E = 5, cterm0F = 8,
}

M.load_from_shell = function()
    -- tinted-theming/base16-shell uses XDG_CONFIG_PATH if present.
    local config_dir = vim.env.XDG_CONFIG_HOME
    if config_dir == nil or config_dir == '' then
        config_dir = '~/.config'
    end

    local shell_theme_paths = {
        -- tinted-theming/base16-shell writes this file
        config_dir .. "/tinted-theming/set_theme.lua",
        -- chriskempson/base16-shell writes this file
        "~/.vimrc_background",
    }

    for _, path in pairs(shell_theme_paths) do
        local is_readable = vim.fn.filereadable(vim.fn.expand(path)) == 1
        if is_readable then
            vim.cmd([[let base16colorspace=256]])
            vim.cmd("source " .. path)
            return path
        end
    end
    return false
end

return M
