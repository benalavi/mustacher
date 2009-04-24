require File.dirname(__FILE__) + '/../../test_helper'

module Citrusbyte::Milton
  class MustachedThumbnailTest < ActiveSupport::TestCase
    @@options ||= {
      :storage_options  => { :root => output_path, :chmod => 0755 }, 
      :separator        => '.', 
      :tempfile_path    => File.join(Rails.root, 'tmp', 'milton'),
      :process          => true,
      :mustache_dirname => File.join(File.dirname(__FILE__), '..', '..', '..', 'mustaches')
    }

    context "creating" do
      setup do
        @source = Storage::DiskFile.create('milton.jpg', 1, File.join(fixture_path, 'milton.jpg'), @@options)
      end
    
      should "name the mustached original 'mustached'" do
        assert_equal 'milton.mustached.jpg', File.basename(path = MustachedThumbnail.new(@source, {}, @@options).path)
        `open #{path}`
      end
    end
  end
end