let 
    GLOBAL = import ../../_global.nix;
in {
    rules = [
        "d ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH} 2775 asakiyuki public - -"
        "L+ /home/asakiyuki/PUBLIC - - - - ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}"
        "L+ /home/junko/PUBLIC - - - - ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}"
    ];
}