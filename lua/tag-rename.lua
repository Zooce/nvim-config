-- ================================================================================
--
--
-- TAG RENAME
--
--
-- ================================================================================

local function rename_tag()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr)
    local tree = parser:parse()[1]
    local root = tree:root()

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor_pos[1] - 1, cursor_pos[2]  -- 0-indexed

    -- Find the element node containing the cursor
    local node = root:named_descendant_for_range(row, col, row, col)
    while node and node:type() ~= "element" do
        node = node:parent()
    end
    if not node or node:type() ~= "element" then
        vim.notify("No element found at cursor", vim.log.levels.WARN)
        return
    end

    -- DEBUG: Print node details to investigate structure
    vim.print("Element node range: ", vim.inspect(node:range()))
    vim.print("Element node type: ", node:type())
    local start_tag = node:field("start_tag")[1]
    vim.print("Start tag: ", start_tag and start_tag:type() or "nil")
    if start_tag then
        vim.print("Start tag children count: ", start_tag:child_count())
        for i = 0, start_tag:child_count() - 1 do
            local child = start_tag:child(i)
            vim.print(string.format("  Child %d: %s (range: %s)", i, child:type(), vim.inspect(child:range())))
        end
    end

    if not start_tag then
        vim.notify("No start tag found", vim.log.levels.WARN)
        return
    end
    local end_tag = node:field("end_tag")[1]
    if not end_tag then
        vim.notify("Self-closing tag, no end tag to rename", vim.log.levels.INFO)
        return
    end

    -- Get tag name node from start_tag (child 1 after '<')
    local opening_tag_name = start_tag:child(1)
    if not opening_tag_name or opening_tag_name:type() ~= "tag_name" then
        vim.notify("Could not find opening tag name", vim.log.levels.WARN)
        return
    end

    local current_name = vim.treesitter.get_node_text(opening_tag_name, bufnr):match("^%s*(.-)%s*$")

    -- Prompt for new name
    vim.ui.input({
        prompt = "Rename tag '" .. current_name .. "' to: ",
        default = current_name
    }, function(new_name)
        if not new_name or new_name == "" or new_name == current_name then
            return
        end

        -- Replace opening tag name
        local srow, scol, erow, ecol = opening_tag_name:range()
        vim.api.nvim_buf_set_text(bufnr, srow, scol, erow, ecol, {new_name})

        -- Replace closing tag name (child 1 after '</')
        local closing_tag_name = end_tag:child(1)
        if closing_tag_name and closing_tag_name:type() == "tag_name" then
            local csrow, cscol, cerow, cecol = closing_tag_name:range()
            vim.api.nvim_buf_set_text(bufnr, csrow, cscol, cerow, cecol, {new_name})
        end
    end)
end

local M = {}
M.rename = rename_tag
return M
