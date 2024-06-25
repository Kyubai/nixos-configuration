{ ... }:
let config = substituteAll { src = ./init.lua };
in
"luafile ${config};"
