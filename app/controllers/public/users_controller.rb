class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @newpost = params[:post_record] ? Post.new(post_record_params) : Post.new
    @user_posts = @user.posts.order(updated_at: :desc)
    bookmarks = Bookmark.where(user_id: params[:id]).order(updated_at: :desc)
    @bookmark_posts = bookmarks.map(&:post)
    follows = Follow.where(follower_id: params[:id])
    @followed_users = User.where(id: follows.pluck(:followed_id))
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

  def post_record_params
    params.require(:post_record).permit(:body, :image)
  end

end
