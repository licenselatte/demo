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
  `sdk.activate(key, machine_id)` and `sdk.check(machine_id)` are `async` (the
  `http`/`cache` crate features, both on by default) and driven here by a
  `#[tokio::main]` runtime
- Unlike `latte-c`/`latte-go`, `latte-rs` does no OS-level machine fingerprinting
  of its own — the caller supplies an opaque `machine_id` string. This demo
  falls back to the `HOSTNAME`/`COMPUTERNAME` env var for simplicity; a real
  integration should use a stable per-device fingerprint
- There's no background renewal thread: call `sdk.renew(...)` yourself on
  whatever schedule fits your application (not shown in this demo)
