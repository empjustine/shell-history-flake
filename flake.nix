{
  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
  outputs = {
    self,
    nixpkgs-stable,
  }: {
    packages.x86_64-linux.atuin = nixpkgs-stable.legacyPackages.x86_64-linux.atuin;
    packages.x86_64-linux.bash-preexec = nixpkgs-stable.legacyPackages.x86_64-linux.bash-preexec;
    packages.x86_64-linux.mcfly = nixpkgs-stable.legacyPackages.x86_64-linux.mcfly;

    packages.x86_64-linux.atuin-bash = nixpkgs-stable.legacyPackages.x86_64-linux.buildEnv {
      name = "atuin-bash";
      paths = with nixpkgs-stable.legacyPackages.x86_64-linux; [
        atuin
        bash-preexec
      ];
      pathsToLink = ["/share/man" "/share/doc" "/share/info" "/bin" "/etc" "/share/bash"];
      extraOutputsToInstall = ["man" "doc" "info"];
      postBuild = ''
        (
          printf '. "${nixpkgs-stable.legacyPackages.x86_64-linux.bash-preexec}/share/bash/bash-preexec.sh"\n\n'

          "${nixpkgs-stable.legacyPackages.x86_64-linux.atuin}/bin/atuin" init bash | sed \
            -e 's|(atuin |("${nixpkgs-stable.legacyPackages.x86_64-linux.atuin}/bin/atuin" |g' \
            -e 's| atuin | "${nixpkgs-stable.legacyPackages.x86_64-linux.atuin}/bin/atuin" |g' \
            -e 's| bind | #### bind |g' \
            -e 's|^bind |#### bind |g'
        ) >atuin-bash.sh

        chmod +x atuin-bash.sh
        mkdir -p $out/share/bash/ $out/etc/profile.d/
        cp atuin-bash.sh $out/share/bash/atuin-bash.sh
        ln -s "${nixpkgs-stable.legacyPackages.x86_64-linux.bash-preexec}/share/bash/bash-preexec.sh" $out/etc/profile.d/10-bash-preexec.sh
        ln -s $out/share/bash/atuin-bash.sh $out/etc/profile.d/20-atuin-bash.sh

        # info
        if [ -x $out/bin/install-info -a -w $out/share/info ]; then
          shopt -s nullglob
          for i in $out/share/info/*.info $out/share/info/*.info.gz; do
              $out/bin/install-info $i $out/share/info/dir
          done
        fi
      '';
    };
  };
}
