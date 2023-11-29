{
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
  outputs = {
    self,
    nixpkgs-stable,
  }: {
    packages.x86_64-linux.atuin = nixpkgs-stable.legacyPackages.x86_64-linux.atuin;
    packages.x86_64-linux.bash-preexec = nixpkgs-stable.legacyPackages.x86_64-linux.bash-preexec;

    packages.x86_64-linux.atuin-bash = nixpkgs-stable.legacyPackages.x86_64-linux.buildEnv {
      name = "atuin-bash";
      paths = with nixpkgs-stable.legacyPackages.x86_64-linux; [
        atuin
        bash-preexec
      ];
      pathsToLink = ["/share/man" "/share/doc" "/bin" "/etc" "/share/bash"];
      extraOutputsToInstall = ["man" "doc"];
      postBuild = ''
        mkdir -p $out/share/bash/ $out/etc/profile.d/

        "${nixpkgs-stable.legacyPackages.x86_64-linux.atuin}/bin/atuin" init bash | sed \
          -e 's|(atuin |("${nixpkgs-stable.legacyPackages.x86_64-linux.atuin}/bin/atuin" |g' \
          -e 's| atuin | "${nixpkgs-stable.legacyPackages.x86_64-linux.atuin}/bin/atuin" |g' \
          -e 's| bind | #### bind |g' \
          -e 's|^bind |#### bind |g' >atuin-bash.sh

        cp atuin-bash.sh $out/share/bash/atuin-bash.sh
        ln -s "${nixpkgs-stable.legacyPackages.x86_64-linux.bash-preexec}/share/bash/bash-preexec.sh" $out/etc/profile.d/10-bash-preexec.sh
        ln -s $out/share/bash/atuin-bash.sh $out/etc/profile.d/20-atuin-bash.sh
      '';
    };
    packages.x86_64-linux.atuin-bash-ctrl-r = nixpkgs-stable.legacyPackages.x86_64-linux.buildEnv {
      name = "atuin-bash-ctrl-r";
      paths = [ ./atuin-bash-ctrl-r ];
    };
    packages.x86_64-linux.atuin-bash-up-arrow = nixpkgs-stable.legacyPackages.x86_64-linux.buildEnv {
      name = "atuin-bash-up-arrow";
      paths = [ ./atuin-bash-up-arrow ];
    };
  };
}
