# Usage

    nix --refresh --extra-experimental-features 'nix-command flakes' profile install 'github:empjustine/shell-history-flake#atuin-bash'
    # optional ctrl-r support
    nix --refresh --extra-experimental-features 'nix-command flakes' profile install 'github:empjustine/shell-history-flake#atuin-bash-ctrl-r'
    # optional up-arrow support
    nix --refresh --extra-experimental-features 'nix-command flakes' profile install 'github:empjustine/shell-history-flake#atuin-bash-up-arrow'