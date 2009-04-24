require 'milton'

require File.join(File.dirname(__FILE__), 'derivatives', 'mustached_thumbnail')

module Citrusbyte
  module Milton
    module IsMustacheable
      def self.included(base)
        base.extend IsMethods
      end

      module IsMethods
        def is_mustacheable(options={})
          ensure_attachment_methods options
          
          options[:mustache_dirname] ||= File.join(File.dirname(__FILE__), '..', 'mustaches')
          
          self.milton_options.deep_merge!(options)
          
          include Citrusbyte::Milton::IsMustacheable::InstanceMethods
        end
      end

      module InstanceMethods
        def path(options={})
          MustachedThumbnail.new(attached_file, options, self.class.milton_options.merge(:process => process?)).path
        end
        
        protected
        
        def create_derivatives
          mustached_original = attached_file.copy(MustachedThumbnail.new(attached_file, {}, self.class.milton_options.merge(:process => true)).path)
          mustached_thumbnails = self.class.milton_options[:resizeable][:sizes].each do |name, options|
            MustachedThumbnail.new(mustached_original, options.merge(:name => name), self.class.milton_options.merge(:process => true)).path
          end
        end
      end        
    end
  end
end

ActiveRecord::Base.send(:include, Citrusbyte::Milton::IsMustacheable)
