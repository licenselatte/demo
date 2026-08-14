# LicenseLatte Multi-language Demo

Shows the activate → check pattern across six languages using the LicenseLatte SDKs:
`latte-c` bound directly in C, C++, and D, and the native SDKs — `latte-go`,
`latte-rs`, `latte-py` — used as-is everywhere a native SDK exists.

| Language | SDK                                                       | Integration                       |
| -------- | ---------------------------------------------------------- | ---------------------------------- |
| C        | [latte-c](https://github.com/licenselatte/latte-c)         | Direct C API                       |
| C++      | [latte-c](https://github.com/licenselatte/latte-c)         | Official header-only C++ wrapper   |
| D        | [latte-c](https://github.com/licenselatte/latte-c)         | `extern(C)` bindings               |
| Go       | [latte-go](https://github.com/licenselatte/latte-go)       | Native Go SDK                      |
| Rust     | [latte-rs](https://github.com/licenselatte/latte-rs)       | Native Rust SDK                    |
| Python   | [latte-py](https://github.com/licenselatte/latte-py)       | Native Python SDK                  |

C, C++, and D have no native SDK of their own, so they bind directly to
`latte-c`. Go, Rust, and Python each have an idiomatic native SDK, so those
demos use it instead of FFI into `latte-c`.

## Test key

The following key has unlimited activations on the demo project and works in every example:

```
G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Prerequisites

**C / C++ / D (macOS with Homebrew):**

```sh
brew install cmake libsodium curl
```

| Language | Extra requirement                         |
| -------- | ----------------------------------------- |
| D        | `ldc2` or `dmd`                           |
| Go       | Go ≥ 1.21                                 |
| Rust     | `cargo` (via [rustup](https://rustup.rs)) |
| Python   | Python ≥ 3.9                              |

`latte-c` is cloned automatically from GitHub on the first build of `c`/`cpp`/`d`
— no manual setup needed. `latte-go`, `latte-rs`, and `latte-py` are fetched as
regular package dependencies (Go modules, crates.io, PyPI).

## Build

```sh
# All languages
make

# Individual
make c
make cpp
make d
make go
make rust
make python
```

Binaries land in `bin/`:

```
bin/c
bin/cpp
bin/d
bin/go
bin/rust
```

Python isn't compiled; `make python` sets up `python/.venv` with `latte-py`
installed.

## Run

```sh
./bin/go        # or any other compiled binary
make run-python  # for the Python demo
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

Each demo prompts for a key, activates it, prints the license details, then performs an offline `check` to show the cached-token path.

## Clean

```sh
make clean      # removes bin/, python/.venv, and the latte-c build artifacts
make clean-all  # also removes the vendor/latte-c checkout
```

## Structure

```
bin/             built executables (created by make)
c/               C demo (latte-c, direct)
cpp/             C++ demo (latte-c, official C++ wrapper)
d/               D demo (latte-c, extern(C) bindings)
go/              Go demo (latte-go native SDK)
rust/            Rust demo (latte-rs native SDK)
python/          Python demo (latte-py native SDK)
vendor/latte-c/  cloned on first build of c/cpp/d
```
