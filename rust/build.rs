fn main() {
    let latte = std::path::PathBuf::from(
        std::env::var("LATTE_C_ROOT").unwrap_or_else(|_| "../vendor/latte-c".to_string()),
    );

    println!(
        "cargo:rustc-link-search=native={}",
        latte.join("build").display()
    );
    println!("cargo:rustc-link-lib=static=latte");
    // cJSON is vendored inside latte-c and built as a separate static archive.
    println!("cargo:rustc-link-lib=static=cjson");
    println!("cargo:rustc-link-lib=dylib=sodium");
    println!("cargo:rustc-link-lib=dylib=curl");
    println!(
        "cargo:rerun-if-changed={}",
        latte.join("include/latte/latte.h").display()
    );

    // On macOS, add the Homebrew lib path so the linker finds libsodium/libcurl.
    if cfg!(target_os = "macos") {
        let brew = std::process::Command::new("brew")
            .arg("--prefix")
            .output()
            .ok()
            .and_then(|o| String::from_utf8(o.stdout).ok())
            .unwrap_or_default();
        let brew = brew.trim();
        if !brew.is_empty() {
            println!("cargo:rustc-link-search=native={brew}/lib");
        }
    }

    let bindings = bindgen::Builder::default()
        .header(latte.join("include/latte/latte.h").to_str().unwrap())
        .allowlist_type("latte_.*")
        .allowlist_function("latte_.*")
        .rustified_enum("latte_status")
        .parse_callbacks(Box::new(bindgen::CargoCallbacks::new()))
        .generate()
        .expect("bindgen failed");

    let out = std::path::PathBuf::from(std::env::var("OUT_DIR").unwrap());
    bindings.write_to_file(out.join("latte.rs")).unwrap();
}
