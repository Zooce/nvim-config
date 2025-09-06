local M = {}

function M.rename_file()
  local old_name = vim.fn.expand('%:p') -- Get the full path of the current buffer
  if old_name == '' then
    vim.notify('No file associated with the current buffer', vim.log.levels.ERROR)
    return
  end

  -- Prompt for the new file name
  local new_name = vim.fn.input('New file name: ', old_name, 'file')
  if new_name == '' or new_name == old_name then
    vim.notify('Rename cancelled or no change', vim.log.levels.INFO)
    return
  end

  -- Attempt to rename the file
  local success, error_msg = os.rename(old_name, new_name)
  if not success then
    vim.notify('Error renaming file: ' .. error_msg, vim.log.levels.ERROR)
    return
  end

  -- Update the buffer to point to the new file name
  vim.api.nvim_buf_set_name(0, new_name)
  vim.cmd('w!') -- Force write to the new file
  vim.notify('File renamed to ' .. new_name, vim.log.levels.INFO)
end

return M
