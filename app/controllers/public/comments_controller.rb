class Public::CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :check_user, only: [:destroy]

  def show
    @newpost = Post.new
    @user = current_user
    @newcomment = Comment.new
    @newcomment.parent_comment_id = params[:id]
    @comment = Comment.find(params[:id])
  end

  def create
    origin_post = Post.find(params[:post_id])
    parent_comment_id = params[:comment][:parent_comment_id].present? ? params[:comment][:parent_comment_id] : 0
    comment = current_user.comments.new(comment_params)
    comment.parent_comment_id = parent_comment_id
    comment.post_id = origin_post.id
    if comment.save
      flash.now[:notice] = "コメントを投稿しました。"
      @newcomment = Comment.new
      @user = current_user
      # 親投稿がPostの時↓
      if comment.parent_comment_id == 0
        @parent_record = Post.find(comment.post_id)
        render 'post_comments_review.js.erb'
      # 親投稿がコメントの時↓
      else
        @parent_record = Comment.find(comment.parent_comment_id)
        render 'comments_review.js.erb'
      end

    else
      flash.now[:notice] = "コメントの投稿に失敗しました。"
      error_messages = comment.errors.full_messages.join('</br>')
      flash.now[:alert] = "#{error_messages}".html_safe
      render 'layouts/flashs'
    end
    # if comment.parent_comment_id == 0
    #   redirect_to  post_path(comment.post_id)
    # else
    #   redirect_to post_comment_path(comment.post_id,comment.parent_comment_id)
    # end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      flash[:notice] = "コメントを削除しました。"
    else
      flash[:notice] = "コメントの削除に失敗しました。"
    end
    if comment.parent_comment_id == 0
      redirect_to  post_path(comment.post_id)
    else
      redirect_to post_comment_path(comment.post_id,comment.parent_comment_id)
    end
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
