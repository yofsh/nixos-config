{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/base.nix
    ./../../modules/desktop.nix
    ./../../modules/lsp.nix
  ];
  networking.hostName = "athena";

  environment.systemPackages = with pkgs; [ ];

  services.udisks2.enable = true;
  programs.ssh.startAgent = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.polkit = { enable = true; };

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.interception-tools.enable = true;

  services.interception-tools.udevmonConfig = ''
    - JOB: "intercept -g $DEVNODE | uinput -d $DEVNODE"
    DEVICE:
      EVENTS:
        EV_KEY: [KEY_LAUNCH2]
  '';

  services.asusd.enable = true;
  programs.light.enable = true;

  # boot.kernelParams = [ "amdgpu" "amdgpu.dcdebugmask=0x10" ];

  # boot.extraModprobeConfig = ''
  #   blacklist nouveau
  #   options nouveau modeset=0
  # '';

  # services.udev.extraRules = ''
  #   # Remove NVIDIA USB xHCI Host Controller devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
  #   # Remove NVIDIA USB Type-C UCSI devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
  #   # Remove NVIDIA Audio devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
  #   # Remove NVIDIA VGA/3D controller devices
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  #
  #   KERNEL=="ttyACM0", TAG+="uaccess", SYMLINK+="ttyACM0_fobos", MODE="0660", OWNER="fobos"
  # '';
  #
  # boot.blacklistedKernelModules =
  #   [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];


  # hardware.sensor.iio.enable = true;
  # hardware.nvidia.prime = {
  #   offload = {
  #     enable = true;
  #     enableOffloadCmd = true;
  #   };
  #   nvidiaBusId = "PCI:69:0:0";
  #   amdgpuBusId = "PCI:01:0:0"; 
  # };
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   # powerManagement.enable = true;
  #   powerManagement.finegrained = true;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.beta;
  # };

  services.power-profiles-daemon.enable = true;
}

