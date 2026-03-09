let 
    GLOBAL = ../../../../global/global.nix;
in {
    rules = [
        "d ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH} 2775 static static - -"
    ];
}