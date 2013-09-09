#
# Jekyll Generator for PNG-SVG fallback.
#

require 'rsvg2'

module Jekyll

	class PngGenerator < Generator
		safe true

		def generate(site)
			Dir.chdir File.expand_path('../img', File.dirname(__FILE__))
			Dir.glob('*.svg') do |file|
				handle = RSVG::Handle.new_from_file(file)

				width, height = handle.dimensions.to_a

				surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
				context = Cairo::Context.new(surface)
				context.render_rsvg_handle(handle)

				surface.write_to_png(File.basename(file, '.svg') + '.png')
			end
		end

	end

end
