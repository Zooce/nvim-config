-- credit: Grok helped me out with this whole thing! Thanks, Grok, you little fucker!

-- Some notes on how this all works:
--
-- We've got two buffers (and two windows to show them):
--  * One for user input (the "query")
--  * One for the matched results
--
-- The results buffer stores some state variables:
--  * mode = either "files" or "grep" -- tells us what kind of search we're doing
--  * results = the set of matching results
--      * file = the file this result is tied to
--      * display = the fancy display string (only in "grep" mode)
--      * line = the line number in the file (only in "grep" mode)
--  * selected = the currently selected index in `results`

local M = {}

-- Filter the files list based on the given query string.
local function fuzzy_files(results_buf, query)
    local cmd = "fd . -I -t f --hidden -E .git -E node_modules -E vendor"
    local files = {}
    if #query > 0 then
        cmd = cmd .. " | fzf --scheme=path -f " .. query
    end
    local cmdout = vim.fn.system(cmd)
    files = vim.split(vim.trim(cmdout), "\n")
    local results = {}
    for _, file in ipairs(files) do
        table.insert(results, { file = file })
    end

    -- save the results
    vim.api.nvim_buf_set_var(results_buf, "results", results)

    -- only need the files for the buffer
    local buffer_lines = {}
    for _, item in ipairs(results) do
        table.insert(buffer_lines, item.file)
    end
    return buffer_lines
end

local function fuzzy_references(results_buf, query)
    local references = vim.api.nvim_buf_get_var(results_buf, "references")
    local results = {}

    if #references == 0 or #query == 0 then
        results = references
    else
        -- we only need to fuzzy on the file names, and to reduce the work `fzf` needs
        -- to do, we're not going to send duplicate file names to it
        local seen = {}
        local files = {}
        for _, reference in ipairs(references) do
            if not seen[reference.file] then
                seen[reference.file] = true
                table.insert(files, reference.file)
            end
        end
        local fzf_input = table.concat(files, "\n")
        local cmd = "printf " .. vim.fn.shellescape(fzf_input) .. " | fzf --scheme=path -f " .. query
        local cmdout = vim.fn.system(cmd)
        files = vim.split(vim.trim(cmdout), "\n")
        for _, reference in ipairs(references) do
            for _, file in ipairs(files) do
                if reference.file == file then
                    table.insert(results, reference)
                    break
                end
            end
        end
    end

    vim.api.nvim_buf_set_var(results_buf, "results", references)

    -- take the display property for the result buffer
    local buffer_lines = {}
    for _, item in ipairs(results) do
        table.insert(buffer_lines, item.display)
    end
    return buffer_lines
end

-- Search files in the current directory for the query.
local function grep_files(results_buf, regex)
    -- empty query means empty results
    if #regex == 0 then
        vim.api.nvim_buf_set_var(results_buf, "results", {})
        return {}
    end

    -- grepity grep
    local cmdout = vim.fn.system("rg -i -n --no-heading " .. vim.fn.shellescape(regex))
    local rg_results = vim.split(vim.trim(cmdout), "\n")

    -- parse the rg results
    local results = {}
    for _, rg_res in ipairs(rg_results) do
        if rg_res ~= "" then
            local file, lnum, text = rg_res:match("^([^:]+):(%d+):(.*)$")
            if file and lnum and text then
                local display = file .. ":" .. lnum .. "  " .. vim.trim(text)
                table.insert(results, { display = display, file = file, line = tonumber(lnum) })
            end
        end
    end

    -- save the results
    vim.api.nvim_buf_set_var(results_buf, "results", results)

    -- take the display property for the result buffer
    local buffer_lines = {}
    for _, item in ipairs(results) do
        table.insert(buffer_lines, item.display)
    end
    return buffer_lines
end

local function update_results(results_buf, query)
    local mode = vim.api.nvim_buf_get_var(results_buf, "mode")

    local buffer_lines = {}
    if mode == "files" then
        buffer_lines = fuzzy_files(results_buf, query)
    elseif mode == "references" then
        buffer_lines = fuzzy_references(results_buf, query)
    elseif mode == "grep" then
        buffer_lines = grep_files(results_buf, query)
    end

    vim.api.nvim_buf_set_option(results_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, buffer_lines)
    vim.api.nvim_buf_set_option(results_buf, "modifiable", false)

    -- clear existing highlights
    vim.api.nvim_buf_clear_namespace(results_buf, -1, 0, -1)

    local selected = nil

    -- set selection to 1 if possible
    if #buffer_lines > 0 then
        selected = 1
        vim.api.nvim_buf_add_highlight(results_buf, -1, "Visual", 0, 0, -1)
    end

    -- update variable
    vim.api.nvim_buf_set_var(results_buf, "selected", selected)
end

