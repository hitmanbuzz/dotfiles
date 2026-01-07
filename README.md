# **My Arch Linux Dotfiles**

*My simple arch linux config/dotfiles*

-  Enable `mulitlib` in `etc/pacman.conf`

## Full Installation
```
chmod +x full_install.sh
./full_install.sh
```

## Partial Installation
> Install Packages
```
chmod +x scripts/packages.sh
./scripts/packages.sh
```
    
> Symlink Config
```
chmod +x scripts/stowing.sh
./scripts/stowing.sh
```

> Enable Cloudflare-Warp
```
chmod +x scripts/warp_start.sh
./scripts/warp_start.sh
```

> Optional Script
```
chmod +x scripts/commands.sh
./scripts/commands.sh
```
