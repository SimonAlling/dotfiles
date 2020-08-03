{ config, pkgs, stdenv, ... }:

# https://jacobneplokh.com/how-to-setup-nextcloud-on-nixos

let
  NEXTCLOUD_DATABASE = "nextcloud";
  NEXTCLOUD_USER = "nextcloud";
in

{

services.nextcloud = {
  enable = true;
  hostName = "cloud.simonalling.se";
  https = true;
  nginx.enable = true;
  autoUpdateApps.enable = true;
  autoUpdateApps.startAt = "05:00:00";
  config = {
    dbtype = "pgsql";
    dbuser = NEXTCLOUD_USER;
    dbhost = "/run/postgresql";
    dbname = NEXTCLOUD_DATABASE;
    dbpassFile = "/var/nextcloud-dbpass";
    overwriteProtocol = "https";
    adminuser = "admin";
    adminpassFile = "/var/nextcloud-adminpass";
  };
};

services.postgresql = {
  /*
  https://nixos.wiki/wiki/PostgreSQL
  List databases:
  $ sudo -u postgres psql --list
  */
  enable = true;
  package = pkgs.postgresql_11;
  ensureDatabases = [ NEXTCLOUD_DATABASE ];
  ensureUsers = [
    {
      name = NEXTCLOUD_USER;
      ensurePermissions."DATABASE ${NEXTCLOUD_DATABASE}" = "ALL PRIVILEGES";
    }
  ];
};

systemd.services."nextcloud-setup" = {
  requires = [ "postgresql.service" ];
  after = [ "postgresql.service" ];
};

}
