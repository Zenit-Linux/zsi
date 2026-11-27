# zsi — uruchamianie Z# (bez stage0)

`zsi prog.zs [argumenty]` kompiluje program natywnie przez `zsc` (LLVM >= 21), zapisuje binarkę w cache i ją uruchamia.
Kolejne uruchomienia bez zmian źródeł trwają milisekundy. Działa także jako `#!/usr/bin/env zsi`.

```
zsi prog.zs a b          # args()[0] = prog.zs (jak w interpreterze)
zsi -e 'echo 6 * 7;'
zsi --check prog.zs      # składnia + sema + zgodność z backendem natywnym
zsi --compile prog.zs -o prog
zsi --emit-zbc prog.zs -o prog.zbc
zsi --no-cache | --clean-cache | --cache-dir | --legacy | --zsc <ścieżka>
```

Klucz cache: źródła programu i jego katalogu + wersja i stempel `zsc`. Cache: `ZSI_CACHE` lub `~/.cache/zsi`.
`zsc` znajdowany jest przez `--zsc`, `ZSC`, obok binarki `zsi`, potem `PATH`. Kody: kod programu; 1 błąd kompilacji/pliku/wykonania; 2 użycie; 3 brak zsc/LLVM.
Brak własnej VM: konstrukcje spoza podzbioru natywnego zgłaszane są jako błąd kompilacji. `--legacy` (i pliki `.zbc`) uruchamiają stage0 (`ZSC0`) — tylko zgodność wsteczna.
Testy: `tests/run.sh`.
