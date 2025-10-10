# Hyprland Unity Fix

Collection of fixes and workarounds needed due to Unity devs being highly competent.

## Usage

Simply add this repository as a submodule to your dotfiles:

```sh
git submodule add https://github.com/nnra6864/HyprlandUnityFix hypr/HyprlandUnityFix
```

Or clone it:

```sh
git clone https://github.com/nnra6864/HyprlandUnityFix hypr/HyprlandUnityFix
```

Once that's done, simply source it in your Hyprland config:

```ini
source = ~/.config/hypr/HyprlandUnityFix/UnityFix.conf
```

### Using Nix

This patch includes a flake for easy integration into a nix managed system.
Include the flake as normal, and pass it into your home-manager or nix system configuration.

```nix
inputs.hyprland-unity-fix.url = "github:nnra6864/HyprlandUnityFix";
```

Then import it into your configuration.

```nix
{ inputs, ... }:

{
  imports = [
    ./main.nix
    ./flake.nix
    inputs.hyprland-unity-fix.nixosModules.hyprlandUnityFixModule
  ];
}
```

Then enable the module.

```nix
{
  hyprlandUnityFix = {
    enable = true;
    configRules = [
      "windowrulev2 = stayfocused, class:^Unity$"
      "some other valid hyprland configuration..."
    ];
  };
  wayland.windowManager.hyprland = {
    enable = true;
  };
}
```

#### Without Flakes

If you aren't using flakes, you can still use this patch. You'd want to clone/make a submodule as usual, though, make sure to place the submodule in a "submodules", so nix knows to copy it to the store. From there, you'd want to import the `UnityFix.conf` file like so:

```nix
{
  wayland.windowManager.hyprland = {
    settings = {
      ...
    }
    ...
    extraConfig = ''${builtins.readFile ./submodules/HyprlandUnityFix/UnityFix.conf}'';
  };
}
```

## Rules

Rules fix most of the issues related to popups instantly closing and Unity being unusable in general.
1. Windows get initial focus and are no longer insta closed thanks to the `allowsinput` window rule
2. Tooltips no longer steal focus
3. Certain windows, such as color pickers and component selectors, are opened at optimal positions relative to the cursor

## [ReloadUnity.sh](ReloadUnity.sh)

This script simply opens a terminal, makes it real small and centered, then switches focus between Unity and that terminal many times quickly.
This, for some reason, triggers a reload.
Unity devs truly amaze me.
Simply add the following bind to your Hyprland config:
```ini
bind = $mainMod CTRL, U, exec, sh ~/.config/hypr/HyprlandUnityFix/ReloadUnity.sh
```

## [ListNewWindows.sh](ListNewWindows.sh)

Simple script that utilizes hyprctl and prints data of newly opened windows.
Useful for getting info of windows that instantly close.
Simply run it from your terminal:
```sh
sh ~/.config/hypr/HyprlandUnityFix/ListNewWindows.sh
```

## OH NO, THIS WINDOW NO WORKY

Run `sleep 3 && hyprctl clients`, open the window that's not working and wait for the output. Get the broken window info and make a new issue with details.
