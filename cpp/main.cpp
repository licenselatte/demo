#include <iostream>
#include <string>
#include "latte/latte.hpp"

static constexpr const char *APP_ID = "pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC";

/* Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265 */

static void print_license(const latte::License &lic) {
    std::cout << "  Key:           " << lic.key()           << "\n"
              << "  ActivationID:  " << lic.activation_id() << "\n"
              << "  LicenseType:   " << lic.license_type()  << "\n"
              << "  IssuedAt:      " << lic.issued_at()      << "\n"
              << "  ExpiresAt:     " << lic.expires_at()     << "\n"
              << "  InGracePeriod: " << lic.in_grace_period() << "\n";

    auto meta = lic.metadata();
    if (!meta.empty()) {
        std::cout << "  Metadata:\n";
        for (const auto &[k, v] : meta)
            std::cout << "    " << k << " = " << v << "\n";
    }
}

int main() {
    try {
        latte::Config cfg(APP_ID);
        latte::Sdk sdk(cfg);

        std::cout << "License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ";
        std::string key;
        std::getline(std::cin, key);

        latte::License lic = sdk.activate(key);
        std::cout << "License activated!\n";
        print_license(lic);

        /* Demonstrate offline check */
        latte::License checked = sdk.check();
        std::cout << "\nOffline check passed: key=" << checked.key() << "\n";

    } catch (const std::exception &e) {
        std::cerr << e.what() << "\n";
        return 1;
    }
    return 0;
}
