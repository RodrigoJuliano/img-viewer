@echo off

set exts= .png .jpg .jpeg .jpe .gif .webp .bmp .wbmp .ico

for %%e in (%exts%) do (
    reg add HKCU\Software\Classes\%%e\OpenWithProgids /v ImgViewer /t REG_SZ /f
)

for %%e in (%exts%) do (
    reg add HKCU\Software\ImgViewer\Capabilities\FileAssociations /v %%e /t REG_SZ /d ImgViewer /f
)

reg add HKCU\Software\RegisteredApplications /v ImgViewer /t REG_SZ /d Software\\ImgViewer\\Capabilities /f

@rem Find path of parent folder
for %%I in ("%~dp0.") do (
    for %%J in ("%%~dpI.") do (
        set ParentFolder=%%~dpnxJ
    )
)

reg add HKCU\Software\Classes\ImgViewer\shell\open\command /t REG_SZ /d "\"%ParentFolder%\imgviewer.exe\" \"%%1\"" /f
