class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  def create
    bookmark = Bookmark.new(user_id: current_user.id, post_id: params[:post_id])
    @user = User.find(params[:user_id])
    if bookmark.save
      @post_record = Post.find(bookmark.post_id)
      flash.now[:notice] = "ブックマークしました。"
      render "create.js.erb"
    else
      flash[:notice] = "ブックマークできませんでした。"
      redirect_to request.referer
    end
  end

  def destroy
    bookmark = Bookmark.find_by(post_id: params[:post_id])
    @post_record = Post.find(bookmark.post_id)
    @user = User.find(params[:user_id])
    if bookmark.destroy
      flash.now[:notice] = "ブックマークを解除しました。"
      render "destroy.js.erb"
    else
      flash[:notice] = "ブックマークの解除に失敗しました。"
      redirect_to request.referer
    end
  end
end
