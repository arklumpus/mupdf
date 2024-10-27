cd platform\win32

msbuild mupdf.sln /p:Platform=Win32
msbuild mupdf.sln /p:Configuration=Release /p:Platform=Win32
msbuild mupdf.sln /p:Configuration=ReleaseExtra /p:Platform=Win32
