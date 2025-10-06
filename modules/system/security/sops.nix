{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ sops ];

  sops.defaultSopsFile = ../../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  sops.secrets = config.nixtra.security.sops.keys;
  #sops.templates = config.nixtra.security.sops.templates config.sops;
}
