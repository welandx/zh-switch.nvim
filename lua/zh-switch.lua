--#region
-- zh-switch.lua ---a switch method for chinese user
--
-- Copyright (C) 2022 weland
--
-- Author: weland <https://github.com/welandx>
-- Maintainer: weland <weland@bupt.edu.cn>
-- Created: Feb 02, 2022
-- Modified: Feb 04, 2022
-- Version: 0.1.1
-- Keywords: vim input chinese
-- Plugin-Requires: neovim "0.6.0"
--                  fcitx5(require fcitx5-remote)
--
---- Commentary:
--
-- auto switch fcitx5 input method when leave and enter insert mode
-- save last input status in insert mode and recover it when enter inert
--
--#endregion

local ZH_on = 2
local EN_on = 1

local sw_to_CH="fcitx5-remote -o"
local sw_to_EN="fcitx5-remote -c"

local stack_insert_status = 1                 --save input status

local function Get_fcitx_status()                   --get input status
  local cmd=io.popen("fcitx5-remote")
  local ret=cmd:read("*a")
  local tmp=tonumber(ret)
  cmd:close()
  return tmp
end

local function Leave_insert()
  local exit_insert_status=Get_fcitx_status()
  stack_insert_status=exit_insert_status
  if exit_insert_status == ZH_on then
    os.execute(sw_to_EN)
  end
end

local function Enter_insert()
  local enter_insert_status=EN_on
  if enter_insert_status~=stack_insert_status then
    if stack_insert_status==ZH_on then
      os.execute(sw_to_CH)
    end
  else os.execute(sw_to_EN)
  end
end

local function Leave_enter_cmd()
  vim.api.nvim_command('augroup Leave_enter_input')
  vim.api.nvim_command('autocmd InsertLeave * lua Leave_insert()')
  vim.api.nvim_command('autocmd InsertEnter * lua Enter_insert()')
  vim.api.nvim_command('augroup end')
end

local M = {
  fcitx_status = Get_fcitx_status,
  leave_input = Leave_insert,
  enter_input = Enter_insert,
  Leave_enter_cmd = Leave_enter_cmd
}

return M
