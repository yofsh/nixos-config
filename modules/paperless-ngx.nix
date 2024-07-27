{ config, lib, ... }:
let
  serviceName = "paperless-ngx";
  redisBroker = "${serviceName}-broker";
  webServer = "${serviceName}-webserver";
  gotenberg = "${serviceName}-gotenberg";
  tika = "${serviceName}-tika";
  port = "8000";
  domain = "paperless.example.org";
  url = "https://${domain}";

in {


systemd.tmpfiles.rules = [
	"d /var/lib/${serviceName}/data 0750 share share - -"
	"d /var/lib/${serviceName}/media 0750 share share - -"
	"d /var/lib/${serviceName}/export 0750 share share - -"
	"d /var/lib/${serviceName}/consume 0750 share share - -"
	"d /var/lib/${serviceName}/redis 0750 share share - -"
];

  virtualisation.oci-containers = {
    containers = {
      "${webServer}" = {
        image = "ghcr.io/paperless-ngx/paperless-ngx:1.12.2";
        volumes = [
          "/var/lib/${serviceName}/data:/usr/src/paperless/data"
          "/var/lib/${serviceName}/media:/usr/src/paperless/media"
          "/var/lib/${serviceName}/export:/usr/src/paperless/export"
          "/var/lib/${serviceName}/consume:/usr/src/paperless/consume"
          # "/mnt/share/paperless-consume:/usr/src/paperless/consume"
        ];
        environmentFiles = [
          # The environment file only contains PAPERLESS_ADMIN_PASSWORD
          # config.sops.secrets."paperless-ngx.env".path
        ];
        environment = {
          PAPERLESS_REDIS = "redis://${redisBroker}:6379";
          PAPERLESS_TIKA_ENABLED = "1";
          PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://${gotenberg}:3000";
          PAPERLESS_TIKA_ENDPOINT = "http://${tika}:9998";
          # PAPERLESS_OCR_LANGUAGES = "fin";
          PAPERLESS_URL = url;

          # PAPERLESS_TIME_ZONE = "Europe/Helsinki";
          # PAPERLESS_OCR_LANGUAGE = "fin";
          PAPERLESS_FILENAME_FORMAT = "{document_type}/{created_year}/{title}";
          PAPERLESS_CONSUMER_POLLING = "60";
          PAPERLESS_CONSUMER_RECURSIVE = "true";
	  PAPERLESS_ADMIN_PASSWORD = "admin";
        };
        extraOptions = [
          "--network=${webServer}"
          "--health-cmd=curl -fs -S --max-time 2 'http://localhost:${port}'"
          "--health-interval=30s"
          "--health-retries=5"
          "--health-timeout=10s"
        ];
        ports = [ "127.0.0.1:8000:8000" ];
      };
      "${redisBroker}" = {
        image = "docker.io/library/redis:7";
        volumes = [ "/var/lib/${serviceName}/redis:/data" ];
        extraOptions = [ "--network=${webServer}" ];
      };
      "${gotenberg}" = {
        image = "docker.io/gotenberg/gotenberg:7.4";
        extraOptions = [ "--network=${webServer}" ];
        entrypoint = "gotenberg";
        cmd = [ "--chromium-disable-routes=true" ];
      };
      "${tika}" = {
        image = "ghcr.io/paperless-ngx/tika:2.5.0-full";
        extraOptions = [ "--network=${webServer}" ];
      };
    };
  };
}

