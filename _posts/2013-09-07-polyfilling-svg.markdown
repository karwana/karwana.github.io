---
layout: post
title: "Polyfilling SVG"
author: "Matthew Caruana Galizia"
date: 2013-09-07 10:30:01
tags: svg polyfill retina
keywords: svg polyfill javascript onerror retina images
---

This guide is part of our series on practical ways to get your site or web app [retina-ready][retina-ready].

## Why use SVG? ##

SVG is awesome for any kind of vector-based artwork. This means most logos, icons or charts. Here are some reasons why we've adopted them across all our projects.

### Sharper images ###

SVG is a vector image format. That means that anti-aliasing is done when the image is rendered on a screen, rather than when it's created. You can shrink or enlarge the image using CSS as much as you like, without the loss in visible quality that you get when doing the same with a PNG or JPEG image.

This alone means that you won't have to supply double-pixel-density images to support retina screen devices like the iPhone 5. The browser will automatically scale up the SVG image and it'll remain as sharp as ever. That means **less work for designers and developers**.

### Tiny files ###

File sizes are tiny - our logo is just 8KB, or 3.7KB if you [configure][svg-gzip] your web server to apply HTTP compression to SVG files. If you're working on web apps that target mobile users and your site is icon-heavy, the combined saving across your files can result in a perceivable benefit in load time.

### Ridiculously quick to edit ###

Last but not least, one of the best aspects from a designer or developer's point of view is that SVG files are actually XML text files. You don't have to mess about with PSD or Illustrator files just to change something basic like the color or size of an icon. It's as simple as opening the SVG file in any old text editor and changing an attribute value.

## Why use a polyfill? ##

According to Google's latest [stats][android-stats], 33.1% of all Android devices in use worldwide are running some flavor of Android 2. This presents a pesky problem as only Android version 3 and above has [SVG support][svg-support] built into the browser. Worse still, Chrome for Android is only available on version 4 or greater.

Android 2 has a wide enough user base that we can't afford not to support it. At the same time, we don't want to lose the rendering sharpness and tiny file size that comes with SVG.

The good news is that as long as you're using SVG for static images like logos and icons, supporting older browsers isn't that hard.

## Here's how ##

At the very least, you'll need to:

- add a small piece of Javascript that listens for the error event, emitted by the browser when an image fails to load
- in the same code, replace the SVG source URL of the image element with that of a PNG image
- automatically or manually convert your existing SVG files to PNGs

The code for the first two steps is just a few lines:

```javascript
document.addEventListener('error', function() {
	if (this.src) {

		// Switch source to PNG fallback for browser that don't support SVG.
		this.src = this.src.replace(/\.svg$/, '.png');
	}
}, true);
```

(If you're wondering why the listener is capturing, it's because [error events don't bubble][no-bubble].)

For the last step, there a few different routes you can take, depending on your development setup and application stack:

- [convert SVG files using a Makefile](/2013/09/convert-svg-files-using-make/)
- [a Jekyll SVG to PNG generator](/2013/09/polyfilling-svg-with-jekyll/)

[retina-ready]: http://www.webdesignerdepot.com/2013/04/why-should-you-become-retina-ready/
[android-stats]: http://developer.android.com/about/dashboards/index.html
[svg-support]: http://caniuse.com/#feat=svg
[svg-gzip]: http://kaioa.com/node/45
[no-bubble]: http://m.cg/post/30934181934/error-events-dont-bubble-from-images-and-how-to-work
