# macOS Dotfiles

Personal macOS configuration focused on a minimal, keyboard-driven workflow.

## Toc
* [Components](#components)
* [Scripts](#scripts)
* [Shell](#shell)
* [Installation](#installation)
* [Wallpaper Picker](#wallpaper-picker)
* [Notes](#notes)

## Components

- **Package manager:** [Homebrew](https://brew.sh/)
- **Tiling window manager:** [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- **Status bar:** [SketchyBar](https://github.com/FelixKratz/SketchyBar)
- **Colored window borders:** [JankyBorders](https://github.com/FelixKratz/JankyBorders)
- **Hotkey daemon:** [skhd](https://github.com/asmvik/skhd)
- **Screenshot tool:** [Flameshot](https://github.com/flameshot-org/flameshot)
- **Resource monitor:** [btop](https://github.com/aristocratos/btop)
- **Terminal:** [Kitty](https://github.com/kovidgoyal/kitty)
- **`cat` replacement:** [bat](https://github.com/sharkdp/bat)
- **Command-line fuzzy finder:** [fzf](https://github.com/junegunn/fzf)
- **Wallpaper picker:** [Raypaper](https://github.com/SgSiegens/raypaper)
- **Color palette generator:** [pywal16](https://github.com/eylles/pywal16)

## Scripts
The repo also ships with a few scripts required to run the wallpaper picker and automate the color
scheme adjustment using `pywal16`. You can find the keybindings for the wallpaper picker menu inside 
the skhd configuration.

## Shell

The default shell is Bash, but not the version shipped with macOS.

A newer version of Bash is installed through Homebrew and configured as the default shell.


## Installation

Clone the repository 
```bash
git clone https://github.com/SgSiegens/macos-dotfiles.git
cd macos-dotfiles
```

This repository includes an installation script that automatically installs the required 
dependencies and sets up the dotfiles. The installation script also runs `setup_macos.sh`, 
which configures general macOS settings such as hiding the menu bar and Dock by default.

Make the installation scripts executable:

```bash
chmod +x install.sh setup_macos.sh
```
then run 
```bash
./install.sh
```


## Wallpaper Picker
The default wallpaper picker is Raypaper. If you do not want to use Raypaper, you can use 
[nsxiv](https://github.com/nsxiv/nsxiv) instead. Install nsxiv through [MacPorts](https://ports.macports.org/port/nsxiv/details/) for which you also need [XQuartz](https://github.com/XQuartz/XQuartz)

```bash
brew install --cask xquartz
sudo port install nsxiv
```


If you encounter a Cannot open display error when running an X11 application, [see](https://superuser.com/questions/310197/how-do-i-fix-a-cannot-open-display-error-when-opening-an-x-program-after-sshi).

## Notes
This repository is primarily intended for my personal macOS setup. Review the installation and 
configuration scripts before running them on your system.
