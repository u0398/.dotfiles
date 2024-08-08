local M = {}

-- expand or minimize current buffer in a more natural direction (tmux-like)
-- ':resize <+-n>' or ':vert resize <+-n>' increases or decreasese current
-- window horizontally or vertically. When mapped to '<leader><arrow>' this
-- can get confusing as left might actually be right, etc
-- the below can be mapped to arrows and will work similar to the tmux binds
-- map to: "<cmd>lua require'utils'.resize(false, -5)<CR>"
function M.relative_resize(vertical, margin)
  local cur_win = vim.api.nvim_get_current_win()
  -- go (possibly) right
  vim.cmd(string.format('wincmd %s', vertical and 'l' or 'j'))
  local new_win = vim.api.nvim_get_current_win()
  -- determine direction cond on increase and existing right-hand buffer
  local not_last = not (cur_win == new_win)
  local sign = margin > 0
  -- go to previous window if required otherwise flip sign
  if not_last == true then
    vim.cmd [[wincmd p]]

  else
    sign = not sign
  end

  local sign_char = sign and '+' or '-'
  local dir = vertical and 'vertical ' or ''
  local cmd = dir .. 'resize ' .. sign_char .. math.abs(margin) .. '<CR>'
  vim.cmd(cmd)
end

-- sudo execution
function M.sudo_exec(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
      vim.notify('Invalid password, sudo aborted', vim.log.levels.ERROR)
      return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    vim.notify('Shell Error: ' .. out, vim.log.levels.ERROR)
    return false
  end
  if print_output then vim.notify(out, vim.log.level.INFO) end
  return true
end

-- sudo save 
function M.sudo_write(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    vim.notify('E32: No file name', vim.log.levels.ERROR)
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = false })
  if M.sudo_exec(cmd) then
    vim.notify(filepath .. 'written', vim.log.levels.INFO)
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

-- change the current working directory
function M.set_cwd(pwd)
  if not pwd then
    local path = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. path)
    vim.notify("pwd set to " .. path, vim.log.levels.INFO)
  else
    if vim.loop.fs_stat(pwd) then
      vim.cmd("cd " .. pwd)
      vim.notify("pwd set to " .. vim.fn.shellescape(pwd), vim.log.levels.INFO)
    else
      vim.notify("Unable to set pwd to " .. vim.fn.shellescape(pwd) ..
                 ", directory is not accessible", vim.log.levels.WARN)
    end
  end
end

return M
