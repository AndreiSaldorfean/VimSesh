# SeshVim

The goal of ```SeshVim``` is to provide a similar VScode experience, but in the cli. I am a begginer myself so
I didn't wanted to stick with the default Neovim keybinds, because I don't have enough time to learn them, I just wanted
get a terminal-ide experience as fast as I could.

I get the 'Then why try NeoVim in the first place if you change all the keybinds anyway?', well the differences of an IDE/ text
editor doesn't consist in keybinds only but, in my opinion, the experience of it matters the most, and what
makes it different from the others. Also, having a light weight - minimum requirements IDE is just impresive and cool.
I didn't wanted to bother spending time learning a lot of keybinds and stuff because I can't fully make the transition so
having the same keybinds is just more confortable at the moment.
I hope this can be usefull for somebody that want to quickly jump into Neovim, comming from VScode or similar IDE's.

# Requirements
* **Ripgrep** - for Telescope (you need this for fuzzy find, aka. search throughout the opened project)
* **Neovim** > 0.10
* **LLVM(clang)**; *Windows users only* - this is used for tree-sitter, for Windows users. Basically what this does, it allows you to download
                language packages for tree-sitter, for syntax highlighting. You need to add clang to Environment Variables.
                * **Terminal** - set your custom terminal emulator you want to use inside Neovim. I use Git Bash so in the file ```lua/core/options.lua```
  there is ```bash.exe``` set as the ````shell````
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

# Notes

You will need for c/c++ a .ccls and .compile_commands.json. In compile_commands.json you can have this as a template:
``````
[
  {
    "arguments": [
      "/usr/bin/g++",
      "-c",
      "-I/usr/lib/avr/include",
      "main.cpp"
    ],
    "directory": "/home/rudy/.config/nvim/",
    "file": "/home/rudy/.config/nvim/main.cpp"
  }
]
``````
