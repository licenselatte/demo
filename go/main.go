package main

import (
	"fmt"
	"os"

	"github.com/licenselatte/latte-go"
)

const appID = "pk_live_G98S8BKDDMZW32RMQM8NZT33E5CTFEDC"

// Test key (unlimited activations): G98S8-BWAR6-Y0Z7F-JT10A-7EWD9-33265

func main() {
	sdk, err := latte.New(&latte.Config{AppID: appID})
	if err != nil {
		fmt.Fprintf(os.Stderr, "SDK init failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Print("License key (e.g. XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):\n> ")

	var key string
	if _, err := fmt.Scanln(&key); err != nil {
		fmt.Fprintf(os.Stderr, "Read error: %v\n", err)
		os.Exit(1)
	}

	lic, err := sdk.Activate(key)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Activation error: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("License activated!")
	fmt.Printf("  Key:           %s\n", lic.Key)
	fmt.Printf("  ActivationID:  %s\n", lic.ActivationID)
	fmt.Printf("  LicenseType:   %s\n", lic.LicenseType)
	fmt.Printf("  IssuedAt:      %s\n", lic.IssuedAt)
	fmt.Printf("  ExpiresAt:     %s\n", lic.ExpiresAt)
	fmt.Printf("  InGracePeriod: %v\n", lic.InGracePeriod)
	if len(lic.Metadata) > 0 {
		fmt.Println("  Metadata:")
		for k, v := range lic.Metadata {
			fmt.Printf("    %s = %s\n", k, v)
		}
	}

	// Demonstrate offline check
	checked, err := sdk.Check()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Check error: %v\n", err)
		return
	}
	fmt.Printf("\nOffline check passed: key=%s\n", checked.Key)
}
