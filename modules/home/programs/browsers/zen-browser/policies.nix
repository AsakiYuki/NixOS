{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (!config.programs.disable-module.zen-browser) {
    programs.zen-browser.policies = {
      Authentication = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      DisableFirefoxStudies = true;
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      ExtensionSettings = {
        "authenticator@mymindstorm".private_browsing = true;
        "78272b6fa58f4a1abaac99321d503a20@proton.me".private_browsing = true;
        "addon@darkreader.org".private_browsing = true;
        "uBlock0@raymondhill.net".private_browsing = true;
        "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}".private_browsing = true;
        "vimium-c@gdh1995.cn".private_browsing = true;
      };
    };
  };
}
