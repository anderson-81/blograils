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
    @post.user_id = current_user.id
    @post
  end

  def edit
    @post = Post.find(params[:id])
    if !@post.user_id.equal? current_user.id
      flash[:danger] = "This post can't be edited or destroyed by this user."
      redirect_to post_path(@post)
    end
  end

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
      else
        format.html { render :new}
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.user_id.equal? current_user.id
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    else
      flash[:danger] = "This post can't be edited this user."
      redirect_to post_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user_id.equal? current_user.id
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      end
    else
      flash[:danger] = "This post can't be destroyed this user."
      redirect_to post_path(@post)
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
