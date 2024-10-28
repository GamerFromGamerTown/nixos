{ config, pkgs, ... }:

{
  # Create the directory declaratively
  environment.etc."nixos/scripts".source = pkgs.runCommand "make-script-dir" { } ''
    mkdir -p $out/nixos/scripts
  '';

  # Create the script declaratively
  environment.etc."nixos/scripts/ne.sh".text = ''
    #!/run/current-system/sw/bin/bash
        if ! command -v fzf &> /dev/null; then
          echo "fzf could not be found, please install it first."
          exit 1
        fi

        SUBDIR=$(find /etc/nixos/modules -type f | fzf --prompt="Which file? ")

        if [ -z "$SUBDIR" ]; then
          echo "No file selected."
          exit 1
        fi

        # Use nano to edit the selected file
        doas nano "$SUBDIR"
  '';

  # Ensure the script is executable
  environment.etc."nixos/scripts/ne.sh".mode = "0755";
}
