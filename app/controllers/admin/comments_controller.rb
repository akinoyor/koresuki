class Admin::CommentsController < ApplicationController
  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    if comment.parent_comment_id == 0
      redirect_to  post_path(comment.post_id),notice: 'コメントを削除しました。'
    else
      redirect_to post_comment_path(comment.post_id,comment.parent_comment_id),notice: 'コメントを削除しました。'
    end
  end
end
