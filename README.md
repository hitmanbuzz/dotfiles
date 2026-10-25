# **My Arch Linux Dotfiles**

*My simple arch linux config/dotfiles*

### Enable Muti-Lib (Needed):

-  Enable `mulitlib` in `etc/pacman.conf`

### ⚠️ Reminder:

`Hyprland` is not installed by default.
If you are freshly installing `Arch Linux` then, I recommend you to install `Hyprland` through the `archinstall` script with the appropriate `GPU Driver` (mine is `Nvidia Propietary Driver` for my `RTX 3060 TI`).  

For Display Manager, select `SDDM` as it works properly. Others also works but if you are new then select that option.

**Symlinking Program**: *[Symlinker](https://github.com/hitmanbuzz/symlinker) (Made by Me)*

## Full Installation
```
chmod +x full_install.sh
./install.sh
```

## Partial Installation (Need fish)
> Install Packages
```
chmod +x scripts/packages.fish
./scripts/packages.fish
```
    
> Config Script
```
chmod +x scripts/config.fish
./scripts/config.fish
```

## Screenshots
![Desktop](./screenshots/1.png)
![Launcher](./screenshots/2.png)
![Power-Menu](./screenshots/3.png)
![Terminal](./screenshots/4.png)
