@echo off
setlocal enabledelayedexpansion

:: Retrieve the current user's desktop folder from the registry.
for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop') do (
    set "DesktopFolder=%%B"
)

:: Retrieve the current user's documents folder from the registry.
for /f "tokens=2*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal') do (
    set "DocumentsFolder=%%B"
    set "FullProgramPath=%%B\FarlightFixer by RubyTemple"
)

:: Initializing variables
set "ShortcutName=FarlightFixer by RubyTemple"
set "ShortcutTarget=%FullProgramPath%\Farlight.bat"
set "IconURL=https://cdn2.steamgriddb.com/file/sgdb-cdn/icon/3ef00cbe8a65af09beddab1c55e103fd.ico"
set "IconPath=%FullProgramPath%\%ShortcutName%.ico"
set "user=%USERNAME%"

:: Create a folder named 'FarlightFixer by RubyTemple' in 'Documents' and move the file to this folder.
if not exist "%FullProgramPath%" (
    mkdir "%FullProgramPath%"
    copy "%userprofile%\Downloads\Farlight.bat" "%FullProgramPath%"
    echo Folder created successfully and file moved successfully.
)

:: Check if the shortcut already exists
if not exist "%DesktopFolder%\%ShortcutName%" (
    if not exist "%IconPath%" (
        :: Download the icon from the web
        echo Downloading the icon...
        powershell -Command "(New-Object System.Net.WebClient).DownloadFile(\"%IconURL%\", \"%IconPath%\")"
    ) else (
        echo Icon already downloaded
    )

    :: Creating shortcut
    echo [InternetShortcut] >> "%DesktopFolder%\%ShortcutName%.url"
    echo URL="file://%FullProgramPath%\Farlight.bat" >> "%DesktopFolder%\%ShortcutName%.url"
    echo IconFile="%IconPath%" >> "%DesktopFolder%\%ShortcutName%.url"
    echo IconIndex=0 >> "%DesktopFolder%\%ShortcutName%.url"
) else (
    echo The shortcut already exists.
)

:: Delete, if it exists, the folder causing the mouse freeze
if exist "C:\Users\!user!\AppData\Local\Solarland" (
    rd /s /q "C:\Users\!user!\AppData\Local\Solarland"
) else (
    echo Folder not found
)

:: Start FarLight 84
start steam://rungameid/1928420

