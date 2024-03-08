#!/bin/bash

# Install required programs


function setup() {
    # Change Shell
    sudo echo "/usr/bin/zsh" >> /etc/shells
    chsh -s $(which zsh)
    sudo chsh -s $(which zsh)

    # Clone TPM (tmux plugin manager)
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # Create Base Directories
    mkdir -p ~/.config
    mkdir -p ~/.local
    mkdir -p ~/.cache


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
    ansible-vault decrypt ~/.ssh/id_ed25519

    # Clone the .dotfiles directory
    git clone git@github.com:mesahilgautam/.dotfiles.git ~/.dotfiles
    rm -rf ~/.ssh
    stow --dir=~/.dotfiles --target=~/

    # Clone back the installer
    git clone git@github.com:mesahilgautam/installer.git ~/.local/src/installer

    # light
    sudo usermod -aG video $USER
    /home/$USER/.local/bin/buildsuckless
    reboot


    # group settings
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
        "clang"
        "npm"
        "make"
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
        "newsboat"
        "yt-dlp"
        "delta-git"
        "btop"
        "xdotool"
        "gtypist"
        "thunar"
        "tmux"
        "docker"
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
        "lua"
        "gcc"
        "g++"
        "go"
        # "fzf"
        "pyenv" # to manage different python versions
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








