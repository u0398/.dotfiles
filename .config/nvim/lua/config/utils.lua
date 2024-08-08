local M = {}

function M.is_root()
  return (vim.loop.getuid() == 0)
end

function M._echo_multiline(msg)
  for _, s in ipairs(vim.fn.split(msg, "\n")) do
    vim.cmd("echom '" .. s:gsub("'", "''").."'")
  end
end

function M.git_root(cwd, noerr)
  local cmd = { "git", "rev-parse", "--show-toplevel" }
  if cwd then
    table.insert(cmd, 2, "-c")
    table.insert(cmd, 3, vim.fn.expand(cwd))
  end
  local output = vim.fn.systemlist(cmd)
  if M.shell_error() then
    if not noerr then M.info(unpack(output)) end
    return nil
  end
  return output[1]
end

-- expand or minimize current buffer in a more natural direction (tmux-like)
-- ':resize <+-n>' or ':vert resize <+-n>' increases or decreasese current
-- window horizontally or vertically. when mapped to '<leader><arrow>' this
-- can get confusing as left might actually be right, etc
-- the below can be mapped to arrows and will work similar to the tmux binds
-- map to: "<cmd>lua require'utils'.resize(false, -5)<cr>"
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
  local cmd = dir .. 'resize ' .. sign_char .. math.abs(margin) .. '<cr>'
  vim.cmd(cmd)
end

-- sudo execution
function M.sudo_exec(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
      vim.notify('invalid password, sudo aborted', vim.log.levels.error)
      return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -s %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    vim.notify('shell error: ' .. out, vim.log.levels.error)
    return false
  end
  if print_output then vim.notify(out, vim.log.level.info) end
  return true
end

-- sudo save 
function M.sudo_write(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    vim.notify('e32: no file name', vim.log.levels.error)
    return
  end
  -- `bs=1048576` is equivalent to `bs=1m` for gnu dd or `bs=1m` for bsd dd
  -- both `bs=1m` and `bs=1m` are non-posix
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = false })
  if M.sudo_exec(cmd) then
    vim.notify(filepath .. 'written', vim.log.levels.info)
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

-- change the current working directory
function M.set_cwd(pwd)
  if not pwd then
    local path = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. path)
    vim.notify("pwd set to " .. path, vim.log.levels.info)
  else
    if vim.loop.fs_stat(pwd) then
      vim.cmd("cd " .. pwd)
      vim.notify("pwd set to " .. vim.fn.shellescape(pwd), vim.log.levels.info)
    else
      vim.notify("unable to set pwd to " .. vim.fn.shellescape(pwd) ..
                 ", directory is not accessible", vim.log.levels.warn)
    end
  end
end


-- taken from:
-- https://www.reddit.com/r/neovim/comments/o1byad/what_lua_code_do_you_have_to_enhance_neovim/
--
-- tmux like <c-b>z: focus on one buffer in extra tab
-- put current window in new tab with cursor restored
local _tabz = nil

M.tabz = function()
  if _tabz then
    if _tabz == vim.api.nvim_get_current_tabpage() then
      M.tabclose()
    end
    _tabz = nil
  else
    _tabz = M.tabedit()
  end
end

M.tabedit = function()
  -- skip if there is only one window open
  if vim.tbl_count(vim.api.nvim_tabpage_list_wins(0)) == 1 then
    print('Cannot expand single buffer')
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local view = vim.fn.winsaveview()
  -- note: tabedit % does not properly work with terminal buffer
  vim.cmd [[tabedit]]
  -- set buffer and remove one opened by tabedit
  local tabedit_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_delete(tabedit_buf, {force = true})
  -- restore original view
  vim.fn.winrestview(view)
  return vim.api.nvim_get_current_tabpage()
end

-- restore old view with cursor retained
M.tabclose = function()
  local buf = vim.api.nvim_get_current_buf()
  local view = vim.fn.winsaveview()
  vim.cmd [[tabclose]]
  -- if we accidentally land somewhere else, do not restore
  local new_buf = vim.api.nvim_get_current_buf()
  if buf == new_buf then vim.fn.winrestview(view) end
end

return M
