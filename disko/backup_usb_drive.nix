{
  disko.devices = {
    disk = {
      backupstorage = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            secrets = {
              size = "32M";
                 priority = 1;
              content = {
                type = "luks";
                name = "secrets";
                settings.allowDiscards = true;
                passwordFile = "/home/fobos/nix/1.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  extraArgs = ["-L" "secrets"];
                };
              };
            };
            private = {
              size = "4G";
              priority = 3;
              content = {
                type = "luks";
                name = "private";
                settings.allowDiscards = true;
                passwordFile = "/home/fobos/nix/2.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  extraArgs = ["-L" "private"];
                };
              };
            };
            storage = {
                 priority = 4;
              size = "100G";
              content = {
                type = "luks";
                name = "storage";
                settings.allowDiscards = true;
                passwordFile = "/home/fobos/nix/3.key";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  extraArgs = ["-L" "storage"];
                };
              };
            };
          };
        };
      };
    };
  };
}
