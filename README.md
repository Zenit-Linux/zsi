# zsi — interpreter Z# (0.0.1)

**Stan: launcher + pakowacz nad stage0** (pełna semantyka języka). Własna VM bajtkodowa i JIT: **nie zrobione** (ścieżka niżej).

```
zsi plik.zs [arg...]          # uruchom źródło lub pakiet .zbc (shebang: #!/usr/bin/env zsi)
zsi -e 'echo 1 + 1;'          # fragment
zsi --compile plik.zs -o app  # samodzielna binarka (runtime + .zbc, bez źródeł i bez zsc0 u odbiorcy)
zsi --emit-zbc plik.zs -o x.zbc
zsi --check plik.zs | --tokens plik.zs | --version
```
Stage0: `ZSC0`, potem `zsc0` z PATH, a w trybie standalone ta sama binarka (`ZS_NO_EMBEDDED=1`) — `zsi` zbudowany przez `zsc0 bundle` działa bez zainstalowanego zsc0.

## Droga do VM/JIT
1. `lib/bytecode.zsharp`: AST → bajtkod stosowy (opkody, tablica stałych/funkcji/klas, tablica linii) + format `.zbx`.
2. `lib/vm.zsharp` → docelowo VM w C na `runtime/native/zs_rt.c` (wartości/tablice/wyjątki już są), testy różnicowe vs stage0 (`zsc/tests/native` rozszerzone o pełny język).
3. JIT: emisja LLVM IR w locie (`emit_llvm`) + ORC; wymaga klas/domknięć w runtime natywnym.
