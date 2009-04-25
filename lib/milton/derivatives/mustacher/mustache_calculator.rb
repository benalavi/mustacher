module Citrusbyte
  module Milton
    # TODO: fix rotation
    class MustacheCalculator
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
  end
end