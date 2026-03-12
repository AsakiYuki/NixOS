let 
    GLOBAL = import ../../_global.nix;
in {
    rules = [
        "d ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH} 0755 asakiyuki system - -"
        "L+ /home/asakiyuki/PUBLIC - - - - ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}"
    ];
}