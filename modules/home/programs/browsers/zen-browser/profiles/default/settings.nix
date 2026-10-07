{...}: {
  settings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.tabs.warnOnClose" = false;
    "browser.startup.homepage" = "about:home";

    "devtools.chrome.enabled" = true;
    "devtools.debugger.remote-enabled" = true;

    "extensions.autoDisableScopes" = 0;

    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    "full-screen-api.warning.timeout" = 0;

    "zen.updates.show-update-notification" = false;
    "zen.view.window.scheme" = 0;
    "zen.welcome-screen.seen" = true;

    "network.proxy.type" = 2;
    "network.proxy.autoconfig_url" = "https://adguard.asakiyuki.com/proxy.pac";

    "network.dns.disablePrefetch" = true;
    "network.dns.disablePrefetchFromHTTPS" = true;
    "network.notify.checkForProxies" = false;
    "network.proxy.socks_remote_dns" = true;

    "network.dns.use_https_rr_as_alpn" = true;
    "network.dns.force_waiting_https_rr" = true;

    "network.trr.mode" = 3;
    "network.trr.uri" = "https://adguard.asakiyuki.com/dns-query";
    "network.trr.custom_uri" = "https://adguard.asakiyuki.com/dns-query";
    "network.trr.confirmationNS" = "skip";
  };
}
