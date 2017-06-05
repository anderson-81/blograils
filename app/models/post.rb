class Post < ActiveRecord::Base
  belongs_to :user
  validates :title, :briefing, :text, presence: true
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def getUserName
  	@user = User.find(self.user_id)
  	@user.email	
  end

  #Filter By Name
	def self.SearchTitle(query)
    print query
		@posts = Post.where("title like ?", "#{query}%")
 	end

end
