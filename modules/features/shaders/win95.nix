{ pkgs, ... }: { 
  flake.modules.shaders = {
    win95 = {
      programs.ghostty.settings.custom-shaders = [ "${pkgs.writeText "my-shader" (builtins.readFile ./win95.glsl)}" ];
    };
  };
}
