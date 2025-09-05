# Hyprland Unity Fix

This is a fix needed due to Unity devs being highly competent and handling windows well.

## How it works

1. Windows get initial focus and are no longer insta closed thanks to the `allowsinput` window rule
2. Tooltips no longer steal focus
3. Certain windows, such as color pickers and component selectors, are opened at optimal positions relative to the cursor

## Usage

Simply add this repository as a submodule to your dotfiles:

```sh
git submodule add https://github.com/nnra6864/HyprlandUnityFix hypr/HyprlandUnityFix
```

Or clone it if you don't need updates:

```sh
git clone https://github.com/nnra6864/HyprlandUnityFix hypr/HyprlandUnityFix
```

Once that's done, simply source it in your Hyprland config:

```
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

## OH NO, THIS WINDOW NO WORKY

Run `sleep 3 && hyprctl clients`, open the window that's not working and wait for the output. Get the broken window info and make a new issue with details.

## OH NO, MY WINDOW IMMEDIATELY CLOSES

No worries, I made gpt write a simple script that'll constantly print newly opened windows.

<details>

<summary>List New Windows</summary>

```sh
#!/bin/bash

# Function to get sorted list of window IDs
get_window_ids() {
    hyprctl clients | grep '^Window' | awk '{ print $2 }' | sort
}

# Initial snapshot
prev_ids=$(get_window_ids)

while true; do
    sleep 0.01
    current_ids=$(get_window_ids)

    # Compare current and previous IDs
    if [[ "$current_ids" != "$prev_ids" ]]; then
        # Print only the new windows
        new_ids=$(comm -13 <(echo "$prev_ids") <(echo "$current_ids"))
        for id in $new_ids; do
            echo -e "\nNew window detected: $id"
            # Extract and print full block for that window
            hyprctl clients | awk -v id="$id" '
                $2 == id && $1 == "Window" { in_block=1 }
                in_block {
                    print
                    if ($0 ~ /^$/) in_block=0
                }
            '
        done

        prev_ids="$current_ids"
    fi
done
```

</details>

Create a file, e.g. ListNewWindows.sh, paste the script provided above into it, and run it `sh ListNewWindows.sh`.
