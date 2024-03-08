#!/bin/bash

# Install required programs


function setup() {
    # Change Shell
    sudo echo "/usr/bin/zsh" >> /etc/shells
    chsh -s $(which zsh)
    sudo chsh -s $(which zsh)

    # Clone TPM (tmux plugin manager)
    [[ -d  "~/.tmux" ]] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # Create Base Directories
    rm -rf ~/.config 
    rm -rf ~/.local 
    rm -rf ~/.cache 
    rm -rf ~/repos

    mkdir -p ~/.config
    mkdir -p ~/.local
    mkdir -p ~/.cache
    mkdir -p ~/repos


    # trackpad settings
    sudo printf 'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Option "Tapping" "on"
        Option "ScrollMethod" "twofinger"
        Option "HorizontalScrolling" "on"
        Option "DisableWhileTyping" "on"
        Driver "libinput"\nEndSection' > /etc/X11/xorg.conf.d/30-touchpad.conf


    # Decrypt the ssh key
    cp -r ~/installer/.ssh ~/.ssh
    chmod 600 ~/.ssh/id_ed25519
    ansible-vault decrypt ~/.ssh/id_ed25519

    # Clone the .dotfiles directory
    git clone git@github.com:mesahilgautam/.dotfiles.git ~/.dotfiles
    rm -rf ~/.ssh

    cd ~/.dotfiles && stow .
    cd

    chmod 400 ~/.ssh/id_ed25519
    # Clone back the installer
    git clone git@github.com:mesahilgautam/installer.git ~/.local/src/installer
    git clone git@github.com:mesahilgautam/files.git ~/files

    # light
    sudo usermod -aG video $USER
    /home/$USER/.local/bin/buildsuckless

    sudo cp /usr/share/fontconfig/conf.avail/75-twemoji.conf /etc/fonts/conf.d/

    reboot
}


function packageInstall() {
    packages=(
        "brave-bin"
        "xorg-server"
        "xorg-xinit"
        "xorg-xrandr"
        "xorg-setxkbmap"
        "xorg-xset"
        "xorg-xfontsel"
        "libpulse"

        "neovim"
        "npm"
        "make"
        "ttf-twemoji"
        "openssh"
        "patch"
        "which"
        "ansible"
        "stow"
        "thunderbird"
        "cowsay"
        "cmake"
        "xwallpaper"
        "xcompmgr"
        "xsel"
        "xclip"
        "light"
        "libnotify"
        "dunst"
        "flameshot"
        "zsh"
        "zsh-syntax-highlighting-git"
        "yt-dlp"
        "delta-git"
        "btop"
        "xdotool"
        # "gtypist"
        "thunar"
        "tmux"
        # "docker"
        "unzip"
        "ripgrep"
        "delta-git"
        "man"
        "wireless_tools" # for wifi name
        # "visual-studio-code-bin"
        # "firefox" # for other email
        # "feh"
        # "sxiv"
        "pavucontrol"
        # "wal" # pywal
        # "mpv"
        # "lua"
        "gcc"
        "g++"
        # "go"
        # "fzf"
        # "pyenv" # to manage different python versions
        # "lazygit" # a minimal terminal based git client(ish) [maybe]
        # "mkdocs"
        # "mdp"
        # "sfml"
        # add mobile usb file transfer support
        # "sxhkd"     # to setup keybindings beyond default dwm keybindings
        # ""
        # ""
        # ""
    )

    sudo pacman -Syu

    for name in ${packages[@]}
    do
        yay -S $name --noconfirm
    done
}

function installYay() {
    if command -v fakeroot;
    then
        sudo pacman -S git --noconfirm
        cd /tmp
        git clone https://aur.archlinux.org/yay-bin
        cd yay-bin
        makepkg -si
    else
        sudo pacman -S fakeroot --noconfirm
        installYay # install yay after installing fakeroot
    fi
}

command -v yay || installYay
packageInstall
setup


# ~/.dotfiles
# ~/files
# ~/repos
#     libreoffice
#     ...
