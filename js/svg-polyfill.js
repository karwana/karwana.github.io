document.body.addEventListener('error', function(event) {
	'use strict';
	var img = event.target;

	if (img.src) {

		// Switch source to PNG fallback for browser that don't support SVG.
		img.src = img.src.replace(/\.svg$/, '.png');
	}
}, true);
