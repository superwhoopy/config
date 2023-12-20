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
  Hotstring(":?O:oe", "œ", Toggle)

  ; accented characters
  Hotstring ":*:`'E", "É",            Toggle
  Hotstring ":*:``E", "È",            Toggle
  Hotstring ":*:``A", "À",            Toggle

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

::astetech::ASTERIOS Technologies
