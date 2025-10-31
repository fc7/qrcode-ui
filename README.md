# sv

Everything you need to build a Svelte project, powered by [`sv`](https://github.com/sveltejs/cli).

## Creating a project

If you're seeing this, you've probably already done this step. Congrats!

```sh
# create a new project in the current directory
npx sv create

# create a new project in my-app
npx sv create my-app
```

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```sh
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```sh
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.

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
