require 'milton/derivatives/mustacher/mustache_calculator'

module Citrusbyte
  module Milton
    class Mustacher < Derivative
      def initialize(source, options={}, settings={})
        super source, { :mustached => true }, settings
      end
      
      def process
        mustache    = Dir.glob(File.join((settings[:mustache_root] || File.join(File.dirname(__FILE__), '..', '..', '..', 'mustaches')), '*')).rand
        destination = Milton::Tempfile.path(settings[:tempfile_path], Milton::File.extension(@source.filename))
        calculator  = MustacheCalculator.new(Image.from_path(@source.path), Image.from_path(mustache))
        
        composite   = %Q{
          composite
            -compose atop
            -gravity southwest
            -geometry #{calculator.geometry}
            #{mustache} -resize #{calculator.scale}
            #{@source.path}
            #{destination}
        }.gsub(/\n/, ' ').gsub(/\s+/, ' ').strip
        
        # TODO: raise on failed syscall
        Milton.syscall(composite)
        
        # TODO: raise on failed store
        file.store(destination)
      end
    end
  end
end