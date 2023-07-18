#SingleInstance Force

; Load library
#Include komorebic.lib.ahk
; Load configuration
#Include komorebi.generated.ahk

; Send the ALT key whenever changing focus to force focus changes
AltFocusHack("enable")
; Default to cloaking windows when switching workspaces
WindowHidingBehaviour("cloak")
; Set cross-monitor move behaviour to insert instead of swap
CrossMonitorMoveBehaviour("Insert")
; Enable hot reloading of changes to this file
WatchConfiguration("enable")

; Create named workspaces I-V on monitor 0
EnsureNamedWorkspaces(0, "I II III IV V")
; You can do the same thing for secondary monitors too
EnsureNamedWorkspaces(1, "A B C D E")

; Assign layouts to workspaces, possible values: bsp, columns, rows,
; vertical-stack, horizontal-stack, ultrawide-vertical-stack

NamedWorkspaceLayout("I",   "columns")
NamedWorkspaceLayout("II",  "columns")
NamedWorkspaceLayout("III", "columns")
NamedWorkspaceLayout("IV", "columns")
NamedWorkspaceLayout("V", "columns")

NamedWorkspaceLayout("A",   "rows")
NamedWorkspaceLayout("B",   "rows")
NamedWorkspaceLayout("C",   "rows")
NamedWorkspaceLayout("D",   "rows")
NamedWorkspaceLayout("E",   "rows")

; NamedWorkspaceCustomLayout("I",   "./custom-layout.json")
; NamedWorkspaceCustomLayout("II",  "./custom-layout.json")
; NamedWorkspaceCustomLayout("III", "./custom-layout.json")
; NamedWorkspaceCustomLayout("A",   "./custom-layout.json")
; NamedWorkspaceCustomLayout("B",   "./custom-layout.json")
; NamedWorkspaceCustomLayout("C",   "./custom-layout.json")

; Set the gaps around the edge of the screen for a workspace
NamedWorkspacePadding("I", 2)
NamedWorkspaceContainerPadding("I", 2)
NamedWorkspacePadding("II", 2)
NamedWorkspaceContainerPadding("II", 2)
NamedWorkspacePadding("III", 2)
NamedWorkspaceContainerPadding("III", 2)
NamedWorkspacePadding("IV", 2)
NamedWorkspaceContainerPadding("IV", 2)
NamedWorkspacePadding("V", 2)
NamedWorkspaceContainerPadding("V", 2)

NamedWorkspacePadding("A", 2)
NamedWorkspaceContainerPadding("A", 2)
NamedWorkspacePadding("B", 2)
NamedWorkspaceContainerPadding("B", 2)
NamedWorkspacePadding("C", 2)
NamedWorkspaceContainerPadding("C", 2)
NamedWorkspacePadding("D", 2)
NamedWorkspaceContainerPadding("D", 2)
NamedWorkspacePadding("E", 2)
NamedWorkspaceContainerPadding("E", 2)

; Configure the invisible border dimensions
InvisibleBorders(7, 0, 14, 7)

; Uncomment the next lines if you want a visual border around the active window
ActiveWindowBorderColour(66, 165, 245, "single")
ActiveWindowBorderColour(256, 165, 66, "stack")
ActiveWindowBorderColour(255, 51, 153, "monocle")

CompleteConfiguration()

; Focus windows
;!h::Focus("left")
;!j::Focus("down")
;!k::Focus("up")
;!l::Focus("right")
!+[::CycleFocus("previous")
!+]::CycleFocus("next")

; Move windows
!+h::Move("left")
!+j::Move("down")
!+k::Move("up")
!+l::Move("right")
!+Enter::Promote()

; Stack windows
!Left::Stack("left")
!Right::Stack("right")
!Up::Stack("up")
!Down::Stack("down")
!;::Unstack()
![::CycleStack("previous")
!]::CycleStack("next")

; Resize
!=::ResizeAxis("horizontal", "increase")
!-::ResizeAxis("horizontal", "decrease")
!+=::ResizeAxis("vertical", "increase")
!+-::ResizeAxis("vertical", "decrease")

; Manipulate windows
!t::ToggleFloat()
!+f::ToggleMonocle()

; Window manager options
!+r::Retile()
!p::TogglePause()

; Layouts
!x::FlipLayout("horizontal")
!y::FlipLayout("vertical")

; Workspaces
!1::FocusNamedWorkspace("I")
!2::FocusNamedWorkspace("II")
!3::FocusNamedWorkspace("III")
!4::FocusNamedWorkspace("IV")
!5::FocusNamedWorkspace("V")

!6::FocusNamedWorkspace("A")
!7::FocusNamedWorkspace("B")
!8::FocusNamedWorkspace("C")
!9::FocusNamedWorkspace("D")
!0::FocusNamedWorkspace("E")

; Move windows across workspaces
!+1::MoveToNamedWorkspace("I")
!+2::MoveToNamedWorkspace("II")
!+3::MoveToNamedWorkspace("III")
!+3::MoveToNamedWorkspace("IV")
!+3::MoveToNamedWorkspace("V")

!+6::MoveToNamedWorkspace("A")
!+7::MoveToNamedWorkspace("B")
!+8::MoveToNamedWorkspace("C")
!+8::MoveToNamedWorkspace("D")
!+8::MoveToNamedWorkspace("E")
