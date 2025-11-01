# QR code UI

This is a SvelteKit-based UI frontend to the [Rust qrcode service](https://github.com/fc7/actix-qrcode).

## Configuration

The backend API URL can be configured via the `BACKEND_URL` environment variable. This defaults to `http://localhost:8080` if not set.

NB: You can also use `PUBLIC_BACKEND_URL` locally before starting the server in dev mode or before building with `npm run build`.

## Disclaimer

The generation of the code in this repo was partly AI-assisted.
