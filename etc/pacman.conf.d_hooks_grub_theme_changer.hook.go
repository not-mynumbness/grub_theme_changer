#/etc/pacman.conf.d/hooks/grub_theme_change.hooks
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = *

[Action]
Description = Updates the grub Theme For Deffn...
Depends = pacman
When = PostTransaction
Exec = /bin/bash $HOME/.config/scripts/changegrub.sh