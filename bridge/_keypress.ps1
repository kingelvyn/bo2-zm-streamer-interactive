Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
  [DllImport("user32.dll")] public static extern IntPtr FindWindow(string cls, string title);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);
}
"@
$proc = Get-Process | Where-Object { $_.MainWindowTitle -like "*Plutonium*" -or $_.MainWindowTitle -like "*Black Ops*" } | Select-Object -First 1
if ($proc) {
  $hwnd = $proc.MainWindowHandle
  Write-Output "Found: $($proc.MainWindowTitle) HWND:$hwnd"
  [WinAPI]::PostMessage($hwnd, 0x0100, [IntPtr]0x31, [IntPtr]0) | Out-Null
  Start-Sleep -Milliseconds 50
  [WinAPI]::PostMessage($hwnd, 0x0101, [IntPtr]0x31, [IntPtr]0) | Out-Null
  Write-Output "KEY_SENT"
} else {
  Write-Output "WINDOW_NOT_FOUND"
  Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | ForEach-Object { Write-Output "Window: $($_.MainWindowTitle)" }
}