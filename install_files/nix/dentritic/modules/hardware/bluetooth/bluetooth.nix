{...}: {
  # Define flake part nixosModule "networking"
  flake.nixosModules.bluetooth = {...}: {
        hardware.bluetooth.enable = true;
    }
}

