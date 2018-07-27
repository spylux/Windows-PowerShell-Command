Add-Type @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace PInvoke.Win32 {

    public static class UserInput {

        [DllImport("user32.dll", SetLastError=false)]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO {
            public uint cbSize;
            public int dwTime;
        }

        public static DateTime LastInput {
            get {
                DateTime bootTime = DateTime.Now.AddMilliseconds(-Environment.TickCount);
                DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                return lastInput;
            }
        }

        public static TimeSpan IdleTime {
            get {
                return DateTime.Now.Subtract(LastInput);
            }
        }

        public static int LastInputTicks {
            get {
                LASTINPUTINFO lii = new LASTINPUTINFO();
                lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                GetLastInputInfo(ref lii);
                return lii.dwTime;
            }
        }
    }
}
'@

for ( $i = 0; $i -lt 86400; $i++ ) {
    Clear-Host
    #$Last = [PInvoke.Win32.UserInput]::LastInput
    $Idle = [PInvoke.Win32.UserInput]::IdleTime
    $LastStr = $Last.ToLocalTime().ToString("MM/dd/yyyy hh:mm tt")
    Write-Host ("Last Idle is: " + $LastStr)
    if ($Idle.Hours -ge 1){
        Write-Host ("Idle for " + $Idle.Hours + " hours, " + $Idle.Minutes + " minutes, " + $Idle.Seconds + " seconds.")
    }
    elseif ($Idle.Minutes -ge 1){
        Write-Host ("Idle for " + $Idle.Minutes + " minutes, " + $Idle.Seconds + " seconds.")
    }
    else{
        Write-Host ("Idle for " + $Idle.Seconds + " seconds.")
    }
    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 2)
}