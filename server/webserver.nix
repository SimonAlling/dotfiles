{ config, pkgs, stdenv, ... }:

{

security.acme.certs = {
  "simonalling.se" = {
    domain = "*.simonalling.se";
    email = "alling.simon@gmail.com";
  };
};

security.dhparams = {
  enable = true;
  path = "/var/lib/dhparams";
  params = {
    nginx = 2048;
  };
};

services.nginx = {
  enable = true;
  recommendedOptimisation = true;
  recommendedTlsSettings = true;
  recommendedGzipSettings = true;
  recommendedProxySettings = true;
  sslDhparam = "/var/lib/dhparams/nginx.pem";
  virtualHosts = {
    "simonalling.se" = {
      forceSSL = true;
      enableACME = true;
      serverAliases = [ "simonalling.se" "www.simonalling.se" ];
      locations = {
        "/" = {
          root = "/var/www";
        };
        "/files" = {
          root = "/var/www";
          extraConfig = ''
            charset utf-8;
            autoindex on;
          '';
        };
        "~ /\\." = {
          extraConfig = ''
            deny all; return 404;
          '';
        };
      };
    };
    "www.simonalling.se" = {
      forceSSL = true;
      enableACME = true;
    };
    "cloud.simonalling.se" = {
      forceSSL = true;
      enableACME = true;
    };
  };
};

}
