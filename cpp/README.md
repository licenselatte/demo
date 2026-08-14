# C++ demo

Uses `latte-c`'s official header-only C++ wrapper (`<latte/latte.hpp>`), shipped
alongside the C library since latte-c 1.1. `latte::Config`/`latte::Sdk`/
`latte::License` are move-only RAII classes over the opaque C handles, and
`latte::Error` turns `latte_status` failures into exceptions.

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

- `latte::Config`/`latte::Sdk`/`latte::License` free their underlying C resource
  in their destructor; none of `latte_free`/`latte_config_free`/`latte_license_free`
  are called directly by the demo
- `sdk.activate(key)` and `sdk.check()` throw `latte::Error` (a `std::runtime_error`)
  on any non-`LATTE_OK` status
- The wrapper header lives at `vendor/latte-c/include/latte/latte.hpp`, alongside
  the plain C header the [C demo](../c) uses directly
