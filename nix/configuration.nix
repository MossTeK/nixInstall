# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tek =
    {
      isNormalUser = true;
      description = "tek";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [ vim ];
    };

  environment.systemPackages = with pkgs; [
    home-manager
    vim
    wget
    neofetch
    git
    lf
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.variables = {};

  # Setup nix trusted users
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable & configure the OpenSSH daemon.
  services.openssh = {
  enable = true;
  # require public key authentication for better security
  settings.PasswordAuthentication = true;
  settings.KbdInteractiveAuthentication = true;
  #settings.PermitRootLogin = "yes";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "23.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
