# Edit this configuration file to define what should be installed on 
# your system.  Help is available in the configuration.nix(5) man page 
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ imports =
  [ 
    ./hardware-configuration.nix # Include the results of the hardware scan.
    #./steam-deck.nix  # Uncomment after installing Git
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true; 
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nix-steam-deck"; # Define your hostname.
    # networking.wireless.enable = true; # Enables wireless support via 
    # wpa_supplicant.

    # Configure network proxy if necessary networking.proxy.default = 
    # "http://user:password@proxy:port/"; networking.proxy.noProxy = 
    # "127.0.0.1,localhost,internal.domain";

    firewall.allowedUDPPorts = [ 51820 ];  # Wireguard

    # Enable networking
    networkmanager.enable = true;

    wg-quick.interfaces = {
      # Launch using: `sudo systemctl restart wg-quick-wg0.service`
      wg0 = {
        address = [ "10.0.1.10/32" ];
        autostart = false;
        dns = [ "192.168.0.202" "1.1.1.1" ];
        #listenPort = 51820;
        privateKeyFile = "/etc/wireguard/private.key";
        peers = [
          {
            publicKey = "ky2MMTdJmLKAT/QwgUNpRCmXJb1Mn4Qs/51rqFq6/jo=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            # Or only particular subnets
            #allowedIPs = [ "10.0.1.0/24", "10.0.0.0/24", "192.168.0.0/24" ];
            endpoint = "immortalkeep.com:51820";
            persistentKeepalive = 25;
          }
        ];
        #postUp = "ping -c1 10.0.1.1";
      };
    };
  };

  services.tailscale.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = { LC_ADDRESS = "en_US.UTF-8"; 
    LC_IDENTIFICATION = "en_US.UTF-8"; LC_MEASUREMENT = "en_US.UTF-8"; 
    LC_MONETARY = "en_US.UTF-8"; LC_NAME = "en_US.UTF-8"; LC_NUMERIC = 
    "en_US.UTF-8"; LC_PAPER = "en_US.UTF-8"; LC_TELEPHONE = 
    "en_US.UTF-8"; LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true; 
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = { layout = "us"; variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false; security.rtkit.enable = true; 
  services.pipewire = {
    enable = true; alsa.enable = true; alsa.support32Bit = true; 
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this jack.enable = 
    #true;

    # use the example session manager (no others are packaged yet so 
    # this is enabled by default, no need to redefine it in your config 
    # for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager). 
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.willy = {
    isNormalUser = true;
    description = "Willy"; 
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "willy" ];
  };

  # Enable flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run: $ nix 
  # search wget
  environment.systemPackages = with pkgs; [
    git
    tmux
    vim
    wget

    # Gnome debug
    #gdb
    #glib
    #gnome.gnome-session
    #gnome.mutter
    #gnome.gnome-shell
  ];
  #environment.enableDebugInfo = true;

  environment.variables.EDITOR = "vim";

  # This value determines the NixOS release from which the default 
  # settings for stateful data, like file locations and database 
  # versions on your system were taken. It‘s perfectly fine and 
  # recommended to leave this value at the release version of the first 
  # install of this system. Before changing this value read the 
  # documentation for this option (e.g. man configuration.nix or on 
  # https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
