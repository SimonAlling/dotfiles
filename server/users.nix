{ config, pkgs, stdenv, ... }:

{

users = {
  mutableUsers = false;

  extraUsers = {
    root = {
      hashedPassword = REDACTED;
    };

    alling = {
      isNormalUser = true;
      description = "Simon Alling";
      uid = 1000;
      group = "alling";
      hashedPassword = REDACTED;
      extraGroups = [ "wheel" "networkmanager" "nginx" "fuse" "docker" ];
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtzWjlAs/MhcNhphoi89XEk1WebSAMXXd61/EcOwxPdGuqtQ4Mm8PKwhqMjZB5DcmbiwP8Hvd5Y+WOiVxrZ7MPQiimU2IKzP0GjTyfoo5P564bjH7NbtR79nv/92YMW4WtU8eiRM1tiOw0QzmGZYq7pwESYaZas8LvijCaVqJHBnr2GV7yttwlPyVN1eEr6dgkIXtb9i5djqiaB3cSMtM0W4jq2TX9GETkcNoU/gkW9LQesu152fvkI8+RQIU53k2oGpkZp17Fi+spzNq3i+sE5shb+7ZFvrx+Jt6ONu9p4alLaShNmfH7zPCYxq7Dac+S0p8SLMMaJC0dChkXk6ij alling@alling-server" ];
    };

    build = {
      group = "build";
      createHome = true;
      home = "/home/build";
    };
  };

  groups = {
    "alling" = { gid = 1000; };
    "build" = { };
  };
};

}
