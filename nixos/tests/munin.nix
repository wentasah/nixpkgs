# This test runs basic munin setup with node and cron job running on the same
# machine.

import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "munin";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ domenkozar ];
    };

    nodes = {
      one =
        { config, ... }:
        {
          services = {
            munin-node = {
              enable = true;
              # disable a failing plugin to prevent irrelevant error message, see #23049
              disabledPlugins = [ "apc_nis" ];
            };
            munin-cron = {
              enable = true;
              hosts = ''
                [${config.networking.hostName}]
                address localhost
              '';
            };
            nginx = {
              enable = true;
              virtualHosts.munin = {
                locations = {
                  "/".root = "/var/www/munin";
                  "/static/".root = "${pkgs.munin}/etc/opt/munin";
                  "^~ /munin-cgi/munin-cgi-graph/" = {
                    extraConfig = ''
                      access_log off;
                      fastcgi_split_path_info ^(/munin-cgi/munin-cgi-graph)(.*);
                      fastcgi_param PATH_INFO $fastcgi_path_info;
                      fastcgi_pass unix:/run/munin/fastcgi-graph.sock;
                      include ${pkgs.nginx}/conf/fastcgi_params;
                    '';
                  };
                };
              };
            };
          };

          # increase the systemd timer interval so it fires more often
          systemd.timers.munin-cron.timerConfig.OnCalendar = pkgs.lib.mkForce "*:*:0/10";
        };
    };

    testScript = ''
      start_all()

      with subtest("ensure munin-node starts and listens on 4949"):
          one.wait_for_unit("munin-node.service")
          one.wait_for_open_port(4949)

      with subtest("ensure munin-cron output is correct"):
          one.wait_for_file("/var/lib/munin/one/one-uptime-uptime-g.rrd")
          one.wait_for_file("/var/www/munin/one/index.html")
          one.wait_for_file("/var/www/munin/one/one/diskstat_iops_vda-day.png", timeout=60)

      with subtest("ensure graphs can be generated dynamically via FastCGI"):
          one.wait_for_unit("munin-cgi-graph.service")
          one.wait_for_unit("nginx.service")
          one.succeed("curl -f http://localhost/munin-cgi/munin-cgi-graph/one/one/load-day.png")
    '';
  }
)
