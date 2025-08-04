-- credit: Grok helped me out with this whole thing! Thanks, Grok, you little fucker!

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
local function update_results(results_buf, query, file_list)
    local filtered = {}
    for _, file in ipairs(file_list) do
        local score = fuzzy_score(query, file)
        if score then
            table.insert(filtered, { file = file, score = score })
        end
    end
    table.sort(filtered, function(a, b)
        if a.score > b.score then return true end
        if a.score < b.score then return false end
        return #a.file < #b.file
    end)
    local lines = {}
    for _, item in ipairs(filtered) do
        table.insert(lines, item.file)
    end
    vim.api.nvim_buf_set_option(results_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(results_buf, "modifiable", false)

    -- Clear existing highlights
    vim.api.nvim_buf_clear_namespace(results_buf, -1, 0, -1)

    local selected = { index = nil }

    -- Set selection to 1 if possible
    if #lines > 0 then
        selected.index = 1
        vim.api.nvim_buf_add_highlight(results_buf, -1, "Visual", 0, 0, -1)
    end

    -- update variable
    vim.api.nvim_buf_set_var(results_buf, "fuzzy_selected", selected)
end

local function open_fuzzy_finder()
    local cmdout = vim.trim(vim.fn.system("fd . --type file 2>/dev/null"))
    local file_list = vim.split(cmdout, "\n")

    local input_buf = vim.api.nvim_create_buf(false, true)
    local results_buf = vim.api.nvim_create_buf(false, true)

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

    vim.api.nvim_buf_set_option(results_buf, "modifiable", false)

    -- Set selected state on results_buf
    vim.api.nvim_buf_set_var(results_buf, "fuzzy_selected", { index = nil })

    local augroup = vim.api.nvim_create_augroup("FuzzyFinder", { clear = true })
    vim.api.nvim_create_autocmd("TextChangedI", {
        group = augroup,
        buffer = input_buf,
        callback = function()
            local query = vim.api.nvim_get_current_line()
            update_results(results_buf, query, file_list)
        end,
    })

    -- Initial update
    update_results(results_buf, "", file_list)

    -- Close on BufLeave input (includes mouse enter results or other leaves)
    vim.api.nvim_create_autocmd("BufLeave", {
        group = augroup,
        buffer = input_buf,
        callback = function()
            vim.cmd("stopinsert")
            pcall(vim.api.nvim_win_close, input_win, true)
            pcall(vim.api.nvim_win_close, results_win, true)
        end,
    })

    -- Keymaps in input (insert mode)
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

    vim.api.nvim_buf_set_keymap(input_buf, "i", "<CR>", "", {
        callback = function()
            vim.cmd("stopinsert")
            local selected = vim.api.nvim_buf_get_var(results_buf, "fuzzy_selected")
            if selected.index then
                local line = vim.api.nvim_buf_get_lines(results_buf, selected.index - 1, selected.index, false)[1]
                if vim.api.nvim_win_is_valid(input_win) then
                    vim.api.nvim_win_close(input_win, true)
                end
                if vim.api.nvim_win_is_valid(results_win) then
                    vim.api.nvim_win_close(results_win, true)
                end
                vim.cmd("edit " .. vim.fn.fnameescape(line))
            end
        end,
    })

    local function move_selection(delta)
        local selected = vim.api.nvim_buf_get_var(results_buf, "fuzzy_selected")
        local line_count = vim.api.nvim_buf_line_count(results_buf)
        if line_count == 0 or not selected.index then return end
        local new_index = selected.index + delta
        if new_index < 1 then new_index = line_count end
        if new_index > line_count then new_index = 1 end

        -- Clear old hl
        vim.api.nvim_buf_clear_namespace(results_buf, -1, selected.index - 1, selected.index)

        selected.index = new_index
        vim.api.nvim_buf_set_var(results_buf, "fuzzy_selected", selected)  -- Update var

        -- Add new hl
        vim.api.nvim_buf_add_highlight(results_buf, -1, "Visual", new_index - 1, 0, -1)
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

    vim.cmd("startinsert")
end

-- Keymap
vim.keymap.set("n", "<Leader>/f", open_fuzzy_finder)
