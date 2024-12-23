@echo off
setlocal enabledelayedexpansion

cd platform\win32

msbuild mupdf.sln /p:Platform=Win32
msbuild mupdf.sln /p:Configuration=Release /p:Platform=Win32
msbuild mupdf.sln /p:Configuration=ReleaseExtra /p:Platform=Win32

echo.
echo Checking build results...

set built=1

if exist Release\libmupdf.lib (
    for %%I in (Release\libmupdf.lib) do set /a sizeRelease=%%~zI/1024/1024
    echo     Found: platform\win32\Release\libmupdf.lib       !sizeRelease! MiB
) else (
    set built=0
    echo     NOT Found: platform\win32\Release\libmupdf.lib
)

if exist ReleaseExtra\libmupdf.lib (
    for %%I in (ReleaseExtra\libmupdf.lib) do set /a sizeExtra=%%~zI/1024/1024
    echo     Found: platform\win32\ReleaseExtra\libmupdf.lib  !sizeExtra! MiB
) else (
    set built=0
    echo     NOT Found: platform\win32\ReleaseExtra\libmupdf.lib
)

set success=0

set /a diff=!sizeExtra! - !sizeRelease!

if %built% == 1 (
    if %diff% geq 5 (
        echo.
        echo     Size difference: %diff% MiB (looks OK^)
        set success=1
    ) else (
        echo.
        echo     Size difference: %diff% MiB (too small^^!^)
    )
)

if %success% == 1 (
    echo.
    echo Build succeeded!
    echo Target .lib file can be found in platform\win32\ReleaseExtra\libmupdf.lib
)

if %success% == 0 (
    echo.
    echo Build failed!
    echo Please make sure that you are using the "x86 Native Tools Command Prompt"^^!

    exit /B 1
)

cd ..\..

exit /B 0
