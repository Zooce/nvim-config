-- credit: Grok helped me out with this whole thing! Thanks, Grok, you little fucker!

-- Some notes on how this all works:
--
-- We've got two buffers (and two windows to show them):
--  * One for user input (the "query")
--  * One for the matched results
--
-- The results buffer stores some state variables:
--  * mode = either "files" or "grep" -- tells us what kind of search we're doing
--  * files = the set of files to query on (only in "files" mode)
--  * results = the set of matching results
--      * file = the file this result is tied to
--      * display = the fancy display string (only in "grep" mode)
--      * line = the line number in the file (only in "grep" mode)
--  * selected = the currently selected index in `results`

-- This fuzzy scoring gives precedence to longest contiguous match. Nothing super
-- smart but it gives good results.
local function fuzzy_score(needle, haystack)
    needle = needle:lower()
    haystack = haystack:lower()
    local i = 1
    local max_streak = 0
    local current_streak = 0
    local prev_matched = false
    for j = 1, #haystack do
        if haystack:sub(j, j) == needle:sub(i, i) then
            i = i + 1
            if prev_matched then
                current_streak = current_streak + 1
            else
                current_streak = 1
            end
            if current_streak > max_streak then
                max_streak = current_streak
            end
            prev_matched = true
            if i > #needle then
                break
            end
        else
            prev_matched = false
        end
    end
    if i <= #needle then
        return nil
    end
    return max_streak
end

-- Filter the files list based on the given query string.
local function fuzzy_files(results_buf, query)
    local files = vim.api.nvim_buf_get_var(results_buf, "files")

    -- compute the results of the query - all files for empty query
    local results = {}
    for _, file in ipairs(files) do
        if #query == 0 then
            table.insert(results, { file = file })
        else
            local score = fuzzy_score(query, file)
            if score then
                table.insert(results, { file = file, score = score })
            end
        end
    end

    -- sort by score
    if #query ~= 0 then
        table.sort(results, function(a, b)
            return a.score > b.score
        end)
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

local function grep_files(results_buf, query)
    -- empty query means empty results
    if #query == 0 then
        vim.api.nvim_buf_set_var(results_buf, "results", {})
        return {}
    end

    -- grepity grep
    local cmdout = vim.fn.system("rg -i -n --no-heading " .. vim.fn.shellescape(query))
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
    else
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
local function open(mode)
    local input_buf = vim.api.nvim_create_buf(false, true)
    local results_buf = vim.api.nvim_create_buf(false, true)

    -- store some state in the results buffer
    vim.api.nvim_buf_set_var(results_buf, "mode", mode)
    vim.api.nvim_buf_set_var(results_buf, "selected", nil)
    if mode == "files" then
        local cmdout = vim.fn.system("fd . -t f 2>/dev/null")
        local files = vim.split(vim.trim(cmdout), "\n")
        vim.api.nvim_buf_set_var(results_buf, "files", files)
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

local M = {}
M.open = open
return M
