let 
    GLOBAL = import ../../_global.nix;
in {
    rules = [
        "d ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH} 2775 asakiyuki public - -"
        "L+ /home/asakiyuki/PUBLIC - - - - ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}"
        "L+ /home/junko/PUBLIC - - - - ${GLOBAL.SERVER.PUBLIC_FOLDERS.PATH}"

        "d /home/MEDIA_FILES 2775 asakiyuki public - -"
        "L+ /home/asakiyuki/MEDIA_FILES - - - - /home/MEDIA_FILES"
        "L+ /home/junko/MEDIA_FILES - - - - /home/MEDIA_FILES"
    ];
}