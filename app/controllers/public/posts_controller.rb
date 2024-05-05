class Public::PostsController < ApplicationController
  def new
    @newpost = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      @user = current_user
      @newpost = Post.new
      @posts = Post.all
      render :index
    end
  end

  def index
    @newpost = Post.new
    @user = current_user
    @posts = Post.all

  end

  def show
  end

  def edit
  end

  private

  def post_params
    params.require(:post).permit(:body,:post_image)
  end
end
