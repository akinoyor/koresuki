class Public::UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @newpost = Post.new
    @bookmarks = Bookmark.where(user_id: params[:id]).order(updated_at: :desc)
    @bookmarkposts = @bookmarks.map(&:post)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end

end
