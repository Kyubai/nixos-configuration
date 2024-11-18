{ lib
, ...
}:

with lib;
let
  mkVimConfig = file: 
      (builtins.readFile file);

  mkVimConfigs = files:
    lib.concatMapStringsSep "\n"
      (file:
        mkVimConfig file
      )
      files;

in
  mkVimConfigs [
    ./init.vim
  ]
