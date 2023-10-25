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

; Switch keyboard layout
Capslock::
{
  Send "#{Space}"
}

; GlazeWM start
#+g::
{
  TrayTip("Starting GlazeWM", , "Iconi")
  Run("GlazeWM", , "Hide")
}

; Mattermost
#m::
{
  if WinExist("ahk_exe Mattermost.exe")
    WinActivate
  else
    RunAndFocus("mattermost")
}

; Insecable space
^Space::
{
  SendText " "
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

; French guillemets, with insecable space
:*?:""""::
{
  SendText "«  »"
  Send "{Left}{Left}"
}

; Ellipsis
:*?:...::…

; e dans l'o
:?O:oe::œ

; obvious
:?C:Ca::Ça

; tirets
::---::―
