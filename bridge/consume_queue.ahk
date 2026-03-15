#NoEnv
#SingleInstance Force
#Persistent
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

gameTitle := "Plutonium T6 Zombies"
bridgePath := "C:\Users\elvyn\Documents\BO2-streamer-mod\bridge"
pendingFile := bridgePath . "\pending_spins.txt"
pollMs := 1000
spinDelayMs := 1000
spinKey := "{F6}"

logFile := A_ScriptDir . "\consume_queue_log.txt"

Log(msg)
{
    global logFile
    FormatTime, now,, yyyy-MM-dd HH:mm:ss
    FileAppend, %now% - %msg%`n, %logFile%
}

ConsumeOneSpin()
{
    global pendingFile

    if !FileExist(pendingFile)
        return false

    FileRead, content, %pendingFile%
    content := Trim(content)

    if (content = "")
        return false

    count := content + 0

    if (count <= 0)
        return false

    count := count - 1
    FileDelete, %pendingFile%
    FileAppend, %count%, %pendingFile%
    return true
}

Log("Script started")
SetTimer, PollQueue, %pollMs%
return

PollQueue:
    if !ConsumeOneSpin()
        return

    Log("Pending spin found")

    if !WinExist(gameTitle)
    {
        Log("Game window not found")
        return
    }

    WinActivate, %gameTitle%
    WinWaitActive, %gameTitle%,, 2
    Sleep, 300

    Log("Sending key: " . spinKey)
    SendInput, %spinKey%
    Sleep, %spinDelayMs%
return