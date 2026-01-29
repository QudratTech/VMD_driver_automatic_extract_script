@echo off
setlocal enabledelayedexpansion
title Intel RST Driver Auto-Extractor

:: Header
echo ======================================================
echo       Intel RST Driver Auto-Extractor by Antigravity
echo ======================================================
echo.

:START
:: Check if a file was provided via drag and drop (argument %1)
set "exePath=%~1"

if "%exePath%"=="" (
    echo [!] Kono file drag-and-drop kora hoyni.
    echo [i] Please drag and drop the setupRST.exe file onto this script.
    echo.
    set /p "exePath=Niche file path ti paste korun ba drag korun: "
    :: Remove quotes if the user pasted them
    set "exePath=!exePath:"=!"
)

:: Check if the file exists
if not exist "!exePath!" (
    echo.
    echo [Error] Fileটি খুঁজে পাওয়া যায়নি: "!exePath!"
    echo [i] অনুগ্রহ করে সঠিক ফাইল ড্রাগ করুন।
    pause
    cls
    goto START
)

:: Get file directory and filename
for %%I in ("!exePath!") do (
    set "fileDir=%%~dpI"
    set "fileName=%%~nxI"
)

echo.
echo [Target File]: !fileName!
echo [Location]: !fileDir!
echo.

:: Ask for extraction folder name
set /p "folderName=Extraction folder er naam likhun (Ex: Driver_v19): "

:: Define full extraction path
set "extractPath=!fileDir!!folderName!"

echo.
echo [i] Extract kora hocche: "!extractPath!"...
echo.

:: Change directory to where the EXE is
pushd "!fileDir!"

:: Confirmed Working Command: -extractdrivers
echo [Try 1] Using -extractdrivers...
"!exePath!" -extractdrivers "!extractPath!"

:: If not working, try the secondary -extractall (Silent)
if not exist "!extractPath!" (
    echo [i] Method 1 failed. Trying Method 2 (-s -extractall)...
    "!exePath!" -s -extractall "!extractPath!"
)

:: Method 3: 7-Zip Fallback (If installed)
if not exist "!extractPath!" (
    echo [i] Automated flags failed. Checking for 7-Zip...
    set "szPath=C:\Program Files\7-Zip\7z.exe"
    if exist "!szPath!" (
        echo [Try 3] Extracting using 7-Zip...
        "!szPath!" x "!exePath!" -o"!extractPath!" -y >nul
    )
)

popd

:: Final Validation
if exist "!extractPath!" (
    echo.
    echo ======================================================
    echo [SUCCESS] Extraction sompunno hoyeche!
    echo [Location]: "!extractPath!"
    echo ======================================================
) else (
    echo.
    echo [!] দুঃখিত, সব প্রচেষ্টা ব্যর্থ হয়েছে।
    echo [i] লজিক: ইন্টেল ইন্সটলার এক্সট্র্যাক্ট করতে পারছে না।
    echo [Tip] সমাধান: WinRAR বা 7-Zip সফটওয়্যার ওপেন করে তার ভিতর এই EXE ফাইলটি ড্রাগ করুন। 
)

echo.
pause
