# Hyprland Unity Fix
This is a fix needed due to Unity devs being highly competent and handling windows well.

## How does it work
1. It sets min window size to something higher than 0 so windows actually show up
2. It prevents useless windows(such as tooltips) from stealing focus
3. It opens popups at cursor position

## Usage
Simply add this repository as a submodule to your dotfiles:
```sh
git submodule add https://github.com/nnra6864/HyprlandUnityFix hypr/HyprlandUnityFix
```
Or clone it if you don't need updates:
```sh
git clone git submodule add https://github.com/nnra6864/HyprlandUnityFix hypr/HyprlandUnityFix
```
Once that's done, simply source it in your Hyprland config:
```
source = ~/.config/hypr/HyprlandUnityFix/UnityFix.conf
```

## OH NO, THIS WINDOW NO WORKY
Run `sleep 3 && hyprctl clients`, open the window that's not working and wait for the output. Get the broken window info and add it to config. Make a pull request and I'll merge it.
