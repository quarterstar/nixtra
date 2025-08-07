{ settings, unstable-pkgs, ... }:

{
  services.ollama = {
    enable = true;
    acceleration = if settings.hardware.gpu == "amd" then
      "rocm"
    else if settings.hardware.gpu == "nvidia" then
      "cuda"
    else
      false;
    package = unstable-pkgs.ollama;
  };
}
