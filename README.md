# LicenseLatte Multi-language Demo

Shows the activate → check pattern across five languages using the LicenseLatte SDKs.

| Language | SDK                                                  | Integration                 |
| -------- | ---------------------------------------------------- | --------------------------- |
| C        | [latte-c](https://github.com/licenselatte/latte-c)   | Direct C API                |
| C++      | [latte-c](https://github.com/licenselatte/latte-c)   | `extern "C"` + RAII wrapper |
| Rust     | [latte-c](https://github.com/licenselatte/latte-c)   | `bindgen` FFI               |
| D        | [latte-c](https://github.com/licenselatte/latte-c)   | `extern(C)` bindings        |
| Go       | [latte-go](https://github.com/licenselatte/latte-go) | Native Go SDK               |

## Test key

The following key has unlimited activations on the demo project and works in every example:

```
G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Prerequisites

**All languages (macOS with Homebrew):**

```sh
brew install cmake libsodium curl
```

**Per language:**

| Language | Extra requirement                         |
| -------- | ----------------------------------------- |
| Rust     | `cargo` (via [rustup](https://rustup.rs)) |
| D        | `ldc2` or `dmd`                           |
| Go       | Go ≥ 1.21                                 |

`latte-c` is cloned automatically from GitHub on the first build no manual setup needed.

## Build

```sh
# All languages
make

# Individual
make c
make cpp
make rust
make d
make go
```

Binaries land in `bin/`:

```
bin/c
bin/cpp
bin/rust
bin/d
bin/go
```

## Run

```sh
./bin/go  # or any other binary
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

Each demo prompts for a key, activates it, prints the license details, then performs an offline `check` to show the cached-token path.

## Clean

```sh
make clean  # removes bin/ and the latte-c build artifacts
make clean-all  # also removes the vendor/latte-c checkout
```

## Structure

```
bin/    built executables (created by make)
c/      C demo
cpp/    C++ demo
rust/     Rust demo (bindgen FFI)
d/      D demo
go/     Go demo (latte-go native SDK)
vendor/latte-c/ cloned on first build
```
