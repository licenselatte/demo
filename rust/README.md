# Rust demo

Calls `latte-c` via FFI. [`bindgen`](https://github.com/rust-lang/rust-bindgen)
generates Rust bindings from `latte.h` at build time no hand-written unsafe
declarations.

## Prerequisites

- `cargo` ([rustup.rs](https://rustup.rs))
- `cmake`, `libsodium`, `libcurl` (to build `latte-c`)
- `libclang` (required by bindgen usually provided by Xcode CLT on macOS)

## Build

```sh
make rust   # from the repo root (builds latte-c first, then cargo)
```

Output: `bin/rust`

Or build with cargo directly (latte-c must already be built):

```sh
LATTE_C_ROOT=/path/to/vendor/latte-c \
  cargo build --manifest-path rust/Cargo.toml --release
```

## Run

```sh
./bin/rust
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## How it works

| File           | Purpose                                                                |
| -------------- | ---------------------------------------------------------------------- |
| `build.rs`     | Runs bindgen, links `liblatte.a`, `libcjson.a`, `libsodium`, `libcurl` |
| `src/latte.rs` | `include!` of the bindgen-generated output from `$OUT_DIR/latte.rs`    |
| `src/main.rs`  | Uses `mod latte` all types and functions via `latte::`                 |

`bindgen` is configured with:

- `.allowlist_type("latte_.*")` structs and the status enum
- `.allowlist_function("latte_.*")` the five public functions
- `.rustified_enum("latte_status")` generates a `#[repr(u32)] enum` so
  variants are accessed as `latte::latte_status::LATTE_OK` rather than raw integers

## Notes

- `build.rs` reads `LATTE_C_ROOT` for the path to the latte-c checkout,
  falling back to `../vendor/latte-c`
- `latte_sdk` is an opaque C struct; Rust holds it as `*mut latte::latte_sdk`
- All FFI calls are in a single `unsafe` block in `main`; the demo is intentionally
  close to the C API rather than adding a safe wrapper layer
