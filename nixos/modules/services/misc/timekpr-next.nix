{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    services.timekpr-next = {
      enable = lib.mkEnableOption "Timekpr-nExT daemon";
    };
  };

  config = lib.mkIf config.services.sysprof.enable {
    environment.systemPackages = [ pkgs.timekpr-next ];
    services.dbus.packages = [ pkgs.timekpr-next ];
    systemd.packages = [ pkgs.timekpr-next ];
  };

  meta.maintainers = pkgs.timekpr-next.meta.maintainers;
}
