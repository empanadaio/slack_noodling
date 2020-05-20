with (import <nixpkgs> {});
let

  # define packagesto install with special handling for OSX
  basePackages = [
    gnumake
    gcc
    readline
    openssl
    zlib
    libxml2
    curl
    libiconv
    elixir_1_9
    glibcLocales
    nodejs-12_x
    yarn
    postgresql
    inotify-tools
  ];

  inputs = if system == "x86_64-darwin" then
              basePackages ++ [darwin.apple_sdk.frameworks.CoreServices]
           else
              basePackages;


   localPath = ./. + "/local.nix";

   final = if builtins.pathExists localPath then
            inputs ++ (import localPath)
           else
             inputs;

  # define shell startup command with special handling for OSX
  baseHooks = ''
    export PS1='\n\[\033[1;32m\][nix-shell:\w]($(git rev-parse --abbrev-ref HEAD))\$\[\033[0m\] '

    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
  '';

  hooks = baseHooks + ''
              '';

in
  stdenv.mkDerivation {
    name = "conduit";
    buildInputs = final;
    shellHook = hooks;
  }
