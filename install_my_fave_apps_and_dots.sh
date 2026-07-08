bash install_favourite_apps.sh
bash install_flatpaks.sh&
bash miscellaneous.sh&
git clone https://github.com/protein53/dotfiles ~/dotfiles
cd ~/dotfiles
xonsh save_backup_then_stow
wait
echo "Installation Complete"

