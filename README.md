# VimSesh

The goal of VimSesh is to have a fast light-weight *IDE* in the CLI.

# Requirements
* **Ripgrep** - for Telescope (you need this for fuzzy find, aka. search throughout the opened project)
* **Neovim** > 0.10
* **LLVM(clang)**; *Windows users only* - this is used for tree-sitter, for Windows users. Basically what this does, it allows you to download
                language packages for tree-sitter, for syntax highlighting. You need to add clang to Environment Variables.
                **Terminal** - set your custom terminal emulator you want to use inside Neovim. I use Git Bash so in the file ```lua/core/options.lua``` there is ```bash.exe``` set as the ````shell````
* **PowerShell**; *Windows users only* - For a nicer PowerShell experience i recommend to use newer PowerShell from [here](https://github.com/PowerShell/PowerShell?tab=readme-ov-file)
                                       - I also recommend to install completion options for git inside PowerShell with ```Import-Module posh-git``` and add this command to your ``$PROFILE``, then restart with ```. $PROFILE```:
````
if (!(Test-Path -Path $PROFILE)) {
    New-Item -Type File -Path $PROFILE -Force
}
Add-Content -Path $PROFILE -Value "Import-Module posh-git"
````
# Key binds

To be added. This is still in progress, but I configured a few basic stuff.

# What to run after launching Neovim for the first time
*    ````MasonInstall cpptools```` for C/C++ debugger
