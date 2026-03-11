let 
    GLOBAL = import ../../../../common/global.nix;
in {
    rules = [
        "d ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH} 0755 asakiyuki static - -"
        "L+ /home/asakiyuki/PUBLIC - - - - ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}"
    ];
}