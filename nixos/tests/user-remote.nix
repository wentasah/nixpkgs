import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "user-remote";
    meta = with lib.maintainers; {
      maintainers = [ wentasah ];
    };

    nodes.machine = {
      users.users.alice = {
        isRemoteUser = true;
        autoSubUidGidRange = true;
      };
      users.users.bob = {
        isRemoteUser = true;
        subUidRanges = [
          { count = 1; startUid = 1000; }
          { count = 65534; startUid = 100001; }
        ];
      };
      users.users.carol = {
        isRemoteUser = true;
      };
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      machine.fail("grep -E '(alice|bob|carol)' /etc/passwd /etc/shadow")
      machine.succeed("grep alice /etc/subuid")
      machine.succeed("grep alice /etc/subgid")
      machine.succeed("grep bob /etc/subuid")
      machine.fail("grep bob /etc/subgid")
      machine.fail("grep carol /etc/subuid")
      machine.fail("grep carol /etc/subgid")
    '';
  }
)
