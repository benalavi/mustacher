require File.dirname(__FILE__) + '/../test_helper'

class MustachingTest < ActiveSupport::TestCase
  class Image < ActiveRecord::Base
    is_attachment :storage_options => { :root => output_path }, :processors => [ :mustacher, :thumbnail ], :recipes => { 
      :foo => { :mustacher => true },
      :bar => { :mustacher => true, :thumbnail => { :size => '100x100', :crop => true } },
      :baz => { :thumbnail => { :size => '200x200' } }
    }
  end
  
  context "creating" do
    @@foo ||= Image.create! :file => upload('milton.jpg')
    
    should "retain original version" do
      assert File.exists?(@@foo.path)
    end
    
    should "create mustached version" do
      assert File.exists?(@@foo.path(:foo))
    end
    
    should "name mustached version with .mustached" do
      assert 'milton.mustached.jpg', File.basename(@@foo.path(:foo))
    end
    
    should "create mustached, thumbnailed version" do
      assert File.exists?(@@foo.path(:bar))
    end
    
    should "name mustached, thumbnailed version with both sets of options" do
      assert 'milton.mustached.crop=true_size=100x100.jpg', File.basename(@@foo.path(:bar))
    end
    
    should "create thumbnailed version" do
      assert File.exists?(@@foo.path(:baz))
    end
    
    should "name thumbnailed version w/o mustaching" do
      assert 'milton.size=200x200.jpg', File.basename(@@foo.path(:baz))
    end
  end

  class ImageWithOndemandMustaching < Image
    is_attachment :storage_options => { :root => output_path }, :postprocessing => true, :recipes => {}
  end
    
  context "post-processing" do
    @@bar ||= ImageWithOndemandMustaching.create! :file => upload('milton.jpg')
    
    should "create mustached thumbnail" do
      assert File.exists?(@@bar.path(:mustacher => true, :thumbnail => { :size => '100x100' }))
    end
  end
end
