local palette = {
  name = "indomitable",

  -- basics
  foreground = "#e6e6e6",
  background = "#212121",

  -- tokens
  punctuation = "#999999",
  keywords = "#d35568",
  functions = "#d3a355",
  strings = "#a5d355",
  constants = "#55d3c2",
  comments = "#5585d3",
  other = "#a96eb9",
  changed = "#fdbe00",
  deleted = "#e83841",
  inserted = "#85db18",

  -- editor
  line_highlight = "#000000",
  accent = "#2f61b1",
  selection = "#264f78",
  selection_dim = "#162d45",
  punctuation_dim = "#555555",
  punctuation_dimmer = "#333333",
}

local theme_specs = {
    Normal = {
        hl = { fg = palette.foreground, bg = palette.background },
        links = {
            "LspInfoBorder",
        }
    },
    Foreground = {
        hl = { fg = palette.foreground },
        links = {
            "Identifier",
            "Type",
            "Title",
            "@lsp.typemod.type",
            -- "@lsp.typemod.variable.local",
            "@lsp.type.namespace.rust",
        },
    },
    Search = {
        hl = { fg = palette.line_highlight, bg = palette.constants },
        links = {
            "IncSearch",
        },
    },
    Whitespace = {
        hl = { fg = palette.punctuation_dimmer },
    },
    Underlined = {
        hl = { fg = palette.foreground, underline = true },
    },
    Todo = {
        hl = { fg = palette.line_highlight, bg = palette.foreground, bold = true },
        links = {
            "@text.todo",
        },
    },
    NonText = { hl = { fg = palette.punctuation_dim } },
    ["@text.uri"] = {
        hl = { fg = palette.strings, underline = true },
    },

    --
    -- Editor theme highlight groups
    --
    CursorLine = { hl = { bg = palette.line_highlight } },
    CursorLineNr = { hl = { link = "CursorLine", bold = true } },
    CursorColumn = { hl = { bg = palette.punctuation_dimmer } },
    ColorColumn = { hl = { bg = palette.punctuation_dimmer } },
    SignColumn = { hl = { link = "Normal" } },
    LineNr = { hl = { fg = palette.punctuation_dim } },
    Visual = { hl = { bg = palette.selection } },
    VisualNC = { hl = { bg = palette.selection_dim } },
    MatchParen = { hl = { fg = palette.inserted, bg = palette.line_highlight, sp = palette.inserted, bold = true } },
    StatusLine = { hl = { fg = "White", bg = palette.punctuation_dimmer } },
    Folded = { hl = { bg = palette.punctuation_dimmer } },
    ErrorMsg = { hl = { fg = palette.deleted } },
    WarningMsg = { hl = { fg = palette.changed } },
    DiffAdd = { hl = { fg = palette.inserted, } },
    DiffChange = { hl = { fg = palette.changed, } },
    DiffDelete = { hl = { fg = palette.deleted, } },
    DiffText = { hl = { fg = palette.foreground, } },
    Added = { hl = { fg = palette.inserted } },
    Changed = { hl = { fg = palette.changed, } },
    Removed = { hl = { fg = palette.deleted, } },
    NvimInternalError = { hl = { fg = palette.deleted } },
    Pmenu = { hl = { fg = palette.foreground } },

    --
    -- Diagnostics
    --
    DiagnosticOk = { hl = { fg = palette.inserted } },
    DiagnosticHint = { hl = { fg = palette.constants } },
    DiagnosticInfo = { hl = { fg = palette.foreground } },
    DiagnosticWarn = { hl = { fg = palette.changed } },
    DiagnosticError = { hl = { fg = palette.deleted } },
    DiagnosticUnnecessary = { hl = { fg = palette.foreground, bg = palette.comments } },
    DiagnosticUnderlineOk =  { hl = { bg = palette.inserted, fg = "Black", bold = true } },
    DiagnosticUnderlineWarn = { hl = { bg = palette.changed, fg = "Black", bold = true } },
    DiagnosticUnderlineError = { hl = { bg = palette.deleted, fg = "White", bold = true } },

    --
    -- Basic theme highlight groups
    --
    Punctuation = {
        hl = { fg = palette.punctuation },
        links = {
            "@attribute",
            "@constructor.lua",
            "@keyword.jsdoc",
            "@punctuation",
            "@punctuation.special",
            "@tag.delimiter",
            "@conceal",
            "Conceal",
            "@string.special.path.diff",
            "htmlTag",
            "htmlEndTag",
            "@markup.list.markdown",
            "@markup.raw.delimiter.markdown",
            "@markup.raw.delimiter.markdown_inline",
            "markdownListMarker",
            "markdownOrderedListMarker",
            "markdownLinkTextDelimiter",
            "markdownLinkDelimiter",
            "markdownIdDelimiter",
            "markdownItalicDelimiter",
            "markdownBoldDelimiter",
            "markdownRule",
            "markdownCodeDelimiter",
        },
    },
    Statement = {
        hl = { fg = palette.keywords },
        links = {
            "@include",
            "@lsp.type.keyword",
            -- "@lsp.type.keywordLiteral.zig",
            "@lsp.type.operator",
            "@operator",
            -- "@lsp.type.type.zig",
            "@tag",
            "@type.builtin",
            "@type.qualifier",
            "PreProc",
            "StorageClass",
            "htmlTagName",
            "htmlTagN",
            "csType",
            "@type.ini",
            "@property.json",
            "@property.jsonc",
            "@markup.heading.1.markdown",
            "@markup.heading.2.markdown",
            "@markup.heading.3.markdown",
            "@markup.heading.4.markdown",
            "@markup.heading.5.markdown",
            "@markup.heading.6.markdown",
            "@markup.heading.1.marker.markdown",
            "@markup.heading.2.marker.markdown",
            "@markup.heading.3.marker.markdown",
            "@markup.heading.4.marker.markdown",
            "@markup.heading.5.marker.markdown",
            "@markup.heading.6.marker.markdown",
            "@markup.list.unchecked.markdown",
            "markdownH1",
            "markdownH2",
            "markdownH3",
            "markdownH4",
            "markdownH5",
            "markdownH6",
            "markdownH1Delimiter",
            "markdownH2Delimiter",
            "markdownH3Delimiter",
            "markdownH4Delimiter",
            "markdownH5Delimiter",
            "markdownH6Delimiter",
            "markdownHeadingRule",
            "@lsp.type.builtinType.rust",
            "@type.tomle",
        },
    },
    Function = {
        hl = { fg = palette.functions },
        links = {
            "@constructor",
            "@function.builtin",
            "@function.call",
            "@tag.attribute",
            "htmlArg",
            "@type.css",
            "@type.scss",
            "@markup.quote.markdown",
            "@markup.italic.markdown_inline",
            "@markup.strong.markdown_inline",
            "markdownBlockquote",
            "markdownItelic",
            "markdownBold",
        },
    },
    String = {
        hl = { fg = palette.strings },
        links = {
            "@text.quote",
            "@text.ini",
            "@markup.link.markdown_inline",
            "@markup.link.label.markdown_inline",
            "@markup.link.label.markdown",
            "@markup.list.checked.markdown",
            "markdownLinkText",
            "markdownIdDeclaration",
        },
    },
    Constant = {
        hl = { fg = palette.constants },
        links = {
            "@constant.builtin",
            "@function.macro",
            "@string.escape",
            "@text.literal",
            "@variable.builtin",
            "@lsp.type.enumMember",
            "Macro",
            "@markup.raw.markdown_inline",
            "@markup.raw.block.markdown",
            "markdownCode",
            "markdownCodeBlock",
        },
    },
    Comment = {
        hl = { fg = palette.comments },
        links = {
            "@string.documentation",
            "@lsp.mod.documentation",
            "@markup.link.url.markdown_inline",
            "@markup.link.url.markdown",
            "markdownLinkUrl",
            "markdownId",
        },
    },
    Special = {
        hl = { fg = palette.other, underline = false },
        links = {
            "@constant",
            "@markup.heading.1.delimiter.vimdoc",
            "@markup.heading.2.delimiter.vimdoc",
            -- "@lsp.type.builtin.zig",
            "@lsp.typemod.variable.constant",
            -- "@lsp.mod.readonly",
            -- "@lsp.typemod.variable.readonly",
            "@keyword.conditional.angular",
            "@variable.scss",
            "@variable.parameter.scss",
        },
    },

    -- status line groups
    StatusLineModeNormal = {
        hl = { fg = "Black", bg = palette.punctuation },
    },
    StatusLineModeInsert = {
        hl = { fg = "Black", bg = palette.strings, bold = true },
    },
    StatusLineModeVisual = {
        hl = { fg = "Black", bg = palette.functions, bold = true },
    },
    StatusLineModeCommand = {
        hl = { fg = "Black", bg = palette.foreground, bold = true },
    },
    StatusLineModeTerminal = {
        hl = { fg = "Black", bg = palette.other, bold = true },
    },
    StatusLineFileName = {
        hl = { fg = palette.foreground, bg = palette.punctuation_dim },
    },
    StatusLineFileInfo = {
        hl = { fg = palette.punctuation },
    },
    StatusLineGitBranch = {
        hl = { fg = palette.foreground, bg = palette.punctuation_dimmer },
    },
}

local function load()
    for main_group, spec in pairs(theme_specs) do
        vim.api.nvim_set_hl(0, main_group, spec.hl)
        if spec.links then
            for _, group in ipairs(spec.links) do
                vim.api.nvim_set_hl(0, group, { link = main_group })
            end
        end
    end
end

local M = {}
M.load = load
return M
