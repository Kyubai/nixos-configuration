{ ... }:
{
  home.shellAliases = {
    dcud = "sudo docker compose up -d";
    dcd = "sudo docker compose down";
    dcr = "sudo docker compose down && docker compose up -d";
    dcl = "sudo docker compose logs";
  };
}
