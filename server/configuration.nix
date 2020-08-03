{ config, pkgs, stdenv, ... }:

let
  VPN_PATH = "/home/alling/vpn";
  PKI_PATH = "${VPN_PATH}/pki";
  MITMPROXY_PORT = 8080;
  MITMPROXY_PORT_TRANSPARENT = 8081;
  SSH_PORT = 222;

  borgmatic = pkgs.python36Packages.buildPythonPackage rec {
    pname = "borgmatic";
    version = "1.1.8";
    name = "${pname}-${version}";
    propagatedBuildInputs = [
      ruamel-0-15-0
    ];
    src = pkgs.python36Packages.fetchPypi {
      inherit pname version;
      sha256 = "07zvwfs1r7q8hgplr8plnzrva0cjmx5drr8czad5ms2fqq7lrb0k";
    };
    doCheck = false;
    meta = {
      homepage = "https://github.com/witten/borgmatic";
      description = "A simple wrapper script for the Borg backup software that creates and prunes backups";
    };
  };

  ruamel-0-15-0 = pkgs.python36Packages.buildPythonPackage rec {
    pname = "ruamel.yaml";
    version = "0.15.0";
    name = "${pname}-${version}";
    propagatedBuildInputs = [
      pykwalify
    ];
    src = pkgs.python36Packages.fetchPypi {
      inherit pname version;
      sha256 = "0bkq81zc25l8p0n04q1awvl65srwkf3sws5manmsdx5c482abx7r";
    };
    doCheck = false;
  };

  pykwalify = pkgs.python36Packages.buildPythonPackage rec {
    pname = "pykwalify";
    version = "1.6.0";
    name = "${pname}-${version}";
    propagatedBuildInputs = [
      pkgs.python36Packages.docopt
      pkgs.python36Packages.pyyaml
      pkgs.python36Packages.dateutil
    ];
    src = pkgs.python36Packages.fetchPypi {
      inherit pname version;
      sha256 = "0i7q5ynad0j84aba3fj2ayfp9pbj1n6inapn6lc1cs6whkzgm612";
    };
    doCheck = false;
  };
in

{
imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nextcloud.nix
    ./users.nix
    ./webserver.nix
  ];

# Use the systemd-boot EFI boot loader.
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

boot.supportedFilesystems = [ "zfs" ];

# OpenVPN
boot.kernel.sysctl = {
  "net.ipv4.ip_forward" = 1;
  "net.ipv4.conf.all.send_redirects" = 0;
};

virtualisation.docker.enable = true;

networking = {
  hostName = "alling-server";
  hostId = "d24b8e28"; # cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  interfaces.enp0s31f6 = {
    ipv4.addresses = [{
      address = "192.168.1.100";
      prefixLength = 24;
    }];
  };
  defaultGateway = {
    address = "192.168.1.1";
    interface = "enp0s31f6";
  };
  nameservers = [ "1.1.1.1" "1.0.0.1" ];
  wireless.enable = false;
};

i18n = {
  consoleFont = "Lat2-Terminus16";
  consoleKeyMap = "sv-latin1";
  defaultLocale = "en_US.UTF-8";
};

time.timeZone = "Europe/Stockholm";

/*
To search for packages:
$ nix-env -qaP | grep wget
*/
environment.systemPackages = with pkgs; [
  borgbackup
  zlib
  (python3.withPackages (ps: [ borgmatic ]))
  exfat
  docker
  git
  hdparm
  hd-idle
  sshfs-fuse
  elinks
  ntfs3g
  unzip
  tmux
  openvpn
  easyrsa
  config.services.samba.package
  haskellPackages.ghc
];

/*
Borg 1.1.0:
$ git clone https://github.com/nixos/nixpkgs
$ cd nixpkgs
$ git fetch origin refs/pull/30287/head
$ git merge FETCH_HEAD
$ nix-env -f . -iA borgbackup
*/

services.openssh = {
  enable = true;
  ports = [ SSH_PORT ];
  permitRootLogin = "no";
  passwordAuthentication = false;
};

# Mumble server
services.murmur = {
  bandwidth = 160000;
  enable = true;
  extraConfig = ''
    sslCiphers=TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:AES256-SHA:AES128-SHA
  '';
  password = REDACTED;
  registerHostname = "simonalling.se";
  registerName = "Alling";
};

networking.firewall = {
  enable = true;
  allowedUDPPorts = [
    137 138 # Samba
    1194 # OpenVPN
  ];
  allowedTCPPorts = [
    SSH_PORT # SSH
    80 443 # HTTP(S)
    MITMPROXY_PORT MITMPROXY_PORT_TRANSPARENT # mitmproxy
    139 445 # Samba
    64738 # Mumble
  ];
  # OpenVPN + mitmproxy:
  # The transparent mitmproxy must be running on port MITMPROXY_PORT_TRANSPARENT.
  # Routing rules are for devices that do not support dhcp-option PROXY_HTTP(S), most notably Android OpenVPN Connect.
  # For example, with 10.8.0.0/7, devices where a proxy cannot be set on the device itself should be given an address between 10.8.0.2 and 10.8.0.127.
  extraCommands = ''
    iptables -t nat -A PREROUTING -s 10.8.0.0/7 -p tcp --dport 80 -j REDIRECT --to-port ${toString MITMPROXY_PORT_TRANSPARENT}
    iptables -t nat -A PREROUTING -s 10.8.0.0/7 -p tcp --dport 443 -j REDIRECT --to-port ${toString MITMPROXY_PORT_TRANSPARENT}
    iptables -t nat -A POSTROUTING -s 10.8.0.0/8 -o enp0s31f6 -j MASQUERADE
  '';
  trustedInterfaces = [ "tun0" ]; # OpenVPN
};

services.samba = {
  enable = true;
  nsswins = true;
  /*
  $ smbpasswd -a alling
  */
  extraConfig = "
    [alling]
      path = /ztorage/alling
      read only = no
      writable = yes
      public = no
      valid users = alling
      browsable = yes
    [scan]
      path = /home/alling/scan
      read only = no
      writable = yes
      public = yes
      browsable = yes
    [frame]
      path = /home/alling/frame
      read only = no
      writable = yes
      public = yes
      browsable = yes
  ";
};

/*
OpenVPN

https://github.com/OpenVPN/easy-rsa/blob/master/README.quickstart.md

$ easyrsa init-pki
$ easyrsa build-ca
$ easyrsa gen-dh
$ easyrsa build-server-full server nopass
$ easyrsa build-client-full ipad nopass (to be copied to client or pasted into .ovpn file)
*/
services.openvpn = {
  servers = {
    server = {
      autoStart = true;
      config = ''
        proto udp
        dev tun0
        ca ${PKI_PATH}/ca.crt
        cert ${PKI_PATH}/issued/server.crt
        key ${PKI_PATH}/private/server.key
        dh ${PKI_PATH}/dh.pem
        server 10.8.0.0 255.255.255.0 nopool
        port 1194
        client-config-dir ${VPN_PATH}/clients
        ifconfig-pool 10.8.0.128 10.8.0.250
        push "route 192.168.1.100 255.255.255.255 vpn_gateway"
        push "dhcp-option DNS 1.1.1.1"
        push "dhcp-option PROXY_HTTP 192.168.1.100 ${toString MITMPROXY_PORT}"
        push "dhcp-option PROXY_HTTPS 192.168.1.100 ${toString MITMPROXY_PORT}"
        keepalive 1800 3600 ; to conserve battery on mobile devices
      '';
    };
  };
};

# The NixOS release to be compatible with for stateful data such as databases.
system.stateVersion = "20.03";

}
