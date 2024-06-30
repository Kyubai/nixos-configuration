{ ... }:
{
  home.shellAliases = {
    dcud = "docker-compose up -d";
    dcd = "docker-compose down";
    dcr = "docker-compose down && docker-compose up -d";
    dcl = "docker-compose logs";
  };
}
