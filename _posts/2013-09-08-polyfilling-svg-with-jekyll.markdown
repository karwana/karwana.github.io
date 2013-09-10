---
layout: post
title: "Polyfilling SVG with Jekyll"
author: "Matthew Caruana Galizia"
date: 2013-09-08 13:50:55
tags: svg polyfill jekyll retina
keywords: svg polyfill javascript onerror retina images jekyll
---

This guide is part of our series on using SVG as part of retina-ready strategy for your site or web app. It applies both if you are using [Jekyll with GitHub Pages][jekyll-gh] or deploying to another service using Jekyll.

We're going to be using the [rsvg2][rsvg2] gem to render all our SVG files in `img/` to PNG files in the same directory. To do this, we'll write a small plugin in Ruby. After that, we'll write another plugin that uses the [image_optim][image_optim] gem to optimize the file size of the generated PNGs.

## Install dependencies ##

If your project already has a `Gemfile`, you just need to add the gems as dependencies. Otherwise copy the following into a new file.

```ruby
source 'https://rubygems.org'

gem 'rsvg2'
gem 'image_optim'
```

These gems are Ruby interfaces to libraries which we'll need to install separately. If you're running Mac OS X and you haven't installed [Homebrew][homebrew], it's probably a good idea to do so now. It'll make your life a whole lot easier.

In your Mac terminal, run `brew install librsvg libpng optipng pngcrush`.

If you're using Ubuntu, it's `apt-get install librsvg2-bin libpng optipng pngcrush`.

Now run `bundle install` in your project directory to install the Ruby gems. When that's done, we can move on to installing our Jekyll plugins.

## Install plugins ##

Ruby has different kinds of pre-defined [plugin][jekyll-plugins] classes. We're going to create a `Generator` plugin. The `generate` method is called automatically by Jekyll when you run `jekyll build` or `jekyll serve`. Read the inline comments for an explanation of what each step does.

Ok, now copy the following code into `_plugins/generator_svg.rb`. If you don't already have a `_plugins` directory in your project directory, create one.

```ruby
#
# Jekyll Generator for PNG-SVG fallback.
#

require 'rsvg2'
require 'image_optim'

module Jekyll

	class SvgPngGenerator < Generator
		safe true

		# All Jekyll Generator plugins must export at minimum at generate method.
		def generate(site)

			# Change directory to 'img/' in the root of your project.
			# Feel free to change the path if you're using a different name (e.g. 'images/').
			Dir.chdir File.expand_path('../img', File.dirname(__FILE__))

			# Loop over all the files in the 'img/' directory with the extension '.svg'.
			Dir.glob('*.svg') do |from|

				# We're going to put the generated PNG file in the same directory as its counterpart.
				# And it's going to have the same name too, so just replace the extension.
				to = File.basename(from, '.svg') + '.png'

				# Rendering and optimization is computationally expensive.
				# Only re-render and optimize if the counterpart PNG doesn't exist or is outdated.
				unless FileUtils.uptodate?(to, [from])
					self.convert(from, to)

					# Each time a PNG file is generated, optimize it.
					self.optim(to)
				end
			end
		end

		# Convert the SVG file at the path in 'from' to a PNG file at the path in 'to'.
		def convert(from, to)
			puts 'Converting ' + from + ' to ' + to + '...'

			handle = RSVG::Handle.new_from_file(from)

			# Get the SVG dimensions from its 'width' and 'height' attributes.
			width, height = handle.dimensions.to_a

			# Create a 'surface' with transparency support to render a bitmap onto.
			surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
			context = Cairo::Context.new(surface)
			context.render_rsvg_handle(handle)

			# Write the bitmap to a PNG file at the given path.
			surface.write_to_png(to)
		end

		# Optimize the PNG file at the given path using the binaries supported by 'image_optim'.
		def optim(file)
			puts 'Optimizing ' + file + '...'

			# The 'pngout' and 'advpng' binaries are tricky to install.
			# Disable them by default.
			image_optim = ImageOptim.new(:pngout => false, :advpng => false)

			image_optim.optimize_image!(file)
		end

	end

end
```

The HTTP server provided by jekyll (used when you run `jekyll serve`) doesn't know how to serve SVG files by default. We're going to add one last tiny plugin to help it do that.

Create a file called `_plugins/svg_mime_type.rb` and paste in the following code.

```ruby
#
# SVG mimetype polyfill for Jekyll.
#
# From http://stackoverflow.com/a/13687032/821334
#

require 'webrick'

include WEBrick
WEBrick::HTTPUtils::DefaultMimeTypes.store 'svg', 'image/svg+xml'
```

## Adding the Javascript polyfill ##

Grab the code for the tiny Javascript polyfill from our [previous guide](/2013/09/polyfilling-svg/). Copy it into a file called `svg-polyfill.js` in your project's Javascript directory (e.g. `js/`) and add `<script src="/js/svg-polyfill"></script>` to your default layout's head section.

## You're good to go ##

Just a small note about GitHub Pages. If you're letting GitHub build the pages automatically from your Jekyll source, then for security reasons GitHub will disable plugins when it's generating the static site. This is why **you should run `jekyll build` and commit the PNG files before each release**.

[jekyll-gh]: https://help.github.com/articles/using-jekyll-with-pages
[rsvg2]: https://rubygems.org/gems/rsvg2
[image_optim]: https://rubygems.org/gems/image_optim
[homebrew]: http://brew.sh/
[jekyll-plugins]: http://jekyllrb.com/docs/plugins/
