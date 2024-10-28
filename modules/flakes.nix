{ config, pkgs, ... }:

{


  let
  eww-flake = builtins.getFlake "/home/gaymer/flakes/eww-flake";
  in
  {
  # Your configuration
  environment.systemPackages = with pkgs; [
    eww-flake.packages.${system}.eww
  ];
}



}
