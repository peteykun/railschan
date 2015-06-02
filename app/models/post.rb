class Post < ActiveRecord::Base
  has_attached_file :file, :styles => { :medium => "300x300>", :small => "150x150" }, :default_url => "/images/missing.png"
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :name, :subject, :comment

  belongs_to :parent,  class_name: 'Post'
  has_many   :replies, class_name: 'Post', foreign_key: 'parent_id'

  def width
    Paperclip::Geometry.from_file(self.file).width.to_i
  end

  def height
    Paperclip::Geometry.from_file(self.file).height.to_i
  end
end
