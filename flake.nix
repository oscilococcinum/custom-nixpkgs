{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    freecadrt-appimage-x86_64-linux.url = "https://github.com/realthunder/FreeCAD/releases/download/20241003stable/FreeCAD-Link-Stable-Linux-x86_64-py3.11-20241003.AppImage";
    freecadrt-appimage-x86_64-linux.flake = false;
    freecad-weekly-appimage-x86_64-linux.url = "https://github.com/FreeCAD/FreeCAD-Bundle/releases/download/weekly-builds/FreeCAD_weekly-builds-40041-conda-Linux-x86_64-py311.AppImage";
    freecad-weekly-appimage-x86_64-linux.flake = false;
    zen-beta-appimage-x86_64-linux.url = "https://github.com/zen-browser/desktop/releases/download/twilight/zen-x86_64.AppImage";
    zen-beta-appimage-x86_64-linux.flake = false;
    zen-twilight-appimage-x86_64-linux.url = "https://github.com/zen-browser/desktop/releases/download/1.7.3b/zen-x86_64.AppImage";
    zen-twilight-appimage-x86_64-linux.flake = false;
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: 
      {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
          
          cfmesh-cfdof = pkgs.callPackage (import ./cfmesh-cfdof) { openfoam = openfoam.${system}; };
          cfmesh-cfdof-unstable = cfmesh-cfdof.override { version = "unstable"; };

          freecadrt-appimage = appimageTools.wrapType2 {
            pname = "freecad";
            version = "realthunder";
            src = inputs."freecadrt-appimage-${system}";
            #extraInstallCommands = ''
            #cd ..
            #install -D $PWD/freecadrt.desktop $out/share/applications/freecadrt.desktop
            #'';
          };
          freecad-weekly-appimage = appimageTools.wrapType2 {
            pname = "freecad";
            version = "weekly";
            src = inputs."freecad-weekly-appimage-${system}";
            #extraInstallCommands = ''
            #cd ..
            #install -D $PWD/freecad-weekly.desktop $out/share/applications/freecad-weekly.desktop
            #'';
          };

          hisa = pkgs.callPackage (import ./hisa) { openfoam = openfoam.${system}; };
          hisa-unstable = hisa.override { version = "unstable"; };

          openfoam = pkgs.callPackage (import ./openfoam-com) { };

          zen-beta-appimage = appimageTools.wrapType2 {
            pname = "zen";
            version = "beta";
            src = inputs."zen-beta-appimage-${system}";
            #extraInstallCommands = ''
            #cd ..
            #install -D $PWD/zen-beta.desktop $out/share/applications/zen-beta.desktop
            #'';
          };
          zen-twilight-appimage = appimageTools.wrapType2 {
            pname = "zen";
            version = "twilight";
            src = inputs."zen-twilight-appimage-${system}";
            #extraInstallCommands = ''
            #cd ..
            #install -D $PWD/zen-twilight.desktop $out/share/applications/zen-twilight.desktop
            #'';
          };

          OpenHantek6022 = pkgs.callPackage (import ./openhantek6022) { };
        };
      }
    )[ "x86_64-linux" "aarch64-linux" ]);
  };
}
