{
  description = "Application packaged using poetry2nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryApplication defaultPoetryOverrides;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          myapp = mkPoetryApplication { 
            projectDir = ./.;
            preferWheels = true;
            overrides = defaultPoetryOverrides.extend
              (self: super: {
                dvc-http = super.dvc-http.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools super.setuptools-scm pkgs.libgit2 super.pdm-pep517 ];
                    propagatedBuildInputs = builtins.filter (i: i.pname != "dvc") old.propagatedBuildInputs;
                  }
                );
                dvc = super.dvc.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libgit2 ];
                  }
                );
                pygit2 = super.pygit2.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libgit2 ];
                  }
                );
                hydra-core = super.hydra-core.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools pkgs.openjdk11 ];
                    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.openjdk11 ];
                  }
                );


                flufl-lock = super.flufl-lock.overridePythonAttrs
                (
                  old: {
                    buildInputs = (old.buildInputs or [ ]) ++ [ super.pdm-pep517 ];
                  }
                );

              });
          };
          default = self.packages.${system}.myapp;
        };

        devShells.default = pkgs.mkShell {
          packages = [ poetry2nix.packages.${system}.poetry ];
        };
      });
}
