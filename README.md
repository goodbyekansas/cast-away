# Cast Away 🏝️

Reproduction of USD plugin loading failure with libc++.

The issue here is that the type `ShipFactoryBase` is considered equal in the main program
and the plugin by GNU `libstdc++`. This library uses `strcmp` for type equality. LLVM's
`libc++` on the other hand uses a more sophisticated type equality check and therefore
considers `ShipFactoryBase` to be different in the plugin and main program, resulting in a
`dynamic_cast` between types to return `NULL`.

Running the example here (having [Nix](https://nixos.org/download.html) installed) should
give this output:

```
❯ make run
nix build -f ./default.nix libstd
Running with GNU libstdc++ (built with Clang):

  🐄 [libstdc++] Casting away 🏝 using C++ standard library "libstdc++ (GNU)"... 🚢
  🐄 [libstdc++] 🃏 Type for ShipFactoryBase in host and plugin are equal? ✅ yes
  🐄 [libstdc++] 🚢 Ship type: ⛵

nix build -f ./default.nix libcxx
Running with LLVM libc++ (built with Clang):

  🐉 [libc++] Casting away 🏝 using C++ standard library "libc++ (LLVM)"... 🚢
  🐉 [libc++] 🃏 Type for ShipFactoryBase in host and plugin are equal? ❌ no
  🐉 [libc++] 😭 Failed to cast factory to a ship factory when using libc++ (LLVM)!
```

To make it clear that the compiler has nothing to do with it, we use Clang together with
libstdc++ as well as libc++.
