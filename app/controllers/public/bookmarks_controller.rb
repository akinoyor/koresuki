class Public::BookmarksController < ApplicationController
  def index
  end

  def create
    bookmark = Bookmark.new(user_id: current_user.id, post_id: params[:post_id])
    if bookmark.save
      flash[:notice] = "ブックマークしました。"
      redirect_to request.referer
    else
      flash[:notice] = "ブックマークできませんでした。"
      redirect_to request.referer

    end
  end

  def destroy
    bookmark = Bookmark.find_by(post_id: params[:post_id])
    if bookmark.destroy
      flash[:notice] = "ブックマークを解除しました。"
    redirect_to request.referer
    else
      flash[:notice] = "ブックマークの解除に失敗しました。"
      redirect_to request.referer
    end
  end
end
