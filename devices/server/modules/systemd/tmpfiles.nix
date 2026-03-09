let 
    GLOBAL = import ../../../../global/global.nix;
in {
    rules = [
        "d ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH} 0755 asakiyuki static - -"
        "L+ ${GLOBAL.HOME_DIRECTORY}/PUBLIC - - - - ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}"
    ];
}