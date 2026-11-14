{ inputs, ... }: {
  flake.modules.homeManager.zapfast = {
    imports = [ inputs.zapfast.homeManagerModules.default ];
    programs.zapfast.enable = true;
  };
}
