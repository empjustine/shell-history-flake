{
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = {
    self,
    nixpkgs-stable,
  }: {
    packages.x86_64-linux = let
      selfPkgs = self.packages.x86_64-linux;
      pkgs = nixpkgs-stable.legacyPackages.x86_64-linux;
    in {
      atuin = pkgs.atuin;
      bash-preexec = pkgs.bash-preexec;

      atuin-bash = pkgs.buildEnv {
        name = "atuin-bash";
        paths = [];
        postBuild = ''
          mkdir -p $out/share/bash/ $out/etc/profile.d/

          "${pkgs.atuin}/bin/atuin" init bash | sed \
            -e 's|(atuin |("${pkgs.atuin}/bin/atuin" |g' \
            -e 's| atuin | "${pkgs.atuin}/bin/atuin" |g' \
            -e 's| bind | #### bind |g' \
            -e 's|^bind |#### bind |g' >atuin-bash.sh

          cp atuin-bash.sh $out/share/bash/atuin-bash.sh
          ln -s "${pkgs.bash-preexec}/share/bash/bash-preexec.sh" $out/etc/profile.d/10-bash-preexec.sh
          ln -s $out/share/bash/atuin-bash.sh $out/etc/profile.d/20-atuin-bash.sh
        '';
      };
      atuin-bash-ctrl-r = pkgs.buildEnv {
        name = "atuin-bash-ctrl-r";
        paths = [
          selfPkgs.atuin-bash
          ./atuin-bash-ctrl-r
        ];
      };
      atuin-bash-up-arrow = pkgs.buildEnv {
        name = "atuin-bash-up-arrow";
        paths = [
          selfPkgs.atuin-bash
          ./atuin-bash-up-arrow
        ];
      };

      default = selfPkgs.atuin-bash;
    };
  };
}
