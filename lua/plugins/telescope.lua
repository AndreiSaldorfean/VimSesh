require("telescope").setup({
  pickers = {
    find_files = {
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--no-ignore-vcs",
        "-g",
        "!**/.git/*",
        "-g",
        "!**/.ccls-cache/*",
        "-g",
        "!**/.ccls-cache/*",
        "-g",
        "!**/~/*",
        "-g",
        "!**/node_modules/*",
        "-g", "!**/.repro/*",       -- just to hide .repro rtp
      },
    },
  },
})
