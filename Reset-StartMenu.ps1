<#
.FUNCTIONALITY
Resets Win10 start-menu left side and right-side

.SYNOPSIS
Left-side: Removes orphaned entries that appear randomly and when MS Store (Appx) based apps are cached inside FSLogix profiles, but removed from actual OS
Right-side (tile section):  performs resets based on build XML

.NOTES
Change log

Oct 13, 2019
-Initial version

Oct 15, 2019
-Amended to use $env:LOCALAPPDATA

Oct 19, 2019
-Added 2nd path to remove-item

Feb 25, 2020
-Improved message boxes

March 31, 2020
-Added copy for chrome.lnk from default to %AppData% for user

Feb 26, 2021
-Added IF statements / EA to stop errors from being thrown

.DESCRIPTION
Author owen.reynolds@procontact.ca & jonathan.pitre@procontact.ca

.EXAMPLE
./Reset-StartMenu.ps1

.NOTES

.Link
N/A

#>

Add-Type -AssemblyName System.Windows.Forms

#Button Legend
#                  OK 0
#            OKCancel 1
#    AbortRetryIgnore 2
#         YesNoCancel 3
#               YesNo 4
#         RetryCancel 5

#Icon legend
#                None 0
#                Hand 16
#               Error 16
#                Stop 16
#            Question 32
#         Exclamation 48
#             Warning 48
#            Asterisk 64
#         Information 64

$messageBoxTitle = "Windows Start Menu Reset"
$UserResponse = [System.Windows.Forms.MessageBox]::Show("Do you want to reset the Windows Start Menu to resolve issues with missing/invalid shortcuts?" , $messageBoxTitle, 4, 32)

If ($UserResponse -eq "YES" ) {

    write-host "Reseting windows left / right side Windows 10 icons/allignment"

    if (test-path "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"-ErrorAction SilentlyContinue) {

        Copy-Item -path "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Destination "$env:LOCALAPPDATA\Microsoft\Windows\Shell" -force

    }
    
    Remove-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*$start.tilegrid$windows.data.curatedtilecollection.tilecollection' -force -recurse -ErrorAction SilentlyContinue

    if (test-path "C:\Users\Default\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\Taskbar\Google Chrome.lnk" -ErrorAction SilentlyContinue) {

        copy-item -Path "C:\Users\Default\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\Taskbar\Google Chrome.lnk" -Destination "$Env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\Taskbar\" -Force

    }
        
    get-process shellexperiencehost -ErrorAction SilentlyContinue | stop-process -force -ErrorAction SilentlyContinue
    
    write-host "Pausing for for 3 seconds..."
    start-sleep -s 3
    
    remove-item -Path "$env:LOCALAPPDATA\Packages\Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy\TempState\StartUnifiedTileModelCache.dat" -Force -ErrorAction SilentlyContinue
    remove-item -Path "$env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\TempState\StartUnifiedTileModelCache.dat" -Force -ErrorAction SilentlyContinue    

    Get-Process Explorer | Stop-Process -force -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("Windows Start Menu was reset!", $messageBoxTitle, 0, 64)
} 
Else { 
    Write-host "No"
    Exit
} 

