{ settings, profile, lib, pkgs, ... }:

let
  rawConfig = builtins.readFile
    ../../../../../../config/${profile.user.config}/wm/hyprland/hypr/hyprland.conf;
  backgroundConfig = if profile.env.background.enable then ''
    windowrule = float, class:^${profile.env.background.program}$
    windowrule = size 100% 100%, class:^${profile.env.background.program}$
    windowrule = move 0 0, class:^${profile.env.background.program}$
    windowrule = nofocus, class:^${profile.env.background.program}$
    windowrule = noborder, class:^${profile.env.background.program}$
    windowrule = noshadow, class:^${profile.env.background.program}$
    windowrule = idleinhibit full, class:^${profile.env.background.program}$ # Prevent idle actions
    layerrule = unset, class:^${profile.env.background.program}$
    layerrule = noanim, class:^${profile.env.background.program}$
    windowrulev2 = immediate, class:^${profile.env.background.program}$
    windowrulev2 = pin, class:^${profile.env.background.program}$
    windowrulev2 = noinitialfocus, class:^(${profile.env.background.program})$
  '' else
    "";
  startupConfig = lib.concatStringsSep "\n"
    (map (program: "exec-once = ${program}") profile.env.startupPrograms);

  profilerProgram = if settings.hardware.gpu == "amd" then {
    class = "amdgpu_top";
    start = "amdgpu_top --gui";
  } else
    { };

  # Show GPU stats for AMDGPU.
  # TODO: When similar tools are created for other GPUs (NVIDIA, Intel...), add them here.
  profilerSpecialWorkspace = if profilerProgram != { } then ''
    workspace = special:stats, on-created-empty exec ${profilerProgram.class}
    windowrule = workspace special:stats silent, class:^${profilerProgram.class}$
    windowrule = noborder, class:^${profilerProgram.class}$
    windowrule = float, class:^${profilerProgram.class}$ # Important for custom positioning/sizing if needed
    windowrule = idleinhibit full, class:^${profilerProgram.class}$ # Prevent screen from turning off
    windowrule = noinitialfocus, class:^(${profilerProgram.class})$
    windowrule = nofocus, class:^(${profilerProgram.class})$
    windowrule = size 100% 100%, class:^(${profilerProgram.class})$
    animation = specialWorkspace, 1, 6, default, slidefadevert -50%
    bind = $mainMod, G, togglespecialworkspace, stats
    # TODO: lazy-load
    exec-once = ${profilerProgram.start}
  '' else
    "";
in {
  xdg.configFile."hypr/hyprland.conf".source = pkgs.writeText "hyprland.conf" ''
    ${rawConfig}
    # Background config
    ${backgroundConfig}
    # Profiler config
    ${profilerSpecialWorkspace}
    # Startup programs config
    ${startupConfig}
  '';
}
