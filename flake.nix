{
  description = "justbuchanan.com";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          inherit (pkgs) lib;

          site = pkgs.stdenvNoCC.mkDerivation {
            name = "justbuchanan.com-site";
            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.unions [
                ./hugo.toml
                ./assets
                ./layouts
                ./static
              ];
            };
            nativeBuildInputs = [ pkgs.hugo ];
            buildPhase = "hugo --minify --noBuildLock --cacheDir $TMPDIR/hugo --destination $out";
            dontInstall = true;
          };
        in
        {
          default = site;
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          # Tiny runtime image: one static binary + the built site. It writes
          # nothing, so it runs fine as an unprivileged user on a read-only
          # filesystem. The static binary isn't in the public binary cache, so
          # the first build compiles it, which takes a few minutes.
          image = pkgs.dockerTools.buildLayeredImage {
            name = "justbuchanan.com";
            tag = "latest";
            contents = [ pkgs.dockerTools.fakeNss ];
            config = {
              Entrypoint = [ "${pkgs.pkgsStatic.static-web-server}/bin/static-web-server" ];
              Env = [
                "SERVER_PORT=3000"
                "SERVER_ROOT=${site}"
                "SERVER_CACHE_CONTROL_HEADERS=false"
              ];
              ExposedPorts."3000/tcp" = { };
              User = "nobody";
            };
          };
        }
      );

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [ pkgs.hugo ];
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
