@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ========== 在此修改为你本机实际绝对路径 ==========
set GS_EXE="C:\Program Files\gs\gs10.04.0\bin\gswin64c.exe"
set QPDF_EXE="D:\tools\qpdf\qpdf.exe"
:: ====================================================

:: 1=第1页（封面）不检测，直接归黑白；0=封面也检测
set "SKIP_FIRST=1"
:: 1=忽略矢量图形（只看位图）；0=彩色矢量图表也算彩页（文字始终忽略）
set "IGNORE_VECTOR=1"
:: 阈值：CMY 覆盖率前5个字符等于此值视为无彩色（"0.000"=<0.1%，"0.00"=<1%）
set "THRESH=0.000"
set "GSOPT=-dFILTERTEXT"
if "%IGNORE_VECTOR%"=="1" set "GSOPT=-dFILTERTEXT -dFILTERVECTOR"
if not exist "out" mkdir "out"
echo ==============================================
echo PDF 彩页/黑白页分离工具（结果输出到 out 文件夹）
echo ==============================================
echo.
del "_src.pdf" "_tmp_img.pdf" "_tmp_ink.txt" 2>nul
for %%f in (*.pdf) do call :process "%%f"
echo 全部处理完成！结果在 out 文件夹
pause
exit /b
:process
set "name=%~n1"
if /i "!name!"=="_src" exit /b
if /i "!name!"=="_tmp_img" exit /b
echo 正在处理："%~1"
copy /y "%~1" "_src.pdf" >nul
del "_tmp_img.pdf" "_tmp_ink.txt" 2>nul
set "color_pages="
set "bw_pages="
set "page_num=0"
%GS_EXE% -q -o "_tmp_img.pdf" -sDEVICE=pdfwrite %GSOPT% "_src.pdf" 2>nul
if not exist "_tmp_img.pdf" (
    echo 过滤失败，已跳过该文件
    exit /b
)
%GS_EXE% -q -o - -sDEVICE=inkcov "_tmp_img.pdf" > "_tmp_ink.txt" 2>nul
for /f "tokens=1-4" %%a in ('findstr "CMYK" "_tmp_ink.txt"') do (
    set /a page_num+=1
    set "C=%%a"
    set "M=%%b"
    set "Y=%%c"
    set "isColor=0"
    if not "!C:~0,5!"=="%THRESH%" set "isColor=1"
    if not "!M:~0,5!"=="%THRESH%" set "isColor=1"
    if not "!Y:~0,5!"=="%THRESH%" set "isColor=1"
    if "%SKIP_FIRST%"=="1" if !page_num! equ 1 set "isColor=0"
    echo   第!page_num!页: C=!C! M=!M! Y=!Y! : !isColor!
    if "!isColor!"=="1" (
        set "color_pages=!color_pages!,!page_num!"
    ) else (
        set "bw_pages=!bw_pages!,!page_num!"
    )
)
if defined color_pages set "color_pages=!color_pages:~1!"
if defined bw_pages set "bw_pages=!bw_pages:~1!"
echo 彩页: !color_pages!
echo 黑白页: !bw_pages!
if defined color_pages (
    %QPDF_EXE% "_src.pdf" --pages . !color_pages! -- "out\彩-!name!.pdf"
    echo 【彩色打印】已生成：out\彩-!name!.pdf
) else (
    echo 该文档无彩页
)
if defined bw_pages (
    %QPDF_EXE% "_src.pdf" --pages . !bw_pages! -- "out\黑-!name!.pdf"
    echo 【黑白打印】已生成：out\黑-!name!.pdf
) else (
    echo 该文档无黑白页
)
del "_src.pdf" "_tmp_img.pdf" "_tmp_ink.txt" 2>nul
echo.
exit /b