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
      @posts = Post.all.order(udated_at: :desc)
      render :index
    end
  end

  def index
    @newpost = Post.new
    @user = current_user
    @posts = Post.all.order(updated_at: :desc)

  end

  def show
  end

  def edit
  end

  def destroy
    post = Post.find(params[:id])
    if post.user_id == current_user.id
      post.destroy
      redirect_to  request.referer
    end
  end

  private

  def post_params
    params.require(:post).permit(:body,:post_image)
  end
end
