#include <iostream>
#include <stdexcept>
#include <string>
#include "latte/latte.h"

static constexpr const char *APP_ID = "pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC";

/* Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265 */

class LatteSDK {
    latte_sdk *sdk_ = nullptr;

public:
    explicit LatteSDK(const std::string &app_id) {
        latte_status st = latte_new(app_id.c_str(), &sdk_);
        if (st != LATTE_OK)
            throw std::runtime_error(std::string("SDK init failed: ") + latte_strerror(st));
    }

    ~LatteSDK() {
        if (sdk_) latte_free(sdk_);
    }

    LatteSDK(const LatteSDK &) = delete;
    LatteSDK &operator=(const LatteSDK &) = delete;

    /* Returns a heap-allocated latte_license; caller must call latte_license_free(). */
    latte_license *activate(const std::string &key) const {
        latte_license *lic = nullptr;
        latte_status st = latte_activate(sdk_, key.c_str(), &lic);
        if (st != LATTE_OK)
            throw std::runtime_error(std::string("Activation error: ") + latte_strerror(st));
        return lic;
    }

    latte_license *check() const {
        latte_license *lic = nullptr;
        latte_status st = latte_check(sdk_, &lic);
        if (st != LATTE_OK)
            throw std::runtime_error(std::string("Check error: ") + latte_strerror(st));
        return lic;
    }
};

static void print_license(const latte_license *lic) {
    auto s = [](const char *p) -> const char * { return p ? p : ""; };
    std::cout << "  Key:           " << s(lic->key)           << "\n"
              << "  ActivationID:  " << s(lic->activation_id) << "\n"
              << "  LicenseType:   " << s(lic->license_type)  << "\n"
              << "  IssuedAt:      " << lic->issued_at         << "\n"
              << "  ExpiresAt:     " << lic->expires_at        << "\n"
              << "  InGracePeriod: " << lic->in_grace_period   << "\n";

    if (lic->metadata_count > 0) {
        std::cout << "  Metadata:\n";
        for (uint32_t i = 0; i < lic->metadata_count; i++)
            std::cout << "    " << s(lic->metadata[i].key)
                      << " = " << s(lic->metadata[i].value) << "\n";
    }
}

int main() {
    try {
        LatteSDK sdk(APP_ID);

        std::cout << "License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ";
        std::string key;
        std::getline(std::cin, key);

        latte_license *lic = sdk.activate(key);
        std::cout << "License activated!\n";
        print_license(lic);
        latte_license_free(lic);

        /* Demonstrate offline check */
        latte_license *checked = sdk.check();
        std::cout << "\nOffline check passed: key=" << (checked->key ? checked->key : "") << "\n";
        latte_license_free(checked);

    } catch (const std::exception &e) {
        std::cerr << e.what() << "\n";
        return 1;
    }
    return 0;
}
