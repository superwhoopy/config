#SingleInstance Force

; Load library
#Include komorebic.lib.ahk
; Load configuration
; #Include komorebi.generated.ahk

CompleteConfiguration()

; Focus windows
!+h::Focus("left")
!+j::Focus("down")
!+k::Focus("up")
!+l::Focus("right")

!+[::CycleFocus("previous")
!+]::CycleFocus("next")

; Move windows
;!+h::Move("left")
;!+j::Move("down")
;!+k::Move("up")
;!+l::Move("right")
!+Enter::Promote()

; Stack windows
; !Left::Stack("left")
; !Right::Stack("right")
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
!+4::MoveToNamedWorkspace("IV")
!+5::MoveToNamedWorkspace("V")

!+6::MoveToNamedWorkspace("A")
!+7::MoveToNamedWorkspace("B")
!+8::MoveToNamedWorkspace("C")
!+9::MoveToNamedWorkspace("D")
!+0::MoveToNamedWorkspace("E")
