use std::io::{self, Write};
use std::time::{SystemTime, UNIX_EPOCH};

use latte_rs::error::LatteError;
use latte_rs::{Config, PublicLicense, Sdk};

fn unix_secs(t: SystemTime) -> u64 {
    t.duration_since(UNIX_EPOCH).map(|d| d.as_secs()).unwrap_or(0)
}

const APP_ID: &str = "pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC";

// Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265

/// latte-rs has no `unsafe` and no OS-fingerprinting of its own (unlike
/// latte-c/latte-go) — it takes an opaque machine ID string from the
/// integrator. A real app should use a stable per-device fingerprint; this
/// demo just falls back to the hostname.
fn demo_machine_id() -> String {
    std::env::var("HOSTNAME")
        .or_else(|_| std::env::var("COMPUTERNAME"))
        .unwrap_or_else(|_| "demo-machine".to_string())
}

fn print_license(lic: &PublicLicense) {
    println!("  Key:           {}", lic.key);
    println!("  ActivationID:  {}", lic.activation_id);
    println!("  LicenseType:   {:?}", lic.license_type);
    println!("  IssuedAt:      {}", unix_secs(lic.issued_at));
    println!("  ExpiresAt:     {}", unix_secs(lic.expires_at));
    println!("  InGracePeriod: {}", lic.in_grace_period);
    if !lic.metadata.is_empty() {
        println!("  Metadata:");
    }
    for (k, v) in &lic.metadata {
        println!("    {k} = {v}");
    }
}

#[tokio::main]
async fn main() {
    let sdk = match Sdk::new(Config::with_app_id(APP_ID)) {
        Ok(sdk) => sdk,
        Err(e) => {
            eprintln!("SDK init failed: {e}");
            return;
        }
    };

    let machine_id = demo_machine_id();

    print!("License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ");
    io::stdout().flush().unwrap();

    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();
    let key = input.trim();

    match sdk.activate(key, &machine_id).await {
        Ok(lic) => {
            println!("License activated!");
            print_license(&lic);
        }
        Err(e) => {
            eprintln!("Activation error: {e}");
            return;
        }
    }

    // Demonstrate offline check
    match sdk.check(&machine_id) {
        Ok(lic) => println!("\nOffline check passed: key={}", lic.key),
        Err(LatteError::NotActivated) => eprintln!("Check error: not activated on this machine"),
        Err(e) => eprintln!("Check error: {e}"),
    }
}
