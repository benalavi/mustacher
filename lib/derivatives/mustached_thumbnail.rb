require 'milton/derivatives/thumbnail'

module Citrusbyte
  module Milton
    class MustachedThumbnail < Thumbnail
      def path
        options[:name] = 'mustached'
        mustachify if process?
        super
      end
      
      protected
      
      def mustachify
        destination = Milton::Tempfile.path(settings[:tempfile_path], Milton::File.extension(@source.filename))
        mustacher   = Mustacher.new(Image.from_path(@source.path), Mustache.random(settings))
        composite   = %Q{
          composite
            -compose atop
            -gravity southwest
            -geometry #{mustacher.geometry}
            #{mustacher.mustache.path} -resize #{mustacher.scale}
            #{@source.path}
            #{destination}
        }.gsub(/\n/, ' ').gsub(/\s+/, ' ').strip
        
        Milton.syscall(composite)
        
        file.store(destination)
      end
    end
    
    class Mustacher
      attr_reader :image, :mustache
      
      def initialize(image, mustache)
        @image    = image
        @mustache = mustache
      end
      
      def geometry
        "#{x_offset}#{y_offset}"
      end

      def scale
        info[:scale] ||= (image.width * (rand(45)+5)) / 100
        info[:scale]
      end

      def rotation
        info[:rotation] ||= %w( - + ).rand + rand(15).to_s
        info[:rotation]
      end

      private

      def x_offset
        info[:x_offset] ||= offset image.width, scale
        info[:x_offset]
      end

      def y_offset
        info[:y_offset] ||= offset image.height, scaled_height(scale)
        info[:y_offset]
      end

      def offset(image_dimension, mustache_dimension)
        offset = rand(image_dimension) - mustache_dimension/2
        offset < 0 ? offset.to_s : "+#{offset}"
      end

      def scaled_height(width)
        (mustache.height * width) / mustache.width
      end

      def info
        @info ||= {}
        @info
      end
    end
    
    class Mustache < Image
      attr_reader :filename, :options
      
      class << self
        def from_path(path, options)
          image = Image.from_path(path)
          new(image.width, image.height, File.basename(path), options)
        end
        
        def random(options={})
          from_path(Dir.glob(File.join(options[:mustache_dirname], '*')).rand, options)
        end
      end

      def initialize(width, height, filename, options={})
        super(width, height)
        @filename = filename
        @options  = options
      end

      def path
        File.join(options[:mustache_dirname], filename)
      end
    end
  end
end