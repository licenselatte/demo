# Go demo

Uses [`latte-go`](https://github.com/licenselatte/latte-go), the native Go SDK.
No C toolchain or FFI is involved.

## Prerequisites

- Go ≥ 1.21

## Build

```sh
make go   # from the repo root
```

Output: `bin/go`

Or build directly:

```sh
cd go && go build -o ../bin/go .
```

## Run

```sh
./bin/go
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Notes

- `latte.New(&latte.Config{AppID: "..."})` creates one SDK instance per process
- `sdk.Activate(key)` returns a `*latte.License` on success, or a typed sentinel
  error (`latte.ErrInvalidKey`, `latte.ErrSeatLimit`, etc.)
- `sdk.Check()` validates the locally-stored token with no network call use
  it for periodic in-process checks after the initial activation
- Background token renewal runs automatically in a goroutine when `Activate` or
  `Check` returns a cache hit that is nearing expiry
