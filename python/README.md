# Python demo

Uses [`latte-py`](https://github.com/licenselatte/latte-py), the native Python
SDK from [PyPI](https://pypi.org/project/latte-py/) — an idiomatic, from-scratch
implementation of license activation and verification. No C toolchain or FFI
is involved.

## Prerequisites

- Python >= 3.9

## Build / install

```sh
make python   # from the repo root, creates python/.venv and installs latte-py
```

Or manually:

```sh
cd python
python3 -m venv .venv
.venv/bin/pip install -e .
```

## Run

```sh
make run-python   # from the repo root

# or directly:
python/.venv/bin/python python/main.py
# License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
# > G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265
```

## Notes

- `Sdk(Config(app_id=...))` creates one SDK instance per process;
  `sdk.activate(key, machine_id)` and `sdk.check(machine_id)` are synchronous
- Unlike `latte-c`/`latte-go`, `latte-py` does no OS-level machine fingerprinting
  of its own — the caller supplies an opaque `machine_id` string. This demo
  falls back to `platform.node()` (hostname) for simplicity; a real integration
  should use a stable per-device fingerprint
- There's no background renewal: call `sdk.renew(...)` yourself on whatever
  schedule fits your application (not shown in this demo)
- Read latte-py's "Threat Model" section before relying on it for anything
  security-sensitive: Python bytecode is trivially readable/patchable, so it
  provides the same cryptographic correctness as the compiled SDKs but not the
  same tamper resistance
