from latte import Config, LatteError, LicenseExpiredError, NotActivatedError, Sdk

APP_ID = "pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC"

# Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265


def print_license(lic) -> None:
    print(f"  Key:           {lic.key}")
    print(f"  ActivationID:  {lic.activation_id}")
    print(f"  LicenseType:   {lic.license_type}")
    print(f"  IssuedAt:      {lic.issued_at}")
    print(f"  ExpiresAt:     {lic.expires_at}")
    print(f"  InGracePeriod: {lic.in_grace_period}")
    if lic.metadata:
        print("  Metadata:")
        for k, v in lic.metadata.items():
            print(f"    {k} = {v}")


def main() -> None:
    sdk = Sdk(Config(app_id=APP_ID))

    key = input("License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ")

    try:
        lic = sdk.activate(key)
    except LatteError as e:
        print(f"Activation error: {e}")
        return

    print("License activated!")
    print_license(lic)

    # Demonstrate offline check
    try:
        checked = sdk.check()
        print(f"\nOffline check passed: key={checked.key}")
    except LicenseExpiredError:
        print("Check error: license expired")
    except NotActivatedError:
        print("Check error: not activated on this machine")


if __name__ == "__main__":
    main()
