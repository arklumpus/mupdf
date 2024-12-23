@echo off
setlocal enabledelayedexpansion

cd platform\win32
msbuild mupdf.sln /p:Configuration=ReleaseExtra

echo.
echo Checking build results...

set built=1

if exist ARM64\ReleaseExtra\libmupdf.lib (
    for %%I in (ARM64\ReleaseExtra\libmupdf.lib) do set /a sizeExtra=%%~zI/1024/1024
    echo     Found: platform\win32\ARM64\ReleaseExtra\libmupdf.lib  !sizeExtra! MiB
) else (
    set built=0
    echo     NOT Found: platform\win32\ARM64\ReleaseExtra\libmupdf.lib
)

set success=0

if %built% == 1 (
    if !sizeExtra! geq 520 (
        echo.
        echo     .lib file size: %sizeExtra% MiB (looks OK^)
        set success=1
    ) else (
        echo.
        echo     .lib file size: %sizeExtra% MiB (too small^^!^)
    )
)

if %success% == 1 (
    echo.
    echo Build succeeded!
    echo Target .lib file can be found in platform\win32\ARM64\ReleaseExtra\libmupdf.lib
)

if %success% == 0 (
    echo.
    echo Build failed!
    echo Please make sure that you are using the "ARM64 Native Tools Command Prompt"^^!

    exit /B 1
)

cd ..\..

exit /B 0
