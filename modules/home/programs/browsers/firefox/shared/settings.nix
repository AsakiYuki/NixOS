{ ... }: {
  settings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.startup.homepage" = "about:home";
    "browser.tabs.warnOnClose" = false;

    "devtools.chrome.enabled" = true;
    "devtools.debugger.remote-enabled" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "full-screen-api.warning.timeout" = 0;
  };
}
