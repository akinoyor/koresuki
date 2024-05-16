class Public::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :check_user, only: [:destroy]

  def create
    parent_post = Post.find(params[:post_id])
    parent_comment_id = params[:comment][:parent_comment_id].present? ? params[:comment][:parent_comment_id] : 0
    comment = current_user.comments.new(comment_params)
    comment.parent_comment_id = parent_comment_id
    comment.post_id = parent_post.id
    if comment.save
      flash[:notice] = "コメントを投稿しました。"
    else
      flash[:alert] = "コメントの投稿に失敗しました。"
    end
    if comment.parent_comment_id == 0
      redirect_to  post_path(comment.post_id)
    else
      redirect_to post_comment_path(comment.post_id,comment.parent_comment_id)
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      flash[:notice] = "コメントを削除しました。"
    else
      flash[:alert] = "コメントの削除に失敗しました。"
    end
    if comment.parent_comment_id == 0
      redirect_to  post_path(comment.post_id)
    else
      redirect_to post_comment_path(comment.post_id,comment.parent_comment_id)
    end
  end


  def show
    @newpost = Post.new
    @user = current_user
    @newcomment = Comment.new
    @newcomment.parent_comment_id = params[:id]
    @comment = Comment.find(params[:id])
  end



  private
  def comment_params
    params.require(:comment).permit(:body,:image,:parent_comment_id)
  end

   def check_user
    @comment = Comment.find(params[:id])
    unless @comment.user = current_user
      redirect_to posts_path
    end
  end
end
