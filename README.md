# zsi — interpreter Z#
Stan: **launcher** wykonujący programy przez stage0 (`zsc0 run`); własny VM/JIT w Z# jest do napisania.
Działa: shebang `#!/usr/bin/env zsi`, przekazywanie argumentów i stdin/stdout, `--tokens` (lekser Z#).
Użycie: `git submodule update --init && zsc0 run src/main.zs plik.zs`. Zmienna `ZSC0` wskazuje stage0.
