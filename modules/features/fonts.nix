{
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];

      fonts.fontconfig.defaultFonts = {
        sansSerif = [ "Noto Sans CJK SC" "Noto Sans CJK TC" ];
        serif     = [ "Noto Serif CJK SC" "Noto Serif CJK TC" ];
        monospace = [ "Noto Sans Mono CJK SC" ];
      };
    };
}
