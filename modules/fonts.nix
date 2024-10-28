{ config, pkgs, lib, ... }:

{
  # Font Packages
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Correct font packages
      lato
      eb-garamond
      overpass
      ubuntu_font_family # Corrected package name for the Ubuntu font family
      iosevka-bin # Use precompiled Iosevka package
      noto-fonts-emoji # Keep emoji support
      terminus_font # Console font with higher resolution options
      # Additional fonts (optional)
      fira-code
      jetbrains-mono
    ];

    # Font Directories
    fontDir = {
      enable = true;
      decompressFonts = true; # Decompress fonts to improve performance
    };

    # Fontconfig Settings
    fontconfig = {
      enable = true;

      # Local configuration settings for Fontconfig
      localConf = ''
        <match target="font">
          <edit name="embeddedbitmap" mode="assign">
            <bool>false</bool>
          </edit>
        </match>
      '';

      # Enable antialiasing and configure subpixel settings
      antialias = true;
      subpixel = {
        rgba = "rgb"; # Use RGB for most monitors
        lcdfilter = "none"; # Changed to "none" for better font sharpness
      };

      # Configure hinting for sharper fonts
      hinting = {
        enable = true;
        autohint = false; # Prefer font's own hints if available
        style = "medium"; # Changed to "hintslight" for a more natural look
      };

      # Use embedded bitmaps in fonts when available
      useEmbeddedBitmaps = true;
      allowBitmaps = false;

      # Set default fonts for various categories
      defaultFonts = {
        serif = [ "EB Garamond" ]; # Serif font remains EB Garamond
        sansSerif = [ "Lato" ]; # Set Lato as the default sans-serif font
        monospace = [ "Ubuntu Mono" ]; # Set Ubuntu Mono as the default monospace font
        emoji = [ "Noto Color Emoji" ]; # Keep Noto Emoji for emojis
      };

      # Additional Fontconfig settings
      allowType1 = false; # Disable Type1 fonts for better compatibility
      cache32Bit = true; # Enable 32-bit cache for better performance
      includeUserConf = true; # Allow user-specific configurations
    };
  };

  # Console Font Configuration (higher resolution)
  console.font = "UbuntuMono-v32n"; # Terminus font with a higher resolution (32 pixels)

  # Plasma 6 Configuration
  services.desktopManager.plasma6.enable = true;

  # Set KDE font settings through environment variables
  # Using KDE settings, this part can still affect applications that respect these variables.
  environment.variables = {
    # Configure fonts globally for KDE/Plasma
    "KDE_FONT_GENERAL" = "Lato,11,-1,5,50,0,0,0,0,0";
    "KDE_FONT_FIXED" = "Ubuntu Mono,12,-1,5,50,0,0,0,0,0";
    "KDE_FONT_SMALL" = "Lato,9,-1,5,50,0,0,0,0,0";
    "KDE_FONT_TOOLBAR" = "Lato,10,-1,5,50,0,0,0,0,0";
    "KDE_FONT_WINDOWTITLE" = "Lato,11,-1,5,50,0,0,0,0,0";
    "KDE_FONT_MONOSPACE" = "Iosevka Term,12,-1,5,50,0,0,0,0,0";
  };

  # Programs Configuration
  programs.xwayland.defaultFontPath = "/run/current-system/sw/share/fonts"; # Adjusted to a simpler path
}
