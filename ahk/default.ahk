﻿#Requires AutoHotkey v2.0

ScoopDir := EnvGet("SCOOP")
HomeDir := EnvGet("USERPROFILE")

; This function is necessary when mapping to a Win+<X> hotkey: for some reason
; Windows does not let us focus the newly created window by default
RunAndFocus(cmdStr)
{
  pid := unset
  timeout_s := 5 ; wait for 5s to find the newly created window
  Run cmdStr, HomeDir, , &pid
  if WinWait("ahk_pid " pid, , timeout_s)
    WinActivate("ahk_pid " pid)
  return
}

; Neovim
#v:: RunAndFocus(ScoopDir "\apps\neovim\current\bin\nvim-qt.exe")

; Browser
#b:: Run("firefox")

; Windows Terminal
#Enter:: RunAndFocus("wt")

; Mattermost
#m::
{
  if WinExist("ahk_exe Mattermost.exe")
    WinActivate
  else
    RunAndFocus("mattermost")
}

; French guillemets
::<<::«
::>>::»

; Ellipsis
::...::…

; Reload this script, useful when debugging/prototyping
; #r:: Reload
