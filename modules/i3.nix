{ config, pkgs, lib, ... }:

{
# Turn off the GNOME Desktop Environment from the default configuration that we imported.
	services.xserver.displayManager.gdm.enable = lib.mkForce false;
	services.xserver.desktopManager.gnome.enable = lib.mkForce false;
	services.xserver.enable = true;

	services.xserver.windowManager.i3.enable = true;

# Enable another display manager (like sddm or lightdm)
	services.xserver.displayManager.sddm.enable = true;

	environment.systemPackages = with pkgs; [
			acpi
			arandr
			autorandr
			powertop
			tlp
			i3
			i3status
			dmenu
			alacritty
	];
	services.tlp.enable = true;

	services.tlp.settings = {
		START_CHARGE_THRESH_BAT0 = 40;
		STOP_CHARGE_THRESH_BAT0 = 80;
	};
	services.logind.lidSwitch = "suspend";
	services.logind.lidSwitchDocked = "ignore";
	services.upower.enable = true;

	systemd.defaultUnit = "graphical.target";
}
