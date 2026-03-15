@echo off
set SOURCE=C:\Users\elvyn\Documents\BO2-streamer-mod\src
set DEST=C:\Users\elvyn\AppData\Local\Plutonium\storage\t6\scripts\zm

if not exist "%DEST%" mkdir "%DEST%"

robocopy "%SOURCE%" "%DEST%" /MIR /R:1 /W:1

echo Sync complete.
pause