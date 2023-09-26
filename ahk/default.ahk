#Requires AutoHotkey v2.0

; Load komorebi shortcuts
#Include komorebi\komorebi.ahk

ScoopDir := EnvGet("SCOOP")
HomeDir := EnvGet("USERPROFILE")

; This function is necessary when mapping to a Win+<X> hotkey: for some reason
; Windows does not let us focus the newly created window by default
RunAndFocus(cmdStr, optStr:="")
{
  pid := unset
  timeout_s := 5 ; wait for 5s to find the newly created window
  Run cmdStr, HomeDir, optStr, &pid
  if WinWait("ahk_pid " pid, , timeout_s)
    WinActivate("ahk_pid " pid)
  return
}

; Issue komorebic start/stop commands
SwitchKomorebic()
{
  Running := ProcessExist("komorebi.exe")
  if Running != 0
  {
    RunWait("komorebic stop")
    TrayTip("komorebi was stopped", , "Iconi")
    Stopped := true
  }
  else
  {
    TrayTip("Starting komorebi", , "Iconi")
    RunWait('komorebic start -c "' A_ScriptDir '\komorebi\komorebi.json"')
    Stopped := false
  }
}

; ##############################################################################
; HOTKEYS
; ##############################################################################

; Neovim
#v:: RunAndFocus(ScoopDir "\apps\neovim\current\bin\nvim-qt.exe")
#+v:: RunAndFocus(ScoopDir "\apps\neovim\current\bin\nvim-qt.exe --fullscreen")

; Browser
#b:: Run("firefox", , "Max")

; Windows Terminal
#Enter:: RunAndFocus("wt")

; komorebic start/stop
#+k:: SwitchKomorebic()

; Mattermost
#m::
{
  if WinExist("ahk_exe Mattermost.exe")
    WinActivate
  else
    RunAndFocus("mattermost")
}

; Reload this script, useful when debugging/prototyping
; #r:: Reload

; ##############################################################################
; HOTSTRINGS
; ##############################################################################

; reminder on modifiers:
;
;   * means no need for an ending character
;   ? means that the hotstring is triggered even inside other words
;   O means the ending character will be removed
;   C means the hotstring is case sensitive

; French guillemets
:*?:""l::«
:*?:""r::»

; Ellipsis
:*?:...::…

; e dans l'o
:?O:oe::œ

; obvious
:?C:Ca::Ça

; tirets
::---::―
