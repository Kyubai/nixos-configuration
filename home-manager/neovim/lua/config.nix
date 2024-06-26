{ lib
, ...
}:

# with lib;
let
  mkLuaConfig = file: 
      (builtins.readFile file);

  mkLuaConfigs = files:
    lib.concatMapStringsSep "\n"
      (file:
        mkLuaConfig file
      )
      files;

in
  mkLuaConfigs [
    ./fugitive.lua
    ./harpoon.lua
    ./init.lua
    ./lsp.lua
    ./telescope.lua
    ./undotree.lua
  ]

