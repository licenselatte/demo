#include <stdio.h>
#include <string.h>
#include "latte/latte.h"

#define APP_ID "pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC"

/* Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265 */

int main(void)
{
    latte_config *cfg = latte_config_new(APP_ID);
    if (!cfg) {
        fprintf(stderr, "SDK init failed: could not build config\n");
        return 1;
    }

    latte_sdk *sdk = NULL;
    latte_status st = latte_new(cfg, &sdk);
    latte_config_free(cfg);
    if (st != LATTE_OK) {
        fprintf(stderr, "SDK init failed: %s\n", latte_strerror(st));
        return 1;
    }

    printf("License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ");
    char input[128] = {0};
    if (!fgets(input, sizeof(input), stdin)) {
        latte_free(sdk);
        return 1;
    }
    size_t len = strlen(input);
    if (len > 0 && input[len - 1] == '\n') input[len - 1] = '\0';

    latte_license *lic = NULL;
    st = latte_activate(sdk, input, &lic);
    if (st != LATTE_OK) {
        fprintf(stderr, "Activation error: %s\n", latte_strerror(st));
        latte_free(sdk);
        return 1;
    }

    printf("License activated!\n");
    printf("  Key:           %s\n", lic->key           ? lic->key           : "");
    printf("  ActivationID:  %s\n", lic->activation_id ? lic->activation_id : "");
    printf("  LicenseType:   %s\n", lic->license_type  ? lic->license_type  : "");
    printf("  IssuedAt:      %lld\n", (long long)lic->issued_at);
    printf("  ExpiresAt:     %lld\n", (long long)lic->expires_at);
    printf("  InGracePeriod: %u\n",   lic->in_grace_period);

    if (lic->metadata_count > 0) {
        printf("  Metadata:\n");
        for (uint32_t i = 0; i < lic->metadata_count; i++)
            printf("    %s = %s\n", lic->metadata[i].key, lic->metadata[i].value);
    }

    latte_license_free(lic);

    /* Demonstrate offline check */
    latte_license *checked = NULL;
    st = latte_check(sdk, &checked);
    if (st == LATTE_OK) {
        printf("\nOffline check passed: key=%s\n", checked->key ? checked->key : "");
        latte_license_free(checked);
    } else {
        fprintf(stderr, "Check error: %s\n", latte_strerror(st));
    }

    latte_free(sdk);
    return 0;
}
