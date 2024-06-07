class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  def create
    bookmark = Bookmark.new(user_id: current_user.id, post_id: params[:post_id])
    if bookmark.save
      @post_record = Post.find(bookmark.post_id)
       respond_to do |format|
        format.html { redirect_to request.referer, notice: "ブックマークしました。" }
        format.js   # create.js.erb を呼び出す
      end
    else
      flash[:notice] = "ブックマークできませんでした。"
      redirect_to request.referer

    end
  end

  def destroy
    bookmark = Bookmark.find_by(post_id: params[:post_id])
    @post_record = Post.find(bookmark.post_id)
    if bookmark.destroy
      respond_to do |format|
        format.html { redirect_to request.referer, notice: "ブックマークを解除しました。" }
        format.js   # destroy.js.erb を呼び出す
      end
    else
      flash[:notice] = "ブックマークの解除に失敗しました。"
      redirect_to request.referer
    end
  end
end
