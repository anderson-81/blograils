class Post < ActiveRecord::Base
  #Relationship:

  belongs_to :user

  #Validations:

  validates :title, presence: true
  validates :briefing, presence: true
  validates :text, presence: true
  validates :avatar, presence: true
  validates :user_id, presence: true

  validates :title, length: { maximum: 45 }
  validates :briefing, length: { maximum: 70 }
  validates :text, length: { maximum: 3000 }

  has_attached_file :avatar, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage/
  validates_attachment_file_name :avatar, matches: [/png\z/, /jpe?g\z/]
  do_not_validate_attachment_file_type :avatar

  def getUserName
  	@user = User.find(self.user_id)
  	@user.email
  end

  #Filter By Name
	def self.SearchTitle(query)
		@posts = Post.where("title like ?", "#{query}%")
 	end

end
