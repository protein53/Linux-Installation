bash install_favourite_apps.sh
bash install_flatpaks.sh &
bash miscellaneous.sh &
git clone https://github.com/protein53/dotfiles ~/dotfiles
cd ~/dotfiles
bash prestow.sh
stow *
wait
echo "Installation Complete"

