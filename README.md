# QR code UI

This is a SvelteKit-based UI frontend to the [Rust qrcode service](https://github.com/fc7/actix-qrcode).

## Configuration

The backend API URL can be configured via the `PUBLIC_BACKEND_URL` environment variable. This defaults to `http://localhost:8080` if not set.

**Important:** In Vite/SvelteKit, `PUBLIC_` prefixed environment variables need to be available when starting the dev server or building. Set it before running `npm run dev` or `npm run build`.

**Option 1: Create a `.env` file in the project root:**

```env
PUBLIC_BACKEND_URL=http://localhost:8080
```

**Option 2: Set it when running the dev server:**

```sh
PUBLIC_BACKEND_URL=http://localhost:8080 npm run dev
```

**Option 3: Use the UI input field**  
You can also override the backend URL at runtime using the "Backend URL" input field in the web interface.

**Note:** If you set `PUBLIC_BACKEND_URL=localhost:8080` (without `http://`), it will automatically be prefixed with `http://`.

## Disclaimer

The generation of the code in this repo was partly AI-assisted.
