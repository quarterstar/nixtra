{ config, settings, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ sops ];

  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  sops.secrets = settings.security.sops.keys;
  sops.templates = settings.security.sops.templates config.sops;
}
