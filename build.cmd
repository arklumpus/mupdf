cd platform\win32

msbuild mupdf.sln
msbuild mupdf.sln /p:Configuration=Release
msbuild mupdf.sln /p:Configuration=ReleaseExtra
