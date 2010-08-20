require 'spec_helper'

describe RailsAdminController do
  it "should be awesome" do
    pending
  end
end

# require File.dirname(__FILE__) + '/../spec_helper'
#
# describe MerbAdmin::Main do
#
#   before(:each) do
#     mount_slice
#   end
#
#   it "should have helper methods for dealing with public paths" do
#     @controller = dispatch_to(MerbAdmin::Main, :index)
#
#     @controller.public_path_for(:image).should == "/slices/merb-admin/images"
#     @controller.public_path_for(:javascript).should == "/slices/merb-admin/javascripts"
#     @controller.public_path_for(:stylesheet).should == "/slices/merb-admin/stylesheets"
#
#     @controller.image_path.should == "/slices/merb-admin/images"
#     @controller.javascript_path.should == "/slices/merb-admin/javascripts"
#     @controller.stylesheet_path.should == "/slices/merb-admin/stylesheets"
#
#     @controller.app_path_for(:image).should == "#{Merb.root}/public/slices/merb-admin/images"
#     @controller.app_path_for(:javascript).should == "#{Merb.root}/public/slices/merb-admin/javascripts"
#     @controller.app_path_for(:stylesheet).should == "#{Merb.root}/public/slices/merb-admin/stylesheets"
#   end
#
# end
