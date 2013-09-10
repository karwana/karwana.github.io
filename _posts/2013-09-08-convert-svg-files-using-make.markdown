---
layout: post
title: "Convert SVG files using make"
author: "Matthew Caruana Galizia"
date: 2013-09-08 11:50:55
tags: svg polyfill make makefile retina
keywords: svg polyfill javascript onerror retina images make makefile
---

This guide is part of our series on using SVG as part of retina-ready strategy. It applies if you're using a `Makefile` as part of the build or deploy process for your web app.

Once you've completed the steps here, add the [Javascript polyfill](/2013/09/polyfilling-svg/) for automatically loading the PNG fallbacks on browsers with no support for SVG.

The first step is to install dependencies. These are the external programs that our script will be shelling out to do the heavy lifting.

If you're on Mac and you're not using [Homebrew][homebrew], go ahead and install it now. Then run `brew install librsvg optipng` in your terminal.

If you're using Ubuntu, it's `apt-get install librsvg2-bin optipng`.

Assuming your project's SVG files are kept in `img/`, here's the full source for the `Makefile`:

```make
SVGS := ${wildcard img/*.svg}
PNGS := ${SVGS:.svg=.png}

all: $(PNGS)

img/%.png: img/%.svg
	rsvg-convert $< -o $@
	optipng $@

clean:
	rm -fv $(PNGS)

.PHONY: all clean
```

In the first part, we create a list of the SVG files in `img/` and a copy of that list with the extensions rewritten to `.png`. The first target in the file instructs `make` to build the corresponding PNG file for each SVG file. The second target is a generic template for building the actual PNG file. In that target, `$@` and `$<` are automatic variables for the target and prerequisite paths. This generic target saves us having to write hard-coded targets for every single PNG.

[homebrew]: http://brew.sh/
