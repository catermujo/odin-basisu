@echo off

setlocal EnableDelayedExpansion

set "VENDOR_WINDOWS_ARCH=%VSCMD_ARG_TGT_ARCH%"
if not defined VENDOR_WINDOWS_ARCH set "VENDOR_WINDOWS_ARCH=%PROCESSOR_ARCHITECTURE%"
if /I "%VENDOR_WINDOWS_ARCH%"=="AMD64" set "VENDOR_WINDOWS_ARCH=x64"
if /I "%VENDOR_WINDOWS_ARCH%"=="ARM64" set "VENDOR_WINDOWS_ARCH=arm64"
if /I "%VENDOR_WINDOWS_ARCH%"=="X86" set "VENDOR_WINDOWS_ARCH=x64"

set "BASE=%~dp0"
set "SOURCE_DIR=%BASE%basis_universal"
set "BUILD_DIR=%BASE%build_shared_%VENDOR_WINDOWS_ARCH%"
set "OUTPUT_DIR=%BASE%windows_%VENDOR_WINDOWS_ARCH%"

if not exist "%SOURCE_DIR%" (
    git clone --revision 1e9ab1f575cd52d2bfc053dd4def2da5f091316f --depth=1 https://github.com/BinomialLLC/basis_universal.git "%SOURCE_DIR%" || exit /b 1
)

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo Configuring shared build...
cmake -A %VENDOR_WINDOWS_ARCH% -S "%BASE%" -B "%BUILD_DIR%" -DCMAKE_BUILD_TYPE=Release -DBASISU_BUILD_SHARED=ON || exit /b 1

echo Building shared project...
cmake --build "%BUILD_DIR%" --target basisu_c --config Release || exit /b 1

copy /y "%BUILD_DIR%\Release\basisu_c.lib" "%OUTPUT_DIR%\basisu_c_shared.lib" >nul || exit /b 1
copy /y "%BUILD_DIR%\Release\basisu_c.dll" "%OUTPUT_DIR%\basisu_c.dll" >nul || exit /b 1

echo Shared build completed successfully!
exit /b 0
