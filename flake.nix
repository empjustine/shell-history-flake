{
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = {
    self,
    nixpkgs-stable,
  }: let
    system = "x86_64-linux";
  in {
    packages.${system} = {
      atuin = nixpkgs-stable.legacyPackages.${system}.atuin;
      bash-preexec = nixpkgs-stable.legacyPackages.${system}.bash-preexec;

      atuin-bash = nixpkgs-stable.legacyPackages.${system}.buildEnv {
        name = "atuin-bash";
        paths = [];
        postBuild = ''
          mkdir -p $out/share/bash/ $out/etc/profile.d/

          "${nixpkgs-stable.legacyPackages.${system}.atuin}/bin/atuin" init bash >$out/share/bash/atuin-bash.sh

          ln -s "${nixpkgs-stable.legacyPackages.${system}.bash-preexec}/share/bash/bash-preexec.sh" $out/etc/profile.d/10-bash-preexec.sh
          ln -s $out/share/bash/atuin-bash.sh $out/etc/profile.d/20-atuin-bash.sh
        '';
      };

      default = self.packages.${system}.atuin-bash;
    };
  };
}
