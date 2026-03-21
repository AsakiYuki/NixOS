{ inputs, pkgs, ... }: let
  background = ../../../common/grub/background.png;
  baseTheme = inputs.honkai-railway-grub-theme.packages.${pkgs.stdenv.hostPlatform.system}.cyrene-grub-theme;
in {
    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        extraModulePackages = [ pkgs.linuxPackages_latest.zenpower ];

        kernelParams = [
            "snd_hda_intel.model=lenovo" 
            "snd_acp_config.dmic_acpi_check=1"
            "snd_acp_config.dmic_detect=1"
            "snd_sof_amd_acp63_enable=1"
            "amd_pstate=active"
        ];

        kernelModules = [ 
            "k10temp" 
            "ideapad_laptop"
        ];

        kernel.sysctl = {
            "net.ipv4.ip_forward" = 1;
            "net.ipv4.conf.all.forwarding" = 1;
            "net.ipv6.conf.all.forwarding" = 1;
        };

        extraModprobeConfig = ''
            options snd-hda-intel dmic_detect=0
        '';

        loader = {
            systemd-boot.enable = false;
            efi.canTouchEfiVariables = true;

            grub = rec {
                enable = true;
                device = "nodev";
                efiSupport = true;
                useOSProber = true;

                splashImage = background;
                theme = pkgs.runCommand "my-grub-theme" {} ''
                    mkdir -p $out
                    cp -r ${baseTheme}/* $out/
                    chmod -R u+w $out
                    cp ${background} $out/background.png
                '';
            };
        };
    };
}