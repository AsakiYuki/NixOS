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
    };
  };
}
