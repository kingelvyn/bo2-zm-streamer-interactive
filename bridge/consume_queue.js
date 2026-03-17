const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const QUEUE_FILE = path.join(
  process.env.LOCALAPPDATA,
  'Plutonium', 'storage', 't6', 'wheel_queue.json'
);

const POLL_INTERVAL_MS = 1000;

function loadQueue() {
  try {
    const raw = fs.readFileSync(QUEUE_FILE, 'utf8');
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

function saveQueue(queue) {
  const tmp = QUEUE_FILE + '.tmp';
  fs.writeFileSync(tmp, JSON.stringify(queue, null, 2));
  fs.renameSync(tmp, QUEUE_FILE);
}

function sendKeypressToGame() {
    const scriptPath = path.join(__dirname, '_keypress.ps1');
    
    const script = [
        'Add-Type @"',
        'using System;',
        'using System.Runtime.InteropServices;',
        'public class WinAPI {',
        '  [DllImport("user32.dll")] public static extern IntPtr FindWindow(string cls, string title);',
        '  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);',
        '}',
        '"@',
        '$proc = Get-Process | Where-Object { $_.MainWindowTitle -like "*Plutonium*" -or $_.MainWindowTitle -like "*Black Ops*" } | Select-Object -First 1',
        'if ($proc) {',
        '  $hwnd = $proc.MainWindowHandle',
        '  Write-Output "Found: $($proc.MainWindowTitle) HWND:$hwnd"',
        '  [WinAPI]::PostMessage($hwnd, 0x0100, [IntPtr]0x31, [IntPtr]0) | Out-Null',
        '  Start-Sleep -Milliseconds 50',
        '  [WinAPI]::PostMessage($hwnd, 0x0101, [IntPtr]0x31, [IntPtr]0) | Out-Null',
        '  Write-Output "KEY_SENT"',
        '} else {',
        '  Write-Output "WINDOW_NOT_FOUND"',
        '  Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | ForEach-Object { Write-Output "Window: $($_.MainWindowTitle)" }',
        '}'
      ].join('\r\n');
  
    fs.writeFileSync(scriptPath, script, 'utf8');
  
    exec(
      `powershell -NoProfile -ExecutionPolicy Bypass -File "${scriptPath}"`,
      (err, stdout, stderr) => {
        if (err) {
          console.error('[CONSUME] PowerShell error:', err.message);
          return;
        }
        if (stderr) console.error('[CONSUME] stderr:', stderr);
        console.log('[CONSUME] PowerShell output:', stdout.trim());
      }
    );
  }

function tick() {
  const queue = loadQueue();
  if (queue.length === 0) return;

  const first = queue[0];
  const remaining = queue.slice(1);

  console.log(`[CONSUME] Processing: ${first.event} | ${first.user}`);
  sendKeypressToGame();
  saveQueue(remaining);
}

setInterval(tick, POLL_INTERVAL_MS);
console.log('[CONSUME] Queue consumer started, polling every 1s...');