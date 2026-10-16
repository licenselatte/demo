SHELL   := /bin/bash
LATTE_REPO  := https://github.com/licenselatte/latte-c
LATTE_VERSION := v1.5.1
LATTE_DIR := vendor/latte-c
BUILD_DIR := $(LATTE_DIR)/build

LATTE_INCLUDE := $(abspath $(LATTE_DIR)/include)
LATTE_LIB_DIR := $(abspath $(BUILD_DIR))
LATTE_LIB   := $(LATTE_LIB_DIR)/liblatte.a

UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
  BREW_PREFIX := $(shell brew --prefix 2>/dev/null || echo /usr/local)
  EXTRA_CFLAGS  := -I$(BREW_PREFIX)/include
  EXTRA_LFLAGS  := -L$(BREW_PREFIX)/lib -lsodium -lcurl
  D_L_PREFIX  := -L-L$(BREW_PREFIX)/lib
else
  EXTRA_CFLAGS  :=
  EXTRA_LFLAGS  := -lsodium -lcurl
  D_L_PREFIX  :=
endif

# cJSON is vendored inside latte-c and built as a separate static archive.
# CMake chains it automatically; raw linker invocations need it explicitly.
CJSON_LIB := $(LATTE_LIB_DIR)/libcjson.a

D_COMPILER := $(shell command -v ldc2 2>/dev/null || command -v dmd 2>/dev/null || echo dmd)

.PHONY: all latte-c c cpp d go rust python run-python clean clean-all

all: c cpp d go rust python

bin:
	@mkdir -p bin

# ── latte-c (shared dependency for C, C++, D) ───────────────────────────────
$(LATTE_LIB):
	@if [ ! -d "$(LATTE_DIR)/.git" ]; then \
		git clone --depth 1 --branch $(LATTE_VERSION) $(LATTE_REPO) $(LATTE_DIR); \
	fi
	cmake -S $(LATTE_DIR) -B $(BUILD_DIR) -DCMAKE_BUILD_TYPE=Release
	cmake --build $(BUILD_DIR) --target latte_static -- -j4

latte-c: $(LATTE_LIB)

# ── C ────────────────────────────────────────────────────────────────────────
c: $(LATTE_LIB) | bin
	$(CC) -Wall -Wextra \
	  -I$(LATTE_INCLUDE) $(EXTRA_CFLAGS) \
	  c/main.c $(LATTE_LIB) $(CJSON_LIB) $(EXTRA_LFLAGS) \
	  -o bin/c

# ── C++ ──────────────────────────────────────────────────────────────────────
cpp: $(LATTE_LIB) | bin
	$(CXX) -std=c++17 -Wall -Wextra \
	  -I$(LATTE_INCLUDE) $(EXTRA_CFLAGS) \
	  cpp/main.cpp $(LATTE_LIB) $(CJSON_LIB) $(EXTRA_LFLAGS) \
	  -o bin/cpp

# ── D ────────────────────────────────────────────────────────────────────────
d: $(LATTE_LIB) | bin
	$(D_COMPILER) d/app.d $(LATTE_LIB) $(CJSON_LIB) \
	  $(D_L_PREFIX) -L-lsodium -L-lcurl \
	  -of=bin/d

# ── Go (uses latte-go natively no latte-c dependency) ──────────────────────
go: | bin
	cd go && go build -o ../bin/go .

# ── Rust (uses latte-rs natively no latte-c dependency) ─────────────────────
rust: | bin
	cargo build --manifest-path rust/Cargo.toml --release
	cp rust/target/release/demo bin/rust

# ── Python (uses latte-py natively no latte-c dependency) ──────────────────
python: python/.venv/bin/python

python/.venv/bin/python:
	python3 -m venv python/.venv
	python/.venv/bin/pip install -e python

run-python: python
	python/.venv/bin/python python/main.py

# ── Clean ────────────────────────────────────────────────────────────────────
clean:
	rm -rf bin rust/target $(BUILD_DIR) python/.venv

clean-all: clean
	rm -rf $(LATTE_DIR)
