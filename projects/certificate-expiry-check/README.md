# Project 7 — TLS certificate expiry check

This script connects to a TLS endpoint and reads the presented certificate's expiry date. It requires OpenSSL and GNU date, and uses timeout so a connection cannot hang forever.

Only check endpoints you own or are authorized to assess. The script only performs a TLS handshake; it does not scan ports or attempt login.

## Run it

    bash projects/certificate-expiry-check/certificate-expiry-check.sh --host example.com
    bash projects/certificate-expiry-check/certificate-expiry-check.sh --host example.com --port 443 --warning-days 30

An example.com host is shown to demonstrate the syntax; use your own service for operational checks. The endpoint must be reachable from your machine.

## Exit status

- 0: the certificate is valid for longer than the warning window
- 1: the certificate is expired or within the warning window
- 2: invalid arguments, missing dependencies, or certificate retrieval failed

## Exercise

Add a separate critical threshold. Try a local test endpoint with a certificate you control, and confirm the warning arrives before the certificate expires. Network, proxy, and certificate-chain configuration may affect results.
