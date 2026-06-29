# C++ demo

Wraps `latte-c` (C-ABI) in a minimal RAII class. The header is included via
`extern "C"` no separate C++ SDK is needed.

## Prerequisites

- `cmake`, `c++` (C++17)
- `libsodium`, `libcurl` (e.g. `brew install libsodium curl`)

## Build

```sh
make cpp    # from the repo root
```

Output: `bin/cpp`

## Run

```sh
./bin/cpp
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Notes

- `LatteSDK` wraps the opaque `latte_sdk*` handle and frees it in its destructor
- `activate` and `check` throw `std::runtime_error` on any non-`LATTE_OK` status
- Raw `latte_license*` pointers are still caller-managed via `latte_license_free`
