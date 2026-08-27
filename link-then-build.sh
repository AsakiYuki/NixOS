if [ -e /etc/nixos ]; then
    if [ $(readlink /etc/nixos) == $(pwd) ]; then
        ./build.sh $1
    else
        echo "current configuration exist, cannot build!";
    fi
else 
    ./symlink.sh
    ./build.sh $1
fi