# D demo

Calls `latte-c` via D's `extern(C)` FFI. No additional binding generator is
needed D can declare C functions and structs directly in D syntax.

## Prerequisites

- `ldc2` (preferred) or `dmd`
- `cmake`, `libsodium`, `libcurl` (to build `latte-c`)

Install on macOS: `brew install ldc libsodium curl`

## Build

```sh
make d    # from the repo root
```

Output: `bin/d`

## Run

```sh
./bin/d
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Notes

- `latte_config_new` → `latte_new` → `latte_activate` → `latte_check` → `latte_free`;
  the config is freed right after `latte_new` since `latte_new` only reads it
- `extern(C)` blocks in D declare C-ABI functions and structs with no overhead
- `scope(exit)` ensures `latte_free` and `latte_license_free` always run,
  even if an error path returns early equivalent to C++'s RAII or Go's `defer`
- The `latte_status` enum is mirrored in D with the same integer values; D's
  enum comparison works directly against the C-originated values
- The D compiler is passed `liblatte.a` and `libcjson.a` as positional arguments;
  `-L-lsodium -L-lcurl` passes flags through to the underlying linker
