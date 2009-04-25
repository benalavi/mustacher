require File.dirname(__FILE__) + '/../../test_helper'

module Citrusbyte::Milton
  class MustacherTest < ActiveSupport::TestCase
    @@options ||= {
      :storage_options => { :root => output_path, :chmod => 0755 }, 
      :separator       => '.', 
      :tempfile_path   => File.join(Rails.root, 'tmp', 'milton'),
      :mustache_root   => File.join(File.dirname(__FILE__), '..', '..', '..', 'mustaches')
    }

    context "creating" do
      setup do
        @source = Storage::DiskFile.create('milton.jpg', 1, File.join(fixture_path, 'milton.jpg'), @@options)
      end
      
      context "with no options" do
        setup do
          @mustache = Mustacher.process(@source, {}, @@options)
        end
        
        should "should create mustached derivative" do
          assert File.exists?(@mustache.path)
        end
        
        should "attach .mustached as options" do
          assert_equal 'milton.mustached.jpg', @mustache.filename
        end
      end
    end
  end
end