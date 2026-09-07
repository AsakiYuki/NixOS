{config, ...}: {
  services.searx = {
    enable = false;
    environmentFile = config.age.secrets.searxenv.path;
    settings = {
      general = {
        debug = false;
        instance_name = "SearXNG";
        privacypolicy_url = false;
        donation_url = false;
        contact_url = false;
        enable_metrics = true;
        open_metrics = "";
      };

      search = {
        safe_search = 0;
        autocomplete = "google";
        favicon_resolver = "google";
        default_lang = "vi";
        languages = ["all"];
        formats = ["json" "html"];
      };

      server = {
        port = 39212;
        base_url = "https://search.asakiyuki.com";
        bind_address = "127.0.0.1";
        method = "GET";
      };

      ui = {
        default_locale = "en";
        center_alignment = true;
        cache_url = "https://webcache.googleusercontent.com/search?q=cache";
        hotkeys = "vim";
        url_formatting = "full";
      };

      plugins = {
        "searx.plugins.calculator.SXNGPlugin".active = true;
        "searx.plugins.hash_plugin.SXNGPlugin".active = true;
        "searx.plugins.self_info.SXNGPlugin".active = true;
        "searx.plugins.tracker_url_remover.SXNGPlugin".active = true;
        "searx.plugins.hostnames.SXNGPlugin".active = true;
        "searx.plugins.unit_converter.SXNGPlugin".active = true;
      };
    };
  };
}
