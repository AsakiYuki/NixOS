{ pkgs, ... }: {
    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;

        kernelParams = [
            "snd_hda_intel.model=lenovo" 
            "snd_acp_config.dmic_acpi_check=1"
            "snd_acp_config.dmic_detect=1"
            "snd_sof_amd_acp63_enable=1"
        ];

        extraModprobeConfig = ''
            options snd-hda-intel dmic_detect=0
        '';
    };
}