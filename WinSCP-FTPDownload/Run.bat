@ECHO off
cls
:start
ECHO. ==================
ECHO 1. Login
ECHO 2. Enterpise
ECHO 3. Hosting
ECHO 4. AIDBS
ECHO 5. Cloud
ECHO 6. Mail
ECHO 7. LinuxMunch
ECHO 8. Subscriber
ECHO 9. Active
ECHO. ==================
set /p choice=Type the number to Download Data.
rem if not '%choice%'=='' set choice=%choice:~0;1% ( don`t use this command, because it takes only first digit in the case you type more digits. After that for example choice 23455666 is choice 2 and you get "bye"
if '%choice%'=='' ECHO "%choice%" is not valid please try again
if '%choice%'=='1' goto Login
if '%choice%'=='2' goto Enterpise
if '%choice%'=='3' goto Hosting
if '%choice%'=='4' goto Aidbs
if '%choice%'=='5' goto Cloud
if '%choice%'=='6' goto Mail
if '%choice%'=='7' goto LinuxMunch
if '%choice%'=='8' goto Subscriber
if '%choice%'=='9' goto Active
ECHO.
goto start
:Login
WinSCP.com /script=E:\FTPDownload\servers\login.txt
goto end
:Enterpise
WinSCP.com /script=E:\FTPDownload\servers\enterpise.txt
goto end
:Hosting
WinSCP.com /script=E:\FTPDownload\servers\hosting.txt
goto end
:Aidbs
WinSCP.com /script=E:\FTPDownload\servers\aidbs.txt
goto end
:Cloud
WinSCP.com /script=E:\FTPDownload\servers\cloud.txt
goto end
:Mail
WinSCP.com /script=E:\FTPDownload\servers\mail.txt
goto end
:LinuxMunch
WinSCP.com /script=E:\FTPDownload\servers\linuxmunch.txt
goto end
:Subscriber
WinSCP.com /script=E:\FTPDownload\servers\subscriber.txt
goto end
:Active
WinSCP.com /script=E:\FTPDownload\servers\active.txt
:end
pause
exit