{ config, unstable-pkgs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = if config.nixtra.hardware.gpu == "amd" then
      "rocm"
    else if config.nixtra.hardware.gpu == "nvidia" then
      "cuda"
    else
      false;
    package = unstable-pkgs.ollama;
  };
}
