class Image
  include Mongoid::Document
  include Mongoid::Paperclip

  attr_accessible :file

  has_mongoid_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_presence :file
end
