{ lib, ... }: {
  programs.nixcord = {
    quickCss = lib.readRootFile "/assets/programs/discord/style.css";
    discord.vencord.enable = true;

    config = {
      useQuickCss = true;
      enableReactDevtools = true;
      themeLinks = [ "https://catppuccin.github.io/discord/dist/catppuccin-mocha-blue.theme.css" ];

      plugins = {
        blurNsfw.enable = true;
        volumeBooster.enable = true;
        clearUrls.enable = true;
        copyEmojiMarkdown.enable = true;
        youtubeAdblock.enable = true;
        experiments.enable = true;
        fixCodeblockGap.enable = true;
        fixImagesQuality.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        gameActivityToggle.enable = true;
        imageZoom.enable = true;
        memberCount.enable = true;
        mentionAvatars.enable = true;
        noDevtoolsWarning.enable = true;
        noF1.enable = true;
        openInApp.enable = true;
        voiceDownload.enable = true;
        validUser.enable = true;
        translate.enable = true;
        whoReacted.enable = true;
        alwaysTrust.enable = true;
        betterFolders.enable = true;
        callTimer.enable = true;
        showMeYourName.enable = true;
        showHiddenChannels.enable = true;
        silentMessageToggle.enable = true;
        serverInfo.enable = true;
        platformIndicators.enable = true;
        characterCounter.enable = true;

        alwaysExpandRoles = {
          enable = true;
          hideArrow = true;
        };

        alwaysAnimate = {
          enable = true;
          icons = true;
          nameplates = true;
        };

        fakeNitro = {
          enable = true;
          enableEmojiBypass = false;
        };
      };
    };
  };
}