-- Open two windows, one for an input and one for the matching results.
function M.open(mode, opts)
    local input_buf = vim.api.nvim_create_buf(false, true)
    local results_buf = vim.api.nvim_create_buf(false, true)

    -- store some state in the results buffer
    vim.api.nvim_buf_set_var(results_buf, "mode", mode)
    vim.api.nvim_buf_set_var(results_buf, "selected", nil)
    if opts and opts.references then
        vim.api.nvim_buf_set_var(results_buf, "references", opts.references)
    end

    -- the results buffer is not modifiable (by the user that is)
    vim.api.nvim_buf_set_option(results_buf, "modifiable", false)

    -- initial update
    update_results(results_buf, "")

    -- build and show the windows
    local width = math.floor(vim.o.columns * 0.8)
    local height = 1
    local row = math.floor((vim.o.lines - 20) / 2) - 1
    local col = math.floor((vim.o.columns - width) / 2)

    local input_win = vim.api.nvim_open_win(input_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "single",
    })

    local results_win = vim.api.nvim_open_win(results_buf, false, {
        relative = "editor",
        width = width,
        height = 15,
        row = row + 2,
        col = col,
        style = "minimal",
        border = "single",
    })

    local augroup = vim.api.nvim_create_augroup("Finder", { clear = true })
    vim.api.nvim_create_autocmd("TextChangedI", {
        group = augroup,
        buffer = input_buf,
        callback = function()
            local query = vim.api.nvim_get_current_line()
            update_results(results_buf, query)
        end,
    })

    -- close on BufLeave input (includes mouse enter results or other leaves)
    vim.api.nvim_create_autocmd("BufLeave", {
        group = augroup,
        buffer = input_buf,
        callback = function()
            vim.cmd("stopinsert")
            pcall(vim.api.nvim_win_close, input_win, true)
            pcall(vim.api.nvim_win_close, results_win, true)
        end,
    })

    -- close the finder windows if ESC is pressed
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<Esc>", "", {
        callback = function()
            vim.cmd("stopinsert")
            if vim.api.nvim_win_is_valid(input_win) then
                vim.api.nvim_win_close(input_win, true)
            end
            if vim.api.nvim_win_is_valid(results_win) then
                vim.api.nvim_win_close(results_win, true)
            end
        end,
    })

    -- open the selected file on ENTER and close the finder windows
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<CR>", "", {
        callback = function()
            vim.cmd("stopinsert")
            local selected = vim.api.nvim_buf_get_var(results_buf, "selected")
            local results = vim.api.nvim_buf_get_var(results_buf, "results")
            if selected and #results > 0 then
                local result = results[selected]

                if vim.api.nvim_win_is_valid(input_win) then
                    vim.api.nvim_win_close(input_win, true)
                end
                if vim.api.nvim_win_is_valid(results_win) then
                    vim.api.nvim_win_close(results_win, true)
                end
                local cmd = "edit"
                if result.line then
                    cmd = cmd .. " +" .. result.line
                end
                vim.cmd(cmd .. " " .. vim.fn.fnameescape(result.file))
            end
        end,
    })

    -- selecing options ...

    local function move_selection(delta)
        local selected = vim.api.nvim_buf_get_var(results_buf, "selected")
        local line_count = vim.api.nvim_buf_line_count(results_buf)
        if line_count == 0 or not selected then return end

        local new_index = selected + delta
        if new_index < 1 then new_index = line_count end
        if new_index > line_count then new_index = 1 end
        vim.api.nvim_buf_set_var(results_buf, "selected", new_index)

        vim.api.nvim_buf_clear_namespace(results_buf, -1, selected - 1, selected)
        vim.api.nvim_buf_add_highlight(results_buf, -1, "Visual", new_index - 1, 0, -1)
        vim.api.nvim_win_set_cursor(results_win, {new_index, 0})
    end

    vim.api.nvim_buf_set_keymap(input_buf, "i", "<Down>", "", {
        callback = function() move_selection(1) end
    })
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<Up>", "", {
        callback = function() move_selection(-1) end
    })
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<Tab>", "", {
        callback = function() move_selection(1) end
    })
    vim.api.nvim_buf_set_keymap(input_buf, "i", "<S-Tab>", "", {
        callback = function() move_selection(-1) end
    })

    -- always start in INSERT mode.....OB VI OUS LY
    vim.cmd("startinsert")
end

function M.async_open_references()
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    vim.lsp.buf_request_all(bufnr, "textDocument/references", function(client)
        local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
        params.context = { includeDeclarations = true }
        return params
    end, function(responses)
        local results = {}
        for _, response in pairs(responses) do
            if response.result then
                for _, location in ipairs(response.result) do
                    local file = vim.fn.fnamemodify(vim.uri_to_fname(location.uri or location.targetUri), ":.")
                    local range = location.range or location.targetSelectionRange
                    local lnum = range.start.line + 1
                    local buf = vim.fn.bufadd(file)
                    vim.fn.bufload(buf)
                    local text = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
                    local display = file .. ":" .. lnum .. "  " .. vim.trim(text)
                    table.insert(results, { display = display, file = file, line = lnum })
                end
            end
            if response.error then
                vim.notify(response.error.message)
            end
        end
        if #results == 0 then
            vim.notify("No references")
            return
        end
        open("references", { references = results })
    end)
end

return M
