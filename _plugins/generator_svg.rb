#
# Jekyll Generator for PNG-SVG fallback.
#

require 'rsvg2'

module Jekyll

	class PngGenerator < Generator
		safe true

		def generate(site)
			Dir.chdir File.expand_path('../img', File.dirname(__FILE__))
			Dir.glob('*.svg') do |from|
				to = File.basename(from, '.svg') + '.png'

				FileUtils.uptodate?(to, [from]) or \
					convert(from, to)
			end
		end

		def convert(from, to)
			puts 'Converting ' + from + ' to ' + to + '...'

			handle = RSVG::Handle.new_from_file(from)

			width, height = handle.dimensions.to_a

			surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
			context = Cairo::Context.new(surface)
			context.render_rsvg_handle(handle)

			surface.write_to_png(to)
		end

	end

end
