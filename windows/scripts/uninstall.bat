@echo off

set exts= .png .jpg .jpeg .jpe .gif .webp .bmp .wbmp .ico

for %%e in (%exts%) do (
    reg delete HKCU\Software\Classes\%%e\OpenWithProgids /v ImgViewer /f
)

reg delete HKCU\Software\ImgViewer /f

reg delete HKCU\Software\RegisteredApplications /v ImgViewer /f

reg delete HKCU\Software\Classes\ImgViewer /f
