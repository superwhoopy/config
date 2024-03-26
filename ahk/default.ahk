#Requires AutoHotkey v2.0

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
; FrenchMyRide Mode
; ##############################################################################

; insecable space; originally disabled, will be toggled on when calling
; FrenchMyRide()
_INSECABLE_SPACE_HK := "^+Space"
_insecable(*)
{
  SendText(" ")
}
Hotkey(_INSECABLE_SPACE_HK, _insecable, "Off")


FrenchMyRide()
{
  ; reminder on modifiers:
  ;
  ;   * means no need for an ending character
  ;   ? means that the hotstring is triggered even inside other words
  ;   O means the ending character will be removed
  ;   C means the hotstring is case sensitive

  ; French guillemets, with insecable space
  _guillemets(*)
  {
    SendText("«  »")
    Send("{Left}{Left}")
  }

  Toggle := "Toggle"

  Hotstring(":*?:`"`"`"`"", _guillemets, Toggle)

  Hotstring(":?: ?",  " ?" A_EndChar, Toggle)
  Hotstring(":?: !",  " {!}" A_EndChar, Toggle)
  Hotstring(":?: `:", " :" A_EndChar, Toggle)
  Hotstring(":?: `;", " ;" A_EndChar, Toggle)
  Hotstring(":?C:Ca", "Ça" A_EndChar, Toggle)
  Hotstring(":?CO:oe", "œ", Toggle)
  Hotstring(":?CO:OE", "Œ", Toggle)


  ; accented characters
  Hotstring ":*C:`'E", "É",            Toggle
  Hotstring ":*C:``E", "È",            Toggle
  Hotstring ":*C:``A", "À",            Toggle

  ; Ellipsis
  Hotstring ":?:...", "…",            Toggle

  ; tiret large
  Hotstring ":*?:--- ", "― ",         Toggle

  ; insecable space
  Hotkey _INSECABLE_SPACE_HK, Toggle
}

; be sure to toggle on FrenchMyRide mode on startup
FrenchMyRide()

; Switch on/off FrenchMyRide mode
FrenchMyRideStatus := true
^+F::
{
  global FrenchMyRideStatus := not FrenchMyRideStatus
  TrayTip("French My Ride mode: " (FrenchMyRideStatus ? "ON" : "OFF"))
  FrenchMyRide()
}

; Hide the task bar with Ctrl+LWin
TaskBarHidden := false
^LWin::
{
  global TaskBarHidden
  if (TaskBarHidden) {
    WinShow "ahk_class Shell_TrayWnd"
    try WinShow "ahk_class Shell_SecondaryTrayWnd"
    TaskBarHidden := false
  } else {
    WinHide "ahk_class Shell_TrayWnd"
    try WinHide "ahk_class Shell_SecondaryTrayWnd"
    TaskBarHidden := true
  }
}

; ##############################################################################
; HOTKEYS
; ##############################################################################

; Neovim
#v:: RunAndFocus(ScoopDir "\apps\neovide\current\neovide.exe")
#+v:: RunAndFocus(ScoopDir "\apps\neovide\current\neovide.exe --fullscreen")

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
;
; Also:
;
;   ^ for Ctrl
;   ! for Alt
;   + for Shift
;   # for Meta

::astetech::ASTERIOS Technologies
