:: Batch By TheSingleOneYT, youtube-dl from https://github.com/ytdl-org/
:: More/newer versions of this batch may be available at https://github.com/TheSingleOneYT/YT-Downloader-Batch

@ECHO OFF
choice /c 1234 /n /m "1 help, 2 Download Video & Audio, 3 Download ONLY AUDIO, 4 Update youtube-dl.exe: "

if %errorlevel% equ 1 (
goto help
)

if %errorlevel% equ 2 (
goto db
)

if %errorlevel% equ 3 (
goto da
)

if %errorlevel% equ 4 (
goto update
)


:: Download Basic (Audio & Video)
:db
set /p url= "Enter video URL: "

if exist youtube-dl.exe (
ECHO Running!

youtube-dl.exe "%url%"
) else (
echo [ERR] No youtube-dl.exe in current directory.
pause
goto :eof
)

:: Download Audio
:da
set /p url= "Enter video URL: "

set ffmpeg= "C:\ProgramData\chocolatey\bin\ffmpeg.exe" :: Change to your install location

choice /c 12 /n /m "Running this REQUIRES ffmpeg to convert to .mp3. Press 1 to continue, 2 to cancel."


if %errorlevel% equ 2 (
goto cancelAO
)

if exist youtube-dl.exe (
ECHO Running!

youtube-dl.exe -x --audio-format mp3 "%url% --ffmpeg-location %ffmpeg%"
) else (
echo [ERR] No youtube-dl.exe in current directory.
pause
goto :eof
)

pause
goto :eof

:help
echo How to use this Batch File! (BASIC)
echo 1) Make sure to have youtube-dl.exe (https://yt-dl.org/latest/youtube-dl.exe) installed in THE SAME DIRECTORY as this .bat
echo 2) Install Python (https://www.python.org/downloads/windows/)
echo 3) Install Microsoft Visual C++ 2010 x86 Redistributable (https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe)
echo 4) Run this Batch File again and type 2. Then, on the next prompt, paste the YT video URL.
echo 5) It should now begin downloading the video, wait and enjoy!

pause
goto :eof

:update
if exist youtube-dl.exe (
ECHO Running!

youtube-dl.exe --update
) else (
echo [ERR] No youtube-dl.exe in current directory. Failed to run check.
)

pause
goto :eof

:cancelAO
echo Abort success. Remember: if you install ffmpeg to a path different than the one in this batch, update the path in this file.
pause
goto :eof