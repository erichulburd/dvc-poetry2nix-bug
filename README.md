# Background

This repo demonstrates an infinite recursion when trying to use [poetry2nix](https://github.com/nix-community/poetry2nix) with a Poetry project that depends on [dvc](https://github.com/iterative/dvc).

## Reproduce Error

After pulling the repository:

```sh
% nix build -I NETRC=$HOME/.netrc --show-trace
error: infinite recursion encountered

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/pkgs/stdenv/generic/make-derivation.nix:336:7:

          335|       depsHostHostPropagated      = lib.elemAt (lib.elemAt propagatedDependencies 1) 0;
          336|       propagatedBuildInputs       = lib.elemAt (lib.elemAt propagatedDependencies 1) 1;
             |       ^
          337|       depsTargetTargetPropagated  = lib.elemAt (lib.elemAt propagatedDependencies 2) 0;

       … while evaluating the attribute 'propagatedBuildInputs' of the derivation 'python3.10-dvc-http-0.0.2'

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/pkgs/stdenv/generic/make-derivation.nix:286:7:

          285|     // (lib.optionalAttrs (attrs ? name || (attrs ? pname && attrs ? version)) {
          286|       name =
             |       ^
          287|         let

       … while evaluating the attribute 'out.outPath'

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/lib/customisation.nix:215:13:

          214|             drvPath = assert condition; drv.${outputName}.drvPath;
          215|             outPath = assert condition; drv.${outputName}.outPath;
             |             ^
          216|           };

       … while evaluating the attribute 'propagatedBuildInputs' of the derivation 'python3.10-dvc-2.18.1'

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/pkgs/stdenv/generic/make-derivation.nix:286:7:

          285|     // (lib.optionalAttrs (attrs ? name || (attrs ? pname && attrs ? version)) {
          286|       name =
             |       ^
          287|         let

       … while evaluating the attribute 'out.outPath'

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/lib/customisation.nix:215:13:

          214|             drvPath = assert condition; drv.${outputName}.drvPath;
          215|             outPath = assert condition; drv.${outputName}.outPath;
             |             ^
          216|           };

       … while evaluating the attribute 'out.outPath'

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/lib/customisation.nix:215:13:

          214|             drvPath = assert condition; drv.${outputName}.drvPath;
          215|             outPath = assert condition; drv.${outputName}.outPath;
             |             ^
          216|           };

       … while evaluating the attribute 'propagatedBuildInputs' of the derivation 'python3.10-dvc-poetry2nix-bug-0.1.0'

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/pkgs/stdenv/generic/make-derivation.nix:286:7:

          285|     // (lib.optionalAttrs (attrs ? name || (attrs ? pname && attrs ? version)) {
          286|       name =
             |       ^
          287|         let

       … while evaluating the attribute 'drvPath'

       at /nix/store/gm8c760jh9w22vybdj99g1ciz2npmj7c-source/lib/customisation.nix:221:7:

          220|     in commonAttrs // {
          221|       drvPath = assert condition; drv.drvPath;
             |       ^
          222|       outPath = assert condition; drv.outPath;
```

