{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stylua
    nixfmt
    shfmt
    yq
    lua-language-server
    yaml-language-server
    bash-language-server
    typescript-language-server
    bash-language-server
    stylua
    nixd
    vscode-langservers-extracted
  ];

}

