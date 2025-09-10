{ config, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    prismlauncher-unwrapped = pkgs.prismlauncher-unwrapped.overrideAttrs
      (attrs: {
        patches = (attrs.patches or [ ]) ++ [
          (pkgs.writeText "disable-microsoft-authentication.patch" ''
                    diff --git a/launcher/minecraft/auth/MinecraftAccount.h b/launcher/minecraft/auth/MinecraftAccount.h
            index f6fcfada2..3f39e6e38 100644
            --- a/launcher/minecraft/auth/MinecraftAccount.h
            +++ b/launcher/minecraft/auth/MinecraftAccount.h
            @@ -116,7 +116,7 @@ class MinecraftAccount : public QObject, public Usable {
             
                 [[nodiscard]] AccountType accountType() const noexcept { return data.type; }
             
            -    bool ownsMinecraft() const { return data.type != AccountType::Offline && data.minecraftEntitlement.ownsMinecraft; }
            +    bool ownsMinecraft() const { return true; }
             
                 bool hasProfile() const { return data.profileId().size() != 0; }
          '')
        ];
      });
  };
}
