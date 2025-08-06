local mode_names = {
    n = "NORMAL",
    no = "NORMAL",
    nov = "NORMAL",
    noV = "NORMAL",
    ["no\22"] = "NORMAL",
    niI = "NORMAL",
    niR = "NORMAL",
    niV = "NORMAL",
    nt = "NORMAL",
    v = "VISUAL",
    vs = "VISUAL",
    V = "V-LINE",
    Vs = "V-LINE",
    ["\22"] = "V-BLOCK",
    ["\22s"] = "V-BLOCK",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    i = "INSERT",
    ic = "INSERT",
    ix = "INSERT",
    R = "REPLACE",
    Rc = "REPLACE",
    Rx = "REPLACE",
    Rv = "REPLACE",
    Rvc = "REPLACE",
    Rvx = "REPLACE",
    c = "COMMAND",
    cv = "EX",
    r = "PROMPT",
    rm = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    t = "TERMINAL",
}

local mode_hl_groups = {
    NORMAL = "StatusLineModeNormal",
    VISUAL = "StatusLineModeVisual",
    ["V-LINE"] = "StatusLineModeVisual",
    ["V-BLOCK"] = "StatusLineModeVisual",
    SELECT = "StatusLineModeVisual",
    ["S-LINE"] = "StatusLineModeVisual",
    ["S-BLOCK"] = "StatusLineModeVisual",
    INSERT = "StatusLineModeInsert",
    REPLACE = "StatusLineModeInsert",
    COMMAND = "StatusLineModeCommand",
    EX = "StatusLineModeCommand",
    PROMPT = "StatusLineModeCommand",
    MORE = "StatusLineModeCommand",
    CONFIRM = "StatusLineModeCommand",
    SHELL = "StatusLineModeTerminal",
    TERMINAL = "StatusLineModeTerminal",
}

local function get_mode()
    local code = vim.api.nvim_get_mode().mode
    local name = mode_names[code] or "NORMAL"
    local hl = mode_hl_groups[name] or "StatusLineNormal"
    return "%#" .. hl .. "# " .. name .. " "
end

local function get_filename()
    local name = vim.fn.expand("%:t")
    return "%#StatusLineFileName# " .. (name == "" and "[New File]" or name) .. " %*"
end

local function get_git_branch()
    local dir = vim.fn.expand("%:p:h")
    local branch = vim.fn.system(string.format("git -C %s branch --show-current 2>/dev/null", vim.fn.shellescape(dir))):gsub("\n$", "")
    if branch == "" then
        return ""
    end
    return "%#StatusLineGitBranch# " .. branch
end

local function get_git_changes()
    local dir = vim.fn.expand("%:p:h")
    local raw = vim.fn.system(string.format("git -C %s diff --shortstat HEAD 2>/dev/null", vim.fn.shellescape(dir))):gsub("\n$", "")
    if raw == "" then
        return ""
    end
    local files = raw:match("(%d+) files? changed") or ""
    local insertions = raw:match("(%d+) insertions?%(%+%)") or "0"
    local deletions = raw:match("(%d+) deletions?%(%-%)") or "0"
    if files == "" then
        return ""
    end
    return "%#Added# +" .. insertions .. " %#Removed#-" .. deletions .. "%*"
end

local diagnostic_hl_groups = {
    E = "%#DiagnosticError#",
    W = "%#DiagnosticWarn#",
    I = "%#DiagnosticInfo#",
    H = "%#DiagnosticHint#",
}

local function get_diagnostics()
    local counts = {
        { "E", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) },
        { "W", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) },
        { "H", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) },
        { "I", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) },
    }

    local parts = {}
    for _, v in ipairs(counts) do
        local k = v[1]
        if v[2] > 0 then
            table.insert(parts, diagnostic_hl_groups[k] .. v[2] .. "%*")
        end
    end
    if #parts == 0 then
        return ""
    end
    return table.concat(parts, " ")
end

local function get_encoding()
    local enc = vim.bo.fileencoding
    return "%#StatusLineFileInfo# " .. (enc ~= "" and  enc or vim.o.encoding)
end

local function get_filetype()
    if vim.bo.filetype == "" then
        return ""
    end
   return "%#StatusLineFileName# " .. vim.bo.filetype .. " "
end

local function statusline()
    local left_parts = {
        get_mode(),
        get_filename(),
        get_git_branch(),
        get_git_changes(),
    }
    local left = table.concat(vim.tbl_filter(function(s) return s ~= "" end, left_parts), "")

    local right_parts = {
        get_diagnostics(),
        get_encoding(),
        " " .. vim.bo.fileformat .. " ",
        get_filetype(),
    }
    local right = table.concat(vim.tbl_filter(function(s) return s ~= "" end, right_parts), "")

    return left .. "%=" .. right
end

return statusline
