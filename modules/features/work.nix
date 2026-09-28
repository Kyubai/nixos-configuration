{
  inputs,
  self,
  ...
}: {
  flake.homeModules.work = {
    home.file.".ssh/config.template" = {
      text = ''
        Host customer-kali01
            Hostname customer.react.intern
            DynamicForward 9050
            RemoteForward 127.0.0.2:445 127.0.0.1:445
            RemoteForward 127.0.0.2:3128 127.0.0.1:3128
            RemoteForward 127.0.0.2:53 127.0.0.1:53
            RemoteCommand sudo umount /home/mri/scripts; sudo mount -t cifs -o vers=3,ro,port=445,username=anon,password=anon //127.0.0.2/tools/scripts /home/mri/scripts; /bin/zsh
            RequestTTY yes

        Host customer-kali01-simple
            Hostname customer.react.intern
      '';
    };
  };

  flake.nixosModules.work = {...}: {
    networking.firewall.allowedTCPPorts = [53];
    services.dnsmasq = {
      enable = true;
      settings = {
        listen-address = "127.0.0.1,127.0.0.2";
        no-resolv = true; # ignore resolv.conf
        log-queries = true;
        log-facility = "/var/log/dnsmasq.log";
        server = [
          "185.222.222.222" # dns.sb
          "45.11.45.11" # dns.sb
          # "193.110.81.0" # dns0.eu
          # "2a0f:fc80::" # dns0.eu
          # "185.253.5.0" # dns0.eu
          # "2a0f:fc81::" # dns0.eu
          "/react.intern/10.103.0.1"
          "/addyet.intern/10.10.0.2" # Hacker DMZ
          "/authentication.add-yet.de/10.10.0.2" # Hacker DMZ
          "/addyet.intern/192.168.250.5" # addyet.intern
          "/intern.verriegelt.net/10.105.201.1"
        ];
      };
    };
  };
}
