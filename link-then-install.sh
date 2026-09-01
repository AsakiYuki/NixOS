if [ -e /etc/nixos ]; then
    if [ "$(readlink /etc/nixos)" == "$(pwd)" ]; then
        ./install.sh "$1"
    else
        echo "current configuration exist, cannot install!"
    fi
else
    ./symlink.sh
    ./install.sh "$1"
fi
