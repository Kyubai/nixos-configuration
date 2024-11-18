{lib, ...}:
# with lib;
let
  mkLuaConfig = file: (builtins.readFile file);

  mkLuaConfigs = files:
    lib.concatMapStringsSep "\n"
    (
      file:
        mkLuaConfig file
    )
    files;
in
  mkLuaConfigs [
    ./cmp.lua
    ./fugitive.lua
    ./harpoon.lua
    ./init.lua
    ./lsp.lua
    ./nvim-surround.lua
    ./oil.lua
    ./remap.lua
    ./telescope.lua
    ./undotree.lua
  ]
