{
  description = "Vibe's Python Nix Flake";

  inputs = {
    nixpkgs.url = "github:daedric/nixpkgs?ref=nixos-unstable-with-fixed-poetry";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      poetry2nix,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        p2nix = (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; });
      in
      {
        devShell = pkgs.mkShell {
          packages = [
            (p2nix.mkPoetryEnv {
              projectDir = self;
              editablePackageSources = {
                synchronizer = self;
              };
              python = pkgs.python311;
              overrides = p2nix.overrides.withDefaults (
                final: prev: {
                  pyclean = prev.pyclean.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.setuptools ];
                  });
                  bump2version = prev.bump2version.overridePythonAttrs (old: {
                      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.setuptools ];
                  });
                  etcd3 = prev.etcd3.overridePythonAttrs (old: {
                      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.setuptools ];
                  });
                  radon = prev.radon.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.setuptools ];
                  });
                  python-commons = prev.python-commons.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.poetry-core ];
                  });
                  click = prev.click.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.flit-core ];
                  });
                  pylint-per-file-ignores = prev.pylint-per-file-ignores.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.poetry-core ];
                  });
                  api-contracts = prev.api-contracts.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.poetry-core ];
                  });
                  dnspython = prev.dnspython.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ final.hatchling ];
                  });
                  ruff = prev.ruff.override {
                    preferWheel = true;
                  };
                }
              );
            })

            pkgs.etcd_3_5
            pkgs.basedpyright
            pkgs.shfmt
            pkgs.bashInteractive
          ];
        };
      }
    );
}
