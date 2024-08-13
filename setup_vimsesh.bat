::This script shall install the necessary files
::in order to setup the repo

@echo off
echo "Please run this script in administrator before proceeding further..."

::Set 1:Fetch the font

set FONT="JetBrainsMonoNerdFont-Regular.ttf"
set FONT_DIR="fonts"

mkdir %FONT_DIR%

echo "Fetching font from the web..."
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip --ssl-revoke-best-effort --output %FONT_DIR%\fonts.zip
::If the user wants another font, then he shall change the link

tar -xf  %FONT_DIR%\fonts.zip -C %FONT_DIR%

copy  %FONT_DIR%\%FONT% %WINDIR%\Fonts
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "FontName (TrueType)" /t REG_SZ /d %FONT% /f

rmdir /s /q %FONT_DIR%
echo "Finished installing font"

::Step 2:Fetch Neovim and add it to PATH
::Due to the fact that the repo works only in %APPDATA%\..\Local directory
::the rest of the files will be installed there

set NVIM_FILE=nvim-win64

C:
cd %APPDATA%\..\Local
set NVIM_DIR=%APPDATA%\..\Local\Neovim\bin\

echo "Fetching Neovim from the web..."
curl -L https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-win64.zip --ssl-revoke-best-effort --output %NVIM_FILE%.zip

tar -xf  %NVIM_FILE%.zip
ren %NVIM_FILE% Neovim
del %NVIM_FILE%.zip 
echo "Finished installing Neovim"

setx NVIM_PATH %NVIM_DIR%
set "newPath=%PATH%;%NVIM_PATH%"
setx PATH "%newPath%"

::It seems that only "" work for setx instead of ''
echo "Finished adding Neovim to PATH variable"


::Step 3:Fetch ripgrep and add it to PATH

C:
cd %APPDATA%\..\Local
set RIPGREP_FILE=ripgrep-14.1.0-x86_64-pc-windows-msvc
set RIPGREP_DIR=%APPDATA%\..\Local\ripgrep\

echo "Fetching ripgrep from the web..."

curl -L https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-pc-windows-msvc.zip --ssl-revoke-best-effort --output %RIPGREP_FILE%.zip
tar -xf %RIPGREP_FILE%.zip

ren  %RIPGREP_FILE% ripgrep
del %RIPGREP_FILE%.zip

echo "Finished installing ripgrep"

setx RIPGREP_PATH %RIPGREP_DIR%
setx PATH "%PATH%;%RIPGREP_PATH%"
echo "Finished adding ripgrep to PATH variable"

::Step 4:Fetch the repo

C:
cd %APPDATA%\..\Local

echo "Fetching the repo from the web..."
git clone https://github.com/AndreiSaldorfean/VimSesh.git
echo "Finished installing the repo"