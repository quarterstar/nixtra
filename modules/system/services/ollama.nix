{ settings, pkgs, ... }:

{
  services.ollama.enable = true;
  services.ollama.acceleration = if settings.hardware.gpu == "amd" then "rocm" else if settings.hardware.gpu == "nvidia" then "cuda" else false;
}
