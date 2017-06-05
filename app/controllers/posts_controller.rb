class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_post, except: [:search]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @postall = Post.all.order(created_at: :desc)
    @postlast = @postall[0]
    @posts2 = @postall[1,2]
    @posts4 = @postall[3,4]
    if params[:search]
      @postlist = Post.where("title like ?", "#{params[:search]}%").paginate(:page => params[:page], :per_page => 1).order('created_at DESC')
    else
      @postlist = @postall.paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
    end
  end

  def show
  end

  def new
    @post = Post.new
    @user_id = current_user.id
  end

  def edit
    @post = Post.find(params[:id])
    @user_id = @post.user_id
  end

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        @user_id = current_user.id
        format.html { render :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Person was successfully updated.' }
      else
        @user = User.find(@post.user_id)
        @user_id = @user.id
        format.html { render :edit }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :briefing, :text, :user_id, :avatar)
    end
end
