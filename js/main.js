document.addEventListener('error', function() {
	'use strict';

	if (this.src) {

		// Switch source to PNG fallback for browser that don't support SVG.
		this.src = this.src.replace(/\.svg$/, '.png');
	}
}, true);
