{
  stdenv,
  autoPatchelfHook,
  libsForQt5,
  pkgs
}:
stdenv.mkDerivation rec {
          pname = "OpenHantek";
          version = "3.4_rc2";

          src = builtins.fetchTarball {
            url = "https://github.com/OpenHantek/OpenHantek6022/releases/download/3.4-rc3/openhantek_3.4-rc2-15-gffd1691_x86_64.tar.gz";
            sha256 = "sha256:0dgkzpy6x7vr2cjg4m07kkh7wk27mxxfk57x91l397avsf7ypp6j";
          };

          nativeBuildInputs = [
            autoPatchelfHook
            libsForQt5.qt5.wrapQtAppsHook
          ];

          buildInputs = with pkgs; [
            fftw
            libgcc
            libusb1
            libsForQt5.qt5.qtwayland
          ];

          installPhase = ''
            mkdir -p $out/bin
            cp -r $src/* $out/
          '';
        }
