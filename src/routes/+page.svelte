<script>
	// Get backend URL from server-side load function (supports runtime configuration)
	let { data } = $props();
	
	const DEFAULT_BACKEND_URL = 'http://localhost:8080';
	
	// Normalize the backend URL (ensure it has http:// prefix if missing)
	const normalizeUrl = (url) => {
		if (!url) return DEFAULT_BACKEND_URL;
		return url.startsWith('http') ? url : `http://${url}`;
	};
	
	const initialBackendUrl = normalizeUrl(data?.backendUrl);

	let content = $state('');
	let render = $state('svg');
	let size = $state(300);
	let shape = $state('square');
	let embed = $state(false);
	let qrCodeUrl = $state(null);
	let svgContent = $state(null);
	let error = $state(null);
	let loading = $state(false);
	let backendUrl = $state(initialBackendUrl);

	const shapes = [
		{ value: 'square', label: 'Square' },
		{ value: 'roundedsquare', label: 'Rounded Square' },
		{ value: 'circle', label: 'Circle' },
		{ value: 'diamond', label: 'Diamond' },
		{ value: 'vertical', label: 'Vertical' },
		{ value: 'horizontal', label: 'Horizontal' }
	];

	async function generateQRCode() {
		if (!content.trim()) {
			error = 'Please enter content to encode';
			return;
		}

		loading = true;
		error = null;
		qrCodeUrl = null;
		svgContent = null;

		try {
			const params = new URLSearchParams({
				content: content.trim()
			});

			if (render === 'png' && size) {
				params.append('size', size.toString());
			}
			if (render) {
				params.append('render', render);
			}
			if (shape) {
				params.append('shape', shape);
			}
			if (embed) {
				params.append('embed', 'true');
			}

			const url = `${backendUrl}/?${params.toString()}`;
			
			const response = await fetch(url);
			
			if (!response.ok) {
				throw new Error(`Server error: ${response.status} ${response.statusText}`);
			}

			if (render === 'svg') {
				const svgText = await response.text();
				// Store raw SVG for inline rendering
				svgContent = svgText;
				// Also store as data URL for download
				const encoded = encodeURIComponent(svgText);
				qrCodeUrl = `data:image/svg+xml,${encoded}`;
			} else {
				const blob = await response.blob();
				qrCodeUrl = URL.createObjectURL(blob);
			}
		} catch (err) {
			error = err.message || 'Failed to generate QR code';
			console.error('Error generating QR code:', err);
		} finally {
			loading = false;
		}
	}

	function downloadQRCode() {
		if (!qrCodeUrl) return;

		const link = document.createElement('a');
		link.href = qrCodeUrl;
		link.download = `qrcode.${render}`;
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);
	}

	function handleSubmit(event) {
		event.preventDefault();
		generateQRCode();
	}
</script>

<div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 py-8 px-4">
	<div class="max-w-4xl mx-auto">
		<header class="text-center mb-8">
			<h1 class="text-4xl font-bold text-gray-900 mb-2">QR Code Generator</h1>
			<p class="text-gray-600">Generate QR codes with customizable options</p>
			<p class="text-gray-400">Author: François Charette (<a href="https://github.com/fc7/qrcode-ui">Source code</a>)</p>
		</header>

		<div class="bg-white rounded-2xl shadow-xl p-6 md:p-8 mb-6">
			<form onsubmit={handleSubmit} class="space-y-6">
				<!-- Content Input -->
				<div>
					<label for="content" class="block text-sm font-medium text-gray-700 mb-2">
						Content to Encode <span class="text-red-500">*</span>
					</label>
					<textarea
						id="content"
						bind:value={content}
						rows="3"
						placeholder="Enter text, URL, or any content to encode..."
						class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
						required
					></textarea>
				</div>

				<!-- Render Format, Shape, and Embed in one row -->
				<div class="flex flex-wrap items-end gap-4">
					<!-- Render Format -->
					<div class="flex-1 min-w-[120px]">
						<label for="render" class="block text-sm font-medium text-gray-700 mb-2">
							Render Format
						</label>
						<div class="flex gap-4">
							<label class="flex items-center cursor-pointer">
								<input
									type="radio"
									bind:group={render}
									value="png"
									class="mr-2 text-blue-600 focus:ring-blue-500"
								/>
								<span class="text-gray-700">PNG</span>
							</label>
							<label class="flex items-center cursor-pointer">
								<input
									type="radio"
									bind:group={render}
									value="svg"
									class="mr-2 text-blue-600 focus:ring-blue-500"
								/>
								<span class="text-gray-700">SVG</span>
							</label>
						</div>
					</div>

					<!-- Shape Selection -->
					<div class="flex-1 min-w-[150px]">
						<label for="shape" class="block text-sm font-medium text-gray-700 mb-2">
							Module Shape
						</label>
						<select
							id="shape"
							bind:value={shape}
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white"
						>
							{#each shapes as s}
								<option value={s.value}>{s.label}</option>
							{/each}
						</select>
					</div>

					<!-- Embed Image -->
					<div class="flex items-center mb-2">
						<label class="flex items-center cursor-pointer">
							<input
								type="checkbox"
								bind:checked={embed}
								class="w-5 h-5 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
							/>
							<span class="ml-3 text-sm font-medium text-gray-700">
								Embed image in center
							</span>
						</label>
					</div>
				</div>

				<!-- Size (only for PNG) -->
				{#if render === 'png'}
					<div>
						<label for="size" class="block text-sm font-medium text-gray-700 mb-2">
							Size (pixels): {size}
						</label>
						<input
							type="range"
							id="size"
							min="100"
							max="1000"
							step="50"
							bind:value={size}
							class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600"
						/>
						<div class="flex justify-between text-xs text-gray-500 mt-1">
							<span>100px</span>
							<span>1000px</span>
						</div>
					</div>
				{/if}

				<!-- Submit Button -->
				<button
					type="submit"
					disabled={loading}
					class="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white font-semibold py-3 px-6 rounded-lg hover:from-blue-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-all shadow-lg hover:shadow-xl"
				>
					{loading ? 'Generating...' : 'Generate QR Code'}
				</button>

				<!-- QR Code Preview - Automatically displayed when available -->
				{#if qrCodeUrl}
					<div class="mt-6 pt-6 border-t border-gray-200 transition-opacity duration-300">
						<div class="flex flex-col items-center">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">QR Code Preview</h3>
							<div class="flex justify-center items-center mb-6">
								<div class="inline-block p-4 bg-gray-50 rounded-lg shadow-sm">
									{#if render === 'svg' && svgContent}
										<div class="inline-block max-w-full mx-auto" style="width: 600px; height: 600px;">
											<div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;">
												{@html svgContent}
											</div>
										</div>
									{:else if qrCodeUrl}
										<img
											src={qrCodeUrl}
											alt="Generated QR Code"
											class="max-w-full h-auto mx-auto"
										/>
									{/if}
								</div>
							</div>
							<button
								onclick={downloadQRCode}
								class="bg-green-600 text-white font-semibold py-2 px-6 rounded-lg hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transition-all shadow-md hover:shadow-lg"
							>
								Download QR Code
							</button>
						</div>
					</div>
				{/if}
			</form>
		</div>

		<!-- Error Message -->
		{#if error}
			<div class="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6">
				<p class="font-medium">Error</p>
				<p>{error}</p>
			</div>
		{/if}
	</div>
</div>