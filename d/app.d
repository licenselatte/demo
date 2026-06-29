import std.stdio;
import std.string : toStringz, fromStringz, strip;
import core.stdc.stdint : int64_t, uint32_t;

// Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265

// ── C bindings ────────────────────────────────────────────────────────────────

extern (C) {
    struct latte_sdk {}

    struct latte_kv {
        char* key;
        char* value;
    }

    struct latte_license {
        char* key;
        char* activation_id;
        char* project_id;
        char* license_type;
        int64_t issued_at;
        int64_t expires_at;
        int64_t grace_period_seconds;
        uint32_t in_grace_period;
        uint32_t metadata_count;
        latte_kv* metadata;
    }

    enum latte_status {
        LATTE_OK = 0,
        LATTE_ERR_INVALID_KEY,
        LATTE_ERR_LICENSE_EXPIRED,
        LATTE_ERR_NOT_ACTIVATED,
        LATTE_ERR_SEAT_LIMIT,
        LATTE_ERR_LICENSE_NOT_FOUND,
        LATTE_ERR_INVALID_PROJECT_KEY,
        LATTE_ERR_INVALID_APPID,
        LATTE_ERR_UNKNOWN_ENVIRONMENT,
        LATTE_ERR_INVALID_APPID_KEY_SEGMENT,
        LATTE_ERR_INVALID_APPID_CHECKSUM,
        LATTE_ERR_STORAGE_INIT_FAILED,
        LATTE_ERR_MACHINE_ID_FAILED,
        LATTE_ERR_NETWORK,
        LATTE_ERR_SERVER_INVALID_TOKEN,
        LATTE_ERR_INTERNAL,
    }

    latte_status latte_new(const char* app_id, latte_sdk** out_);
    latte_status latte_activate(latte_sdk* sdk, const char* key, latte_license** out_);
    latte_status latte_check(latte_sdk* sdk, latte_license** out_);
    void         latte_license_free(latte_license* lic);
    void         latte_free(latte_sdk* sdk);
    const(char)* latte_strerror(latte_status s);
}

// ── helpers ───────────────────────────────────────────────────────────────────

string cstr(char* p) {
    return p ? p.fromStringz.idup : "";
}

// ── main ──────────────────────────────────────────────────────────────────────

void main() {
    latte_sdk* sdk;
    auto st = latte_new("pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC".toStringz, &sdk);
    if (st != latte_status.LATTE_OK) {
        stderr.writefln("SDK init failed: %s", latte_strerror(st).fromStringz);
        return;
    }
    scope (exit) latte_free(sdk);

    write("License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ");
    stdout.flush();

    string input = readln().strip();

    latte_license* lic;
    st = latte_activate(sdk, input.toStringz, &lic);
    if (st != latte_status.LATTE_OK) {
        stderr.writefln("Activation error: %s", latte_strerror(st).fromStringz);
        return;
    }
    scope (exit) latte_license_free(lic);

    writeln("License activated!");
    writefln("  Key:           %s", cstr(lic.key));
    writefln("  ActivationID:  %s", cstr(lic.activation_id));
    writefln("  LicenseType:   %s", cstr(lic.license_type));
    writefln("  IssuedAt:      %d", lic.issued_at);
    writefln("  ExpiresAt:     %d", lic.expires_at);
    writefln("  InGracePeriod: %d", lic.in_grace_period);

    if (lic.metadata_count > 0) {
        writeln("  Metadata:");
        foreach (i; 0 .. lic.metadata_count)
            writefln("    %s = %s", cstr(lic.metadata[i].key), cstr(lic.metadata[i].value));
    }

    // Demonstrate offline check
    latte_license* checked;
    st = latte_check(sdk, &checked);
    if (st == latte_status.LATTE_OK) {
        writefln("\nOffline check passed: key=%s", cstr(checked.key));
        latte_license_free(checked);
    } else {
        stderr.writefln("Check error: %s", latte_strerror(st).fromStringz);
    }
}
