{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stylua
    nixfmt-classic
    shfmt
    yq
    lua-language-server
    yaml-language-server
    bash-language-server
    typescript-language-server
    typescript
    bash-language-server
    stylua
    nixd
    vscode-langservers-extracted
  ];

}

