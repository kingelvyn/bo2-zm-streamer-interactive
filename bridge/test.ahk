#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

TrayTip, BO2 Streamer Mod, AHK script started, 2, 1
MsgBox, 64, BO2 Streamer Mod, consume_queue.ahk is running.

SetTimer, AlivePing, 5000
return

AlivePing:
    ToolTip, AHK is running...
    Sleep, 1000
    ToolTip
return