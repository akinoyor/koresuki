class Public::CommentsController < ApplicationController

  def create
    parent_post = Post.find(params[:post_id])
    parent_comment_id = params[:comment][:parent_comment_id].present? ? params[:comment][:parent_comment_id] : 0
    puts "parent_comment_id: #{parent_comment_id}"
    comment = current_user.comments.new(comment_params)
    comment.parent_comment_id = parent_comment_id
    comment.post_id = parent_post.id
    comment.save
    redirect_to post_path(parent_post)
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user.id == current_user.id
      comment.destroy
      redirect_to  post_path(comment.post.id)
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
    params.require(:comment).permit(:body,:comment_image,:parent_comment_id)
  end
end
