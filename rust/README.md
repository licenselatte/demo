# Rust demo

Uses [`latte-rs`](https://github.com/licenselatte/latte-rs), the native Rust SDK
from [crates.io](https://crates.io/crates/latte-rs) — an idiomatic, `unsafe`-free
reimplementation of license activation and verification, not a binding on top
of `latte-c`. No C toolchain or FFI is involved.

## Prerequisites

- `cargo` ([rustup.rs](https://rustup.rs))

## Build

```sh
make rust   # from the repo root
```

Output: `bin/rust`

Or build with cargo directly:

```sh
cargo build --manifest-path rust/Cargo.toml --release
```

## Run

```sh
./bin/rust
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Notes

- `Sdk::new(Config::with_app_id(...))` creates one SDK instance per process;
  `sdk.activate(key)` is `async` (the `http`/`cache` crate features, both on
  by default) and driven here by a `#[tokio::main]` runtime; `sdk.check()` is
  synchronous
- The SDK derives this machine's ID from the platform's own machine ID, the
  same way `latte-c`/`latte-go` do; use `Config::with_machine_id(...)` to
  supply your own raw ID instead
- There's no background renewal thread: call `sdk.renew(...)` yourself on
  whatever schedule fits your application (not shown in this demo)
