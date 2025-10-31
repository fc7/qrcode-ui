/** @type {import('./$types').PageServerLoad} */
export function load() {
	// Read BACKEND_URL at runtime from environment (not PUBLIC_BACKEND_URL)
	// This allows it to be set via deployment environment variables
	// In server-side code, we use process.env (Node.js), not import.meta.env
	const backendUrl = process.env.BACKEND_URL || 
	                   process.env.PUBLIC_BACKEND_URL || 
	                   'http://localhost:8080';
	
	return {
		backendUrl
	};
}

