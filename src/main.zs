#( zsi — interpreter Z# (repo: zsi)

   STAN: launcher. Docelowa architektura to własny bytecode VM + JIT napisany w Z#
   (patrz README). Dopóki VM nie istnieje, `zsi` wykonuje programy przez stage0
   (`zsc0 run`), więc semantyka jest referencyjna, a shebang `#!/usr/bin/env zsi`
   już działa. Lekser jest samohostowany (Workspace.lexer). )#

import Workspace.lexer;

func version(): string { return "zsi 0.0.1 (launcher -> stage0)"; }

func usage(): void {
    println("użycie:");
    println("  zsi <plik.zs> [argumenty...]   uruchom program");
    println("  zsi --tokens <plik.zs>         zrzut tokenów (lekser Z#)");
    println("  zsi --version | --help");
    println("zmienne: ZSC0=<ścieżka do stage0> (domyślnie `zsc0` z PATH)");
}

func stage0(): string { return System.env("ZSC0") ?? "zsc0"; }

func dumpTokens(string $file): int {
    try {
        foreach (lexer.tokenize(File.read($file)) as $t) {
            println($t["line"] . ":" . $t["col"] . "\t" . $t["kind"] . "\t" . $t["text"]);
        }
    } catch (Exception $e) {
        eprintln("zsi: " . $e->getMessage());
        return 1;
    }
    return 0;
}

func main(): int {
    $args = System.args();
    # opcje zsi kończą się na pierwszym argumencie nie zaczynającym się od `-`;
    # wszystko po nazwie skryptu należy do skryptu
    $i = 1;
    $tokens = false;
    while ($i < count($args) && starts_with($args[$i], "-")) {
        $a = $args[$i];
        if ($a === "--version") { println(version()); return 0; }
        else if ($a === "--help" || $a === "-h") { usage(); return 0; }
        else if ($a === "--tokens") { $tokens = true; }
        else { eprintln("zsi: nieznana opcja " . $a); return 2; }
        $i++;
    }
    if ($i >= count($args)) { usage(); return 2; }
    $file = $args[$i];
    if (!File.exists($file)) { eprintln("zsi: nie znaleziono pliku " . $file); return 1; }
    if ($tokens) { return dumpTokens($file); }
    $argv = ["run"];
    for ($j = $i; $j < count($args); $j++) { $argv[] = $args[$j]; }
    return Process.exec(stage0(), $argv);
}

exit(main());
