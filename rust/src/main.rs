mod latte;

use std::ffi::{CStr, CString};
use std::io::{self, Write};
use std::ptr;

const APP_ID: &str = "pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC";

// Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265

unsafe fn cstr(p: *mut ::std::os::raw::c_char) -> &'static str {
    if p.is_null() { "" } else { CStr::from_ptr(p).to_str().unwrap_or("") }
}

fn main() {
    let app_id = CString::new(APP_ID).unwrap();
    let mut sdk: *mut latte::latte_sdk = ptr::null_mut();

    unsafe {
        let st = latte::latte_new(app_id.as_ptr(), &mut sdk);
        if st != latte::latte_status::LATTE_OK {
            eprintln!(
                "SDK init failed: {}",
                CStr::from_ptr(latte::latte_strerror(st)).to_string_lossy()
            );
            return;
        }
    }

    print!("License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ");
    io::stdout().flush().unwrap();

    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();
    let key = CString::new(input.trim()).unwrap();

    unsafe {
        let mut lic: *mut latte::latte_license = ptr::null_mut();
        let st = latte::latte_activate(sdk, key.as_ptr(), &mut lic);
        if st != latte::latte_status::LATTE_OK {
            eprintln!(
                "Activation error: {}",
                CStr::from_ptr(latte::latte_strerror(st)).to_string_lossy()
            );
            latte::latte_free(sdk);
            return;
        }

        let l = &*lic;
        println!("License activated!");
        println!("  Key:           {}", cstr(l.key));
        println!("  ActivationID:  {}", cstr(l.activation_id));
        println!("  LicenseType:   {}", cstr(l.license_type));
        println!("  IssuedAt:      {}", l.issued_at);
        println!("  ExpiresAt:     {}", l.expires_at);
        println!("  InGracePeriod: {}", l.in_grace_period);

        for i in 0..l.metadata_count as usize {
            let kv = &*l.metadata.add(i);
            println!("    {} = {}", cstr(kv.key), cstr(kv.value));
        }

        latte::latte_license_free(lic);

        // Demonstrate offline check
        let mut checked: *mut latte::latte_license = ptr::null_mut();
        if latte::latte_check(sdk, &mut checked) == latte::latte_status::LATTE_OK {
            println!("\nOffline check passed: key={}", cstr((*checked).key));
            latte::latte_license_free(checked);
        }

        latte::latte_free(sdk);
    }
}
