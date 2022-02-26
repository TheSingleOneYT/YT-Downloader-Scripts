Set-ExecutionPolicy Bypass -Scope Process -Force;

echo "Welcome! Please choose an option below:"
Function Get-ProjectType {
    $type=Read-Host "
    1 - help
    2 - Download Video w/ Audio
    3 - Download AUDIO ONLY
    4 - Install ffmpeg (Chocolatey already installed)
    5 - Install ffmpeg (Chocolatey not installed)
    Please choose"
    Switch ($type){
        1 {$choice="help"}
        2 {$choice="standard"}
        3 {$choice="audio"}
        4 {$choice="ffmpeg-yes-choco"}
        5 {$choice="ffmpeg-no-choco"}
    }
    return $choice
}

Function Run-Standard {
    $url=Read-Host "Video URL"
    echo "`nMaking request to download video from:" $url

    $options = -join("-o ~/Desktop/%(title)s.%(ext)s --format bestvideo+bestaudio[ext=m4a]/bestvideo+bestaudio/best --merge-output-format mp4 ""$url"" --console-title")

    Start-Process $ytdlexe $options
}

Function Run-Audio {

    $ffmpeg = "C:\ProgramData\chocoportable\lib\ffmpeg\tools\ffmpeg\bin\ffmpeg.exe" # Change to your ffmpeg install location
    echo "ffmpeg is required to continue."

    while (!(Test-Path -path $ffmpeg))
    {
        echo "Could not find:" $ffmpeg
        $ffmpeg = Read-Host "`nEnter ffmpeg.exe location"
    }

    echo "ffmpeg found:" $ffmpeg

    $url=Read-Host "Video URL"
    echo "`nMaking request to download video from:" $url

    $options = -join("-o ~/Desktop/%(title)s.%(ext)s -x --audio-format mp3 ""$url"" --console-title --ffmpeg-location ""$ffmpeg""")

    Start-Process $ytdlexe $options -Wait
    echo "Finished!"
}

Function Run-InstallNoChoco {
    $InstallDir='C:\ProgramData\chocoportable'
    $env:ChocolateyInstall="$InstallDir"

    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Start-Process choco -PassThru "install ffmpeg -y" -Wait
    Run-Main
}

Function Run-InstallYesChoco {
    Start-Process choco -PassThru "install ffmpeg -y" -Wait
    Run-Main
}

Function Run-Help {
    echo 'HELP`n
        1) Make sure to have youtube-dl.exe (https://yt-dl.org/latest/youtube-dl.exe) installed in THE SAME DIRECTORY as this .ps1
        2) Install Microsoft Visual C++ 2010 x86 Redistributable (https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe)
        3) Run this Powershell Script again and enter your youtube-dl.exe path. Or, edit this scripts $ytdlexe at the end to this path.
        4) Start the script again and you can begin downloading videos!'
}

Function Run-Main {

    while (!(Test-Path -path $ytdlexe))
    {
        echo "Could not find:" $ytdlexe "`nType 'help' to get help."
        $ytdlexe = Read-Host "`nEnter youtube-dl.exe location"

        if ($ytdlexe == "help")
        {
            Run-Help
        }
    }

    $runType=Get-ProjectType
    echo "`nOption chosen: " $runType "Processing..."

    Switch ($runType){
        "help" {Run-Help}
        "standard" {Run-Standard}
        "audio" {Run-Audio}
        "ffmpeg-no-choco" {Run-InstallNoChoco}
        "ffmpeg-yes-choco" {Run-InstallYesChoco}
    }
}

$ytdlexe = "D:\youtube-dl\youtube-dl.exe" # Set to your install location
Run-Main
Read-Host