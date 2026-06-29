# C demo

Calls `latte-c` directly no wrappers, no abstractions. The activate → check
pattern in plain C11.

## Prerequisites

- `cmake`, `cc`
- `libsodium`, `libcurl` (e.g. `brew install libsodium curl`)

## Build

```sh
make c    # from the repo root
```

Output: `bin/c`

## Run

```sh
./bin/c
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Notes

- `latte_new` → `latte_activate` → `latte_check` → `latte_free`
- `latte_license_free` must be called on every non-NULL `latte_license*` returned
- The C header is at `vendor/latte-c/include/latte/latte.h`
